package com.aspectgaming.net.socket
{
	import com.aspectgaming.net.event.SocketEvent;
	import com.aspectgaming.utils.LoggerUtil;
	import com.aspectgaming.utils.constant.LogType;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * Socket底层组合 
	 * @author mason.li
	 * 
	 */	
	[Event(name="onData", type="com.aspectgaming.net.event.SocketEvent")]
	[Event(name="onClose", type="com.aspectgaming.net.event.SocketEvent")]
	[Event(name="onConnect", type="com.aspectgaming.net.event.SocketEvent")]
	[Event(name="socketError", type="com.aspectgaming.net.event.SocketEvent")]
	[Event(name="onConnectTimeout", type="com.aspectgaming.net.event.SocketEvent")]
	internal class SocketConnection extends EventDispatcher
	{
		public static const PACKAGE_MAX:uint = 0xFFFFFFFF;
		private const CONNECT_TIME_OUT:uint = 20000;
		private var _timeOutTick:int;
		
		private var _host:String;
		private var _port:uint;
		private var _socket:Socket;
		
		/**
		 * 包长 
		 */		
		private var _bodyLen:uint;
		
		/**
		 * 当前解析的数据类型号 
		 */		
		private var _cmd:uint;
		
		/**
		 * 包头长 
		 */		
		private const HEAD_LEN:uint = 8;
		
		/**
		 * 包头是否读完
		 */		
		private var _isHeadReaded:Boolean;

		/**
		 * 是否客户端主动断开 
		 */		
		private var _isManualClose:Boolean;
		
		public function SocketConnection()
		{
			_socket = new Socket();
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
		}
		
		public function get host():String
		{
			return _host;
		}

		public function get port():uint
		{
			return _port;
		}

		public function set port(value:uint):void
		{
			_port = value;
		}

		public function set host(value:String):void
		{
			_host = value;
		}

		public function get isConnected():Boolean
		{
			return _socket.connected;
		}
		
		public function send(cmd:uint, data:ByteArray):void
		{
			//parse Package Head
			_socket.writeUnsignedInt(cmd);
			_socket.writeUnsignedInt(data.length);
			
			//parse Package Body
			_socket.writeBytes(data);
			
			_socket.flush();
		}
		
		public function connect():void
		{
			_socket.addEventListener(Event.CONNECT, onConnected);
			_socket.addEventListener(Event.CLOSE, onClose);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.connect(_host, _port);
			_timeOutTick = setTimeout(onTimeOut, CONNECT_TIME_OUT);
		}
		
		private function onTimeOut():void
		{
			dispatchEvent(new SocketEvent(SocketEvent.ON_CONNECT_TIMEOUT));
		}
		
		private function onConnected(e:Event):void
		{
			clearTimeout(_timeOutTick);
			_socket.removeEventListener(Event.CONNECT, onConnected);
			dispatchEvent(new SocketEvent(SocketEvent.ON_CONNECT));
		}
		
		private function onClose(e:Event):void
		{
			_socket.removeEventListener(Event.CLOSE, onClose);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			dispatchEvent(new SocketEvent(SocketEvent.ON_CLOSE, null, 0, _isManualClose));
			_isManualClose = false;
		}
		
		private function onSocketData(e:ProgressEvent):void
		{
			while (_socket.bytesAvailable > 0 && ((_isHeadReaded && _socket.bytesAvailable >= _bodyLen) || !_isHeadReaded))
			{
				if (!_isHeadReaded)
				{
					if (_socket.bytesAvailable >= HEAD_LEN)
					{
						//处理包头
						_cmd = _socket.readUnsignedInt();
						_bodyLen = _socket.readUnsignedInt();
						/*if (HEAD_LEN - 4 > 0)
						{
							_socket.readBytes(new ByteArray, 0, HEAD_LEN - 4);
						}*/
						if (_bodyLen > PACKAGE_MAX)
						{
							dispatchEvent(new SocketEvent(SocketEvent.SOCKET_ERROR, "Package Length Error"));
							_socket.readBytes(new ByteArray());
							return;
						}
						
						if (_bodyLen == 0)
						{
//							dispatchEvent(new SocketEvent(SocketEvent.SOCKET_ERROR, "Body Length is Zero"));
							dispatchEvent(new SocketEvent(SocketEvent.ON_DATA, null, _cmd, null));
							if (_socket.connected)
							{
								continue;
							}
							else
							{
								break;
							}
						}
						else
						{
							_isHeadReaded = true;
						}
					}
					else
					{
						break;
					}
				}
				
				//处理包体
				if (_socket.bytesAvailable >= _bodyLen)
				{
					var bodyByteArray:ByteArray = new ByteArray();
					_socket.readBytes(bodyByteArray, 0, _bodyLen);
					LoggerUtil.traceNormal("backDataPostion", bodyByteArray.position);
					_isHeadReaded = false;
					dispatchEvent(new SocketEvent(SocketEvent.ON_DATA, null, _cmd, bodyByteArray));
					if (!_socket.connected)
					{
						break;
					}
				}
			}
		}
		
		private function onError(e:Event):void
		{
			dispatchEvent(new SocketEvent(SocketEvent.SOCKET_ERROR, e.type));
		}
		
		/**
		 * 客户端主动关闭连接 
		 * 
		 */		
		public function close(isManual:Boolean = true):void
		{
			_isManualClose = isManual;
			if (_socket.connected)
			{
				_socket.close();
				onClose(null);
			}
		}
		
		public function dispose():void
		{
			clearTimeout(_timeOutTick);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.removeEventListener(Event.CONNECT, onConnected);
			_socket.removeEventListener(Event.CLOSE, onClose);
			close();
			_socket = null;
		}
	}
}