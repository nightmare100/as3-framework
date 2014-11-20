package com.aspectgaming.ui.event
{
	import flash.events.Event;
	
	public class SplitPageEvent extends Event
	{
		public static const ON_PAGE_CHANGED:String = "onPageChanged";
		public function SplitPageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}