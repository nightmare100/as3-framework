package com.aspectgaming.event
{
	import com.aspectgaming.event.base.BaseEvent;
	
	import flash.display.InteractiveObject;
	
	/**
	 * 大厅消息模块内部事件 
	 * @author mason.li
	 * 
	 */	
	public class MessageEvent extends BaseEvent
	{
		public static const MESSAGE_TO_GAME:String = "messageToGame";
		public static const MESSAGE_TO_USER:String = "messageToUser";
		public static const CLEAR_ALL_VIEW:String = "clearAllView";
		
		public var interTarget:InteractiveObject;
		
		public function MessageEvent(type:String, data:*=null, content:String=null, mouseTarget:InteractiveObject = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
			interTarget = mouseTarget;
		}
	}
}