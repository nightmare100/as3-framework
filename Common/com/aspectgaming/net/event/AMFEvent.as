package com.aspectgaming.net.event
{
	import flash.events.Event;
	
	public class AMFEvent extends Event
	{
		public static const ON_DATA:String = "onData";
		public static const ON_PROGRESS:String = "onProgress";
		public static const PARSE_ERROR:String = "parseError";
		public static const RESPONSE_ERROR:String = "responseError";
		
		/**
		 * rpc 
		 */		
		public var req:String;		
		public var parm:Object;
		private var _data:*;
		
		public function AMFEvent(type:String, info:* = null, func:String = null, mparm:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
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

	}
}