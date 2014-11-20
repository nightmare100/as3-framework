package com.aspectgaming.ui.event
{
	import flash.events.Event;
	
	public class SlideBarEvent extends Event
	{
		public static const BAR_SLIDE:String = "barSlide";
		
		public var tick:Number;
		
		public function SlideBarEvent(type:String, n:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			tick = n;
		}
	}
}