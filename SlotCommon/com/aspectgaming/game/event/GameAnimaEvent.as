package com.aspectgaming.game.event
{
	import com.aspectgaming.event.base.BaseEvent;
	
	public class GameAnimaEvent extends BaseEvent
	{
		public static const ANIMATION_COMPLETE:String = "animationComplete";
		public static const ANIMATION_HALF:String = "animationHalf";
		
		public function GameAnimaEvent(type:String, data:*=null, content:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
		}
	}
}