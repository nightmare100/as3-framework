package com.aspectgaming.animation.event
{
	import flash.events.Event;
	
	/**
	 * 动画播放事件 
	 * @author mason.li
	 * 
	 */	
	public class AnimationEvent extends Event
	{
		/**
		 * 动画播放完成 
		 */		
		public static const ANIMATION_COMPLETE:String = "AnimationComplete";
		
		/**
		 * 播放暂停 
		 */		
		public static const ANIMATION_STOP:String = "AnimationStop";
		
		/**
		 * 动画播放开始 
		 */		
		public static const ANIMATION_START:String = "AnimationStart";		
		
		/**
		 * 动画播放一半 
		 */		
		public static const ANIMATION_HALF:String = "AnimationHalf";
		
		public function AnimationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new AnimationEvent(type, bubbles, cancelable);
		}
	}
}