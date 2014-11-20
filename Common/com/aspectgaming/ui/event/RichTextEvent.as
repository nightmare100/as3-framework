package com.aspectgaming.ui.event
{
	import flash.events.Event;
	
	public class RichTextEvent extends Event
	{
		/**
		 * 按回车 
		 */		
		public static const ENTER_INPUT:String = "enterInput";
		
		public static const TEXT_CHANGED:String = "textChanged";
		
		
		public var text:String;
		public var textInfo:*;
		public function RichTextEvent(type:String, str:String = null, info:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			text = str;
			textInfo = info;
		}
	}
}