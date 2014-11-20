package com.aspectgaming.animation.sheet
{
	import com.aspectgaming.animation.event.AnimationEvent;
	import com.aspectgaming.animation.iface.IAnimation;
	import com.aspectgaming.constant.global.SoundDefine;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 基础位图序列帧动画 
	 * @author mason.li
	 * 
	 */	
	[Event(name="AnimationComplete", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationStop", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationStart", type="com.aspectgaming.animation.event.AnimationEvent")]
	public class BaseSheetAnimation extends EventDispatcher implements IAnimation
	{
		protected var _sheetPlayer:SheetPlayer;
		
		public function BaseSheetAnimation(mc:MovieClip, times:int = 1, palette:Object = null)
		{
			_sheetPlayer = new SheetPlayer(mc, times, palette);
			_sheetPlayer.addEventListener(AnimationEvent.ANIMATION_COMPLETE, onAnimationInfo);
			_sheetPlayer.addEventListener(AnimationEvent.ANIMATION_START, onAnimationInfo);
			_sheetPlayer.addEventListener(AnimationEvent.ANIMATION_STOP, onAnimationInfo);
			
		}
		
		protected function onAnimationInfo(e:AnimationEvent):void
		{
			if (e.type == AnimationEvent.ANIMATION_COMPLETE)
			{
				DisplayUtil.removeFromParent(_sheetPlayer);
			}
			dispatchEvent(e.clone());
		}
		
		public function start():void
		{
			if (_sheetPlayer.isComplete)
			{
				LayerManager.topLayer.addChild(_sheetPlayer);
			}
			_sheetPlayer.start();
		}
		
		public function restart():void
		{
			_sheetPlayer.restart();
		}
		
		public function stop():void
		{
			_sheetPlayer.stop();
		}
		
		public function gotoAndStop(frame:uint):void
		{
			_sheetPlayer.gotoAndStop(frame);
		}
		
		public function gotoAndPlay(frame:uint):void
		{
			_sheetPlayer.gotoAndPlay(frame);
		}
		
		public function get currentFrame():uint
		{
			return _sheetPlayer.currentFrame;
		}
		
		public function set playTimes(times:int):void
		{
			_sheetPlayer.playTimes = times;
		}
		
		public function get currentRound():uint
		{
			return _sheetPlayer.currentRound;
		}
		
		public function get isLoop():Boolean
		{
			return _sheetPlayer.isLoop;
		}
		
		public function get type():String
		{
			return _sheetPlayer.type;
		}
		
		public function set type(value:String):void
		{
			_sheetPlayer.type = value;
		}
		
		public function addFrameScript(m:uint, callBack:Function):void
		{
			_sheetPlayer.addFrameScript(m, callBack);
		}
		
		public function clearFrameScript():void
		{
			_sheetPlayer.clearFrameScript();
		}
		
		public function dispose():void
		{
			_sheetPlayer.removeEventListener(AnimationEvent.ANIMATION_COMPLETE, onAnimationInfo);
			_sheetPlayer.removeEventListener(AnimationEvent.ANIMATION_START, onAnimationInfo);
			_sheetPlayer.removeEventListener(AnimationEvent.ANIMATION_STOP, onAnimationInfo);
			_sheetPlayer.dispose();
			_sheetPlayer = null;
		}
		
		public function hide():void
		{
			_sheetPlayer.hide();
		}
	}
}