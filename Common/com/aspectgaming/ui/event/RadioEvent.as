package com.aspectgaming.ui.event
{
	import flash.events.Event;
	
	/**
	 * Radio && RadioGroup事件  
	 * @author mason.li
	 * 
	 */	
	public class RadioEvent extends Event
	{
		public static const RADIO_SELECTED:String = "radioSelected";
		public static const RADIO_GROUP_CHANGED:String = "radioChanged";
		
		public var index:uint;
		
		public function RadioEvent(type:String, idx:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			index = idx;
		}
		
		override public function clone():Event
		{
			return new RadioEvent(type, index);
		}
	}
}