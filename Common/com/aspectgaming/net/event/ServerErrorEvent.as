package com.aspectgaming.net.event
{
	import flash.events.Event;
	
	/**
	 * 服务器错误事件 
	 * @author mason.li
	 * 
	 */	
	public class ServerErrorEvent extends Event
	{
		public static const SOAP_REQUEST_ERROR:String = "soapRequestError";
		public static const SOCKET_ERROR:String = "socketError";
		public static const AMF_ERROR:String = "amfError";
		/**
		 *reconnet 断线 前抛事件。 用于断线时候清除 新手指导 symbolmask 
		 */		
		public static const BEFORE_AMF_ERROR:String = "beforeAmfError";
		
		private var _reqName:String;
		
		public function ServerErrorEvent(type:String, req:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_reqName = req;
		}

		public function get reqName():String
		{
			return _reqName;
		}

	}
}