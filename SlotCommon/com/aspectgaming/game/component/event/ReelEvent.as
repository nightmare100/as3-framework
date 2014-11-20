package com.aspectgaming.game.component.event
{
	import com.aspectgaming.event.base.BaseEvent;
	
	public class ReelEvent extends BaseEvent
	{
		public static const REEL_START:String = "reelStart";
		public static const REEL_END:String = "reelEnd";
		public static const REEL_BEFORE_STOP:String = "reelBeforeStop";
		public static const REEL_STOP:String = "reelStop";
		
		public function ReelEvent(type:String, data:*=null, content:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
		}
		
		
	}
}