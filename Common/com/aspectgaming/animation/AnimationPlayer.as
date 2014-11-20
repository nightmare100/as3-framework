package com.aspectgaming.animation
{
	import com.aspectgaming.animation.data.AnimationInfo;
	import com.aspectgaming.animation.event.AnimationEvent;
	import com.aspectgaming.animation.iface.IAnimation;
	
	import flash.utils.Dictionary;
	
	/**
	 * 公用动画播放器 (矢量 | 位图帧) 
	 * @author mason.li
	 * 
	 */	
	public class AnimationPlayer
	{
		/**
		 * 播放矢量动画 
		 * @param type				  资源名称
		 * @param callBack		           动画播完后回调
		 * @param singleInstance  	 是否使用单列动画
		 * @param keyFunc			关键帧事件  object 结构  frame <=> function
		 * 
		 */		
		public static function play(type:String, callBack:Function = null, times:uint = 1, keyFunc:Object = null, isSingleInstance:Boolean = true):void
		{
			var animationInfo:AnimationInfo = AnimationFactory.getAnimationInfo(type, callBack, times, keyFunc, isSingleInstance);
			var animation:IAnimation = animationInfo.animation;
			
			animation.start();
			animation.addEventListener(AnimationEvent.ANIMATION_COMPLETE, onComplete);
		}
		
		private static function onComplete(e:AnimationEvent):void
		{
			var target:IAnimation = e.currentTarget as IAnimation;
			target.removeEventListener(AnimationEvent.ANIMATION_COMPLETE, onComplete);
			
			var info:AnimationInfo = AnimationFactory.getExistInfo(target.type) || AnimationFactory.getExistInfo(target);
			if (info.callBack != null)
			{
				info.callBack();
			}
		}
	}
}