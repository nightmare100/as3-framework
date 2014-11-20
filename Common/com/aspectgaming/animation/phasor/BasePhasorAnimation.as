package com.aspectgaming.animation.phasor
{
	import com.aspectgaming.animation.event.AnimationEvent;
	import com.aspectgaming.animation.iface.IAnimation;
	import com.aspectgaming.constant.global.SoundDefine;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.MovieClipUtil;
	import com.aspectgaming.utils.tick.FrameRender;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 基础矢量动画 
	 * @author mason.li
	 * 
	 */
	[Event(name="AnimationComplete", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationStop", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationStart", type="com.aspectgaming.animation.event.AnimationEvent")]
	public class BasePhasorAnimation extends EventDispatcher implements IAnimation
	{
		private var _mc:MovieClip;
		private var _isComplete:Boolean = true;
		protected var _type:String;
		protected var _isStop:Boolean;
		
		/**
		 * 播放次数 -1 为无限 
		 */		
		private var _playTimes:int;
		private var _currentRound:uint;
		
		public function BasePhasorAnimation(mc:MovieClip, times:int = 1) 
		{
			_mc = mc;
			_mc.mouseEnabled = false;
			_mc.mouseChildren = false;
			_playTimes = times;
		}
		
		public function set isStop(value:Boolean):void
		{
			_isStop = value;
			if (_isStop)
			{
				FrameRender.removeRender(onEnterFrame);
			}
			else
			{
				FrameRender.addRender(onEnterFrame);
			}
		}

		/**
		 * 当前播放次数 
		 * @return 
		 * 
		 */		
		public function get currentRound():uint
		{
			return _currentRound;
		}

		/**
		 * 是否为循环动画 
		 * @return 
		 * 
		 */		
		public function get isLoop():Boolean
		{
			return _playTimes == -1;
		}
		
		public function set playTimes(times:int):void
		{
			if (_isComplete)
			{
				_playTimes = times;
			}
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function clearFrameScript():void
		{
			MovieClipUtil.clearFrameCode(_mc);
		}
		
		/**
		 * 重新开始 
		 * 
		 */		
		public function restart():void
		{
			_isComplete = true;
			isStop = true;
			_mc.stop();
			start();
		}

		public function start():void
		{
			if (_isComplete)
			{
				_currentRound = 1;
				initMC();
				dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_START));
			}
			else if (_isStop)
			{
				isStop = false;
				_mc.play();
			}
		}
		
		public function addFrameScript(m:uint, callBack:Function):void
		{
			_mc.addFrameScript(m, callBack);
		}
		
		public function get currentFrame():uint
		{
			return _mc.currentFrame;
		}
		
		public function gotoAndPlay(frame:uint):void
		{
			_mc.gotoAndPlay(frame);
			isStop = false;
		}
		
		public function gotoAndStop(frame:uint):void
		{
			_mc.gotoAndStop(frame);
			isStop = true;
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_STOP));
		}
		
		public function stop():void
		{
			_mc.stop();
			isStop = true;
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_STOP));
		}

		protected function initMC():void
		{
			LayerManager.topLayer.addChild(_mc);
			_isComplete = false;
			isStop = false;
			
			FrameRender.addRender(onEnterFrame);
			_mc.gotoAndPlay(1);
		}
		
		private function onEnterFrame():void 
		{
			if (_mc.currentFrame >= _mc.totalFrames) 
			{
				if (_currentRound == _playTimes)
				{
					_mc.stop();
					DisplayUtil.removeFromParent(_mc);
					_isComplete = true;
					isStop = true;
					dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE));
				}
				else
				{
					_currentRound++;
				}
			}
		}
		
		public function dispose():void
		{
			FrameRender.removeRender(onEnterFrame);
			_mc.stop();
			DisplayUtil.removeFromParent(_mc);
		}
		
		public function hide():void
		{
			DisplayUtil.removeFromParent(_mc);
			stop();
		}
	}

}