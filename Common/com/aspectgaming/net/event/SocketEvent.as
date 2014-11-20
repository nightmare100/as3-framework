package com.aspectgaming.net.event
{
	import flash.events.Event;
	
	/**
	 * Scoket通信事件 底层使用 
	 * @author mason.li
	 * 
	 */	
	public class SocketEvent extends Event
	{
		public static const ON_DATA:String = "onData";
		public static const ON_CLOSE:String = "onClose";
		public static const ON_CONNECT:String = "onConnect";
		public static const ON_CONNECT_TIMEOUT:String = "onConnectTimeout";
		public static const SOCKET_ERROR:String = "socketError";
		
		private var _info:*;
		private var _cmd:uint;
		private var _message:String;
		
		public function SocketEvent(type:String, msg:String = null, cmd:uint = 0, info:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_info = info;
			_message = msg;
			_cmd = cmd;
		}

		public function get message():String
		{
			return _message;
		}

		/**
		 * 数据类型 
		 * @return 
		 * 
		 */		
		public function get cmd():uint
		{
			return _cmd;
		}

		public function get info():*
		{
			return _info;
		}

	}
}