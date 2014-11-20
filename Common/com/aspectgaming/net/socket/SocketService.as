package com.aspectgaming.net.socket
{
	import avmplus.getQualifiedClassName;
	
	import com.aspectgaming.core.IParse;
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.net.constant.ProtoTransType;
	import com.aspectgaming.net.data.BlockInfoManager;
	import com.aspectgaming.net.data.MessageInfo;
	import com.aspectgaming.net.event.ServerEvent;
	import com.aspectgaming.net.event.SocketEvent;
	import com.aspectgaming.net.mapping.ClassRegister;
	import com.aspectgaming.utils.LoggerUtil;
	import com.aspectgaming.utils.constant.LogType;
	import com.aspectgaming.utils.tick.Tick;
	import com.netease.protobuf.Message;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	[Event(name="onData", type="com.aspectgaming.net.event.ServerEvent")]
	[Event(name="onConnect", type="com.aspectgaming.net.event.ServerEvent")]
	[Event(name="onClose", type="com.aspectgaming.net.event.ServerEvent")]
	[Event(name="onError", type="com.aspectgaming.net.event.ServerEvent")]
	
	/**
	 * Socket 收发器 
	 * 解析器操作
	 * 新增block/release Command
	 * @author mason.li
	 * 
	 */	
	public class SocketService extends EventDispatcher implements IServer
	{
		private var _socketImpl:SocketConnection;
		private var _parse:IParse;

		/**
		 * 重连尝试次数 
		 */
		public function set retryTimes(value:uint):void
		{
			_retryTimes = value;
		}

		public function set heartCmdID(value:uint):void
		{
			_heartCmdID = value;
		}

		/**
		 * 心跳包周期 
		 */
		public function set heartDelay(value:uint):void
		{
			_heartDelay = value;
		}

		private var _logger:Function;
		private var _isEncode:Boolean;
		
		private var _blockList:Dictionary;
		
		private var _heartDelay:uint;
		private var _heartCmdID:uint;
		
		private var _retryTimes:uint;
		
		private var _currentRetryTimes:uint;
		
		/**
		 * 本次断线是否启用重连机制 
		 */		
		private var _isRetry:Boolean
		
		/**
		 * 心跳计数 
		 */		
		private var _heartCount:int;
		
		/**
		 * 心跳N次未收到 标示为断线 
		 */		
		private const HEART_TIMEOUT:uint = 3;
		
		
		public function SocketService(heartCmdID:uint = 19909, heartDelay:uint = 15, retry:uint = 3)
		{
			_heartDelay = heartDelay;
			_heartCmdID = heartCmdID;
			_retryTimes = retry;
			_blockList = new Dictionary();
			_socketImpl = new SocketConnection();
			_socketImpl.addEventListener(SocketEvent.ON_CLOSE, onSocketClose);
			_socketImpl.addEventListener(SocketEvent.ON_CONNECT, onSocketConnect);
			_socketImpl.addEventListener(SocketEvent.SOCKET_ERROR, onSocketError);
				
		}
		
		public function sendRequest(req:String, parm:Object=null):void
		{
			var cmd:int = req == _heartCmdID.toString()? _heartCmdID : ClassRegister.getCmd(req, ProtoTransType.Request);
			if (_parse)
			{
				parm = _parse.parseRequestData(req, parm);
			}
			
			var message:Message = parm as Message;
			var byteArray:ByteArray = new ByteArray();
			if (message)
			{
				message.writeTo(byteArray);
			}
			
			//过滤心跳日志
			if (cmd != _heartCmdID)
			{
				log(LogType.OUTPUT, parm, req);
				LoggerUtil.traceNormal("[SocketOutPut] cmd:", cmd, " len:" , byteArray.length, " desc:", ClassRegister.getMessageDesc(req));
			}
			_socketImpl.send(cmd, byteArray);
		}
		
		private function log(type:String, o:*, head:String = ""):void
		{
			if (_logger != null)
			{
				_logger(o, LogType.LOG_SOCKET + " " + type, head);
			}
		}
		
		public function init(appurl:String, isEncode:Boolean, parse:IParse=null, logFunc:Function = null,  type:String = "AMF"):void
		{
			_logger = logFunc;
			_isEncode = isEncode;
			_parse = parse;
			
			var serverInfo:Array = appurl.split(":");
			_socketImpl.host = serverInfo[0];
			_socketImpl.port = uint(serverInfo[1]);
		}
		
		
		
		public function connect():void
		{
			LoggerUtil.traceNormal("[SocketConnecting] ip:", _socketImpl.host, " port:" , _socketImpl.port);
			_socketImpl.connect();
			_socketImpl.addEventListener(SocketEvent.ON_CONNECT_TIMEOUT, onConnectTimeout);
			_socketImpl.addEventListener(SocketEvent.ON_DATA, onData);
			_isRetry = false;
		}
		
		private function onConnectTimeout(e:SocketEvent):void
		{
			_socketImpl.removeEventListener(SocketEvent.ON_DATA, onData);
			checkRetry();
			dispatchEvent(new ServerEvent(ServerEvent.ON_TIMEOUT, _currentRetryTimes, null, _isRetry));
		}
		
		/**
		 * 数据转换 
		 * @param e
		 * 
		 */		
		private function onData(e:SocketEvent):void
		{
			var protoName:String = ClassRegister.getProxyName(e.cmd);
			var backVo:* = ClassRegister.transferToMessage(protoName, e.info);
			if (_blockList[protoName])
			{
				BlockInfoManager.addBlockInfo(protoName, new MessageInfo(e.cmd.toString(), backVo));
				return;
			}
			
			
			if (_parse)
			{
				_parse.parseResponse(protoName, backVo);
			}
			
			if (e.cmd != _heartCmdID)
			{
				LoggerUtil.traceNormal("[SocketInput] cmd:", e.cmd, " len:" , e.info.length, " desc:", ClassRegister.getMessageDesc(protoName));
				log(LogType.INPUT, backVo, protoName);
				dispatchEvent(new ServerEvent(ServerEvent.ON_DATA, backVo, protoName));
			}
			_heartCount = 0;
		}
		
		public function close():void
		{
			try
			{
				_socketImpl.close();
			}
			catch (e:Error)
			{
				LoggerUtil.traceNormal("[SocketCloseError]")
			}
		}
		
		public function blockCommand(req:String):void
		{
			_blockList[req] = true;
		}
		
		public function releaseCommand(req:String):void
		{
			delete _blockList[req];
			var list:Vector.<MessageInfo> = BlockInfoManager.releaseInfo(req);
			if (list)
			{
				for each (var info:MessageInfo in list)
				{
					if (_parse)
					{
						_parse.parseResponse(info.req, info.response);
					}
					
					log(LogType.INPUT, info.response, info.req);
					dispatchEvent(new ServerEvent(ServerEvent.ON_DATA, info.response, info.req))
				}
			}
		}
		
		
		/**
		 * 连接中断 
		 * @param e
		 * 
		 */		
		private function onSocketClose(e:SocketEvent):void
		{
			log(LogType.CLOSE, null);
			_socketImpl.removeEventListener(SocketEvent.ON_DATA, onData);
			Tick.removeTimeInterval(getQualifiedClassName(this));
			
			var isManualClose:Boolean = Boolean(e.info);
			if (!isManualClose)
			{
				checkRetry();
			}
			
			dispatchEvent(new ServerEvent(ServerEvent.ON_CLOSE, isManualClose, _currentRetryTimes.toString(), _isRetry));
		}
		
		protected function checkRetry():void
		{
			_currentRetryTimes++;
			if (_currentRetryTimes <= _retryTimes)
			{
				connect();
				_isRetry = true;
			}
			else
			{
				_isRetry = false;
			}
		}
		
		private function onSocketConnect(e:SocketEvent):void
		{
			log(LogType.CONNECT, null);
			dispatchEvent(new ServerEvent(ServerEvent.ON_CONNECT));
			Tick.addTimeInterval(heartSend, _heartDelay, getQualifiedClassName(this));
			_currentRetryTimes = 0;
		}
		
		/**
		 * 发送心跳 
		 * 
		 */		
		protected function heartSend():void
		{
			if (++_heartCount >= HEART_TIMEOUT)
			{
				_heartCount = 0;
				_socketImpl.close(false);
				return;
			}
			sendRequest(_heartCmdID.toString());
		}
		
		private function onSocketError(e:SocketEvent):void
		{
			dispatchEvent(new ServerEvent(ServerEvent.ON_ERROR, e.message));
		}
		
		public function dispose():void
		{
			Tick.removeTimeInterval(getQualifiedClassName(this));
			_parse = null;
			_blockList = null;
			_socketImpl.removeEventListener(SocketEvent.ON_CLOSE, onSocketClose);
			_socketImpl.removeEventListener(SocketEvent.ON_CONNECT, onSocketConnect);
			_socketImpl.removeEventListener(SocketEvent.SOCKET_ERROR, onSocketError);
			_socketImpl.removeEventListener(SocketEvent.ON_DATA, onData);
			_socketImpl.removeEventListener(SocketEvent.ON_CONNECT_TIMEOUT, onConnectTimeout);
			_socketImpl.dispose();
			_socketImpl = null;
		}
	}
}