package com.aspectgaming.event
{
	import flash.events.Event;
	
	/**
	 * 全局消息事件 
	 * @author mason.li
	 * 
	 */	
	public class NotifyEvent extends Event
	{
		public static const ON_NOTIFY:String = "onNotify";
		public static const ON_NOTIFY_DEL:String = "onNotifyDelete";
		
		public static const ON_NOTIFYVIEW_CLOSE:String = "onNotifyViewClose";
		public static const ON_NOTIFYVIEW_SHOW:String = "onNotifyViewShow";
		
		public var noteName:String;
		public var noteInfo:*;
		
		public function NotifyEvent(type:String, notifyName:String, notifyData:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			noteName = notifyName;
			noteInfo = notifyData;
		}
	}
}