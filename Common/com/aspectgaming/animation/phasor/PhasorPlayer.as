package com.aspectgaming.animation.phasor
{
	import com.aspectgaming.animation.event.AnimationEvent;
	import com.aspectgaming.animation.iface.IAnimation;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.MovieClipUtil;
	import com.aspectgaming.utils.tick.FrameRender;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 影片剪切播放器 
	 * @author mason.li
	 * 
	 */	
	[Event(name="AnimationComplete", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationHalf", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationStop", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationStart", type="com.aspectgaming.animation.event.AnimationEvent")]
	public class PhasorPlayer extends EventDispatcher implements IAnimation
	{
		protected var _mc:MovieClip;
		private var _playTimes:int;
		private var _currentRound:uint;
		
		private var _isComplete:Boolean = true;
		protected var _isStop:Boolean;
		
		private var _isAutoRemove:Boolean;
		
		public function PhasorPlayer(mc:MovieClip, x:Number = 0, y:Number = 0, times:int = 1)
		{
			_mc = mc;
			_mc.x = x;
			_mc.y = y;
			_mc.gotoAndStop(1);
			_playTimes = times;
		}
		
		public function get mc():MovieClip
		{
			return _mc;
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

		public function show(par:DisplayObjectContainer, autoPlay:Boolean = true, autoRemove:Boolean = true):void
		{
			_isAutoRemove = autoRemove;
			par.addChild(_mc);
			if (autoPlay)
			{
				start();
			}
		}
		
		public function addFrameScript(m:uint, callBack:Function):void
		{
			_mc.addFrameScript(m, callBack);
			
		}
		
		public function clearFrameScript():void
		{
			MovieClipUtil.clearFrameCode(_mc);
			
		}
		
		public function get currentFrame():uint
		{
			return _mc.currentFrame;
		}
		
		public function get totalFrames():uint{
			return _mc.totalFrames;
		}
		
		public function get currentRound():uint
		{
			return _currentRound;
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
				
				_isComplete = false;
				isStop = false;
				
				_mc.gotoAndPlay(1);
				dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_START));
			}
			else if (_isStop)
			{
				isStop = false;
				_mc.play();
			}
		}
		
		protected function onEnterFrame():void
		{
			if (_mc.currentFrame >= _mc.totalFrames) 
			{
				if (_currentRound == _playTimes)
				{
					_mc.stop();
					if (_isAutoRemove)
					{
						DisplayUtil.removeFromParent(_mc);
					}
					_isComplete = true;
					isStop = true;
					dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE));
					return;
				}
				else
				{
					_currentRound++;
				}
			}
			
			if (_mc.currentFrame == uint(_mc.totalFrames / 2))
			{
				dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_HALF));
			}
		}
		
		public function stop():void
		{
			_mc.stop();
			isStop = true;
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_STOP));
		}
		
		public function get type():String
		{
			return null;
		}
		
		
		public function dispose():void
		{
			FrameRender.removeRender(onEnterFrame);
			_mc.stop();
			DisplayUtil.removeFromParent(_mc);
			_mc = null;
		}
		
		public function hide():void
		{
			DisplayUtil.removeFromParent(_mc);
			stop();
		}
		
	}
}