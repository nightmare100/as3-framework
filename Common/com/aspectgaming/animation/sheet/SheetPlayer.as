package com.aspectgaming.animation.sheet
{
	import com.aspectgaming.animation.data.FramesVO;
	import com.aspectgaming.animation.data.SheetVO;
	import com.aspectgaming.animation.event.AnimationEvent;
	import com.aspectgaming.animation.iface.IAnimation;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.MovieClipUtil;
	import com.aspectgaming.utils.tick.FrameRender;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 序列帧动画 基类 
	 * @author mason.li
	 * 
	 */	
	[Event(name="AnimationComplete", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationHalf", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationStop", type="com.aspectgaming.animation.event.AnimationEvent")]
	[Event(name="AnimationStart", type="com.aspectgaming.animation.event.AnimationEvent")]
	public class SheetPlayer extends Sprite implements IAnimation
	{
		private var _isComplete:Boolean = true;
		protected var _type:String;
		
		/**
		 * 播放次数 -1 为无限 
		 */		
		private var _playTimes:int;
		
		/**
		 * 当前播放的回数 
		 */		
		protected var _currentRound:uint;
		
		protected var _currentFrame:uint;
		
		/**
		 * 关键帧函数组 
		 */		
		protected var _keyFrameObject:Object;
		
		protected var _isStop:Boolean;
		
		private var _sheetVo:SheetVO;
		private var _bitmap:Bitmap;
		
		public function SheetPlayer(mc:MovieClip, times:int = 1, palette:Object = null, useCache:Boolean = true, resName:String = "")
		{
			_bitmap = new Bitmap(null, PixelSnapping.ALWAYS, true);
			_sheetVo = MovieClipUtil.transformToSheet(mc, palette, useCache, resName);
			_playTimes = times;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get type():String
		{
			return _type;
		}

		public function get isComplete():Boolean
		{
			return _isComplete;
		}

		/**
		 * 切换序列帧 
		 * @param sheetVo
		 * 
		 */		
		public function set sheetVo(value:SheetVO):void
		{
			_sheetVo = value;
		}
		
		/**
		 * 重新开始 
		 * 
		 */		
		public function restart():void
		{
			FrameRender.removeRender(onEnterFrame);
			_isComplete = true;
			_isStop = true;
			start();
		}

		public function start():void
		{
			if (_isComplete)
			{
				_currentRound = 1;
				currentFrame = 1;
				init();
				dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_START));
			}
			else if (_isStop)
			{
				_isStop = false;
			}
		}
		
		private function init():void
		{
			addChild(_bitmap);
			_isComplete = false;
			_isStop = false;
			
			FrameRender.addRender(onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			if (!_isStop)
			{
				if (_currentFrame >= _sheetVo.frameLength)
				{
					if (_currentRound == _playTimes)
					{
						_isComplete = true;
						_isStop = true;
						FrameRender.removeRender(onEnterFrame);
						dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE));
						return; // 如果结束 enterFrame return 否则在调用dispose 销毁了sheetvo的时候 enterframe 函数 继续到 _sheetVo.frameLength  会报null错误
					}
					else
					{
						_currentRound++;
						currentFrame = 1;
					}
				}
				else
				{
					currentFrame = ++_currentFrame;
				}
				
				if (_currentFrame == uint(_sheetVo.frameLength / 2))
				{
					dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_HALF));
				}
			}
		}
		
		public function stop():void
		{
			_isStop = true;
		}
		
		public function gotoAndStop(frame:uint):void
		{
			_isStop = true;
			currentFrame = frame;
		}
		
		public function gotoAndPlay(frame:uint):void
		{
			_isStop = false;
			currentFrame = frame;
		}
		
		/**
		 * 当前帧 
		 */
		public function get currentFrame():uint
		{
			return _currentFrame;
		}
		public function set currentFrame(value:uint):void
		{
			_currentFrame = value;
			
			draw();
			//帧CALLBACK
			if (_keyFrameObject && _keyFrameObject[value] != null)
			{
				_keyFrameObject[value]();
			}
		}
		
		private function draw():void
		{
			var vo:FramesVO = _sheetVo.framesSet[_currentFrame - 1];
			if (vo && _bitmap.bitmapData != vo.bitmapData)
			{
				_bitmap.bitmapData = vo.bitmapData;
				_bitmap.x = vo.offsetX;
				_bitmap.y = vo.offsetY;
			}
		}
		
		public function clearFrameScript():void
		{
			_keyFrameObject = null;
		}
		
		public function addFrameScript(m:uint, callBack:Function):void
		{
			if (!_keyFrameObject)
			{
				_keyFrameObject = {};
			}
			_keyFrameObject[m] = callBack;
		}
		
		public function set playTimes(times:int):void
		{
			if (_isComplete)
			{
				_playTimes = times;
			}
		}
		
		public function get currentRound():uint
		{
			return _currentFrame;
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
		
		public function dispose():void
		{
			FrameRender.removeRender(onEnterFrame);
			_sheetVo = null;
			DisplayUtil.removeFromParent(_bitmap);
		}
		
		public function hide():void
		{
			stop();
			DisplayUtil.removeFromParent(this);
		}
		
		public function get totalFrames():int{
			return _sheetVo.frameLength;
		}
		
	}
}