package com.aspectgaming.net.event
{
	import flash.events.Event;

	public class ServerEvent extends Event
	{
		public static const ON_DATA:String = "onData";
		public static const ON_ERROR:String = "onError";
		public static const ON_CONNECT:String = "onConnect";
		public static const ON_PROGRESS:String = "onProgress";
		public static const ON_CLOSE:String = "onClose";
		
		/**
		 * 超时 
		 */		 
		public static const ON_TIMEOUT:String = "onTimeOut";
		
		public var req:String;		//请求REQUEST名称
		public var parm:Object;
		private var _data:*;
		
		public function ServerEvent(type:String, info:* = null, func:String = null, mparm:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = info;
			req = func;
			parm = mparm;
		}
		
		
		public function get data():*
		{
			return _data;
		}
		
		override public function clone():Event
		{
			return new ServerEvent(this.type, _data, req, parm, bubbles, cancelable);
		}
		
		
		
	}
}