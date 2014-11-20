package com.aspectgaming.globalization.sound
{
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.utils.tick.FrameRender;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author deve.huang
	 */
		
	public class SingleSound extends EventDispatcher
	{
		public static var ON_SOUND_COMPLETE:String = "onSoundComplete";
		
		/**
		 * 是否为音乐 不是则为音效 
		 */		
		public var isMusic:Boolean;
		public var type:String;
		private var _isPlaying:Boolean;
		private var _isPaused:Boolean;
		private var _isUnPaused:Boolean;
		
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _transform:SoundTransform;
		
		private var _pausePosition:int;
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		private var _stopFunc:Function
		
		private var _key:String;
		
		private var _defaultRepeatCount:int;
		private var _repeatCount:int
		
		private var _vstep:Number;
		
		/**
		 * CONSTRUCTOR
		 * @param    id 	仅在调用时使用 	
		 */
		public function SingleSound(key:*, repeatCount:int, sound:Sound) 
		{
			_key = key;
			_defaultRepeatCount = repeatCount;
			_repeatCount = repeatCount == 0 ? int.MAX_VALUE : repeatCount;
			_channel = new SoundChannel();
			_transform = new SoundTransform();
			_sound = sound;
		}
		
		
		public function get isOncePlay():Boolean
		{
			return _repeatCount == 1;
		}
		
		/**
		 * @param percent 	0~1
		 */
		public function get volume():Number 
		{	
			return _channel.soundTransform.volume; 
		}
		
		public function set volume(percent:Number):void 
		{
			percent = Math.min(1, Math.max(0, percent));			
			_transform.volume = percent;
			_transform.pan = 0;
			
			_channel.soundTransform = _transform;
		}
		
		public function fadein(step:Number = .05):void 
		{
			if (_isPlaying)
			{
				_vstep = step;
				FrameRender.addRender(onTita);
			}
		}
		
		// @ 1.25sec
		public function fadeout(step:Number = -.05):void
		{
			if (_isPlaying)
			{
				_vstep = step;
				FrameRender.addRender(onTita);
			}
		}
		
		private function onTita():void
		{
			this.volume = this.volume + _vstep;
			if (this.volume <= 0 || this.volume >= 1)
			{
				FrameRender.removeRender(onTita);
				if (this.volume <= 0)
				{
					stop();
				}
			}
		}
		
		public function play(volume:Number = 1, times:int = 1, isSingle:Boolean = true, stopFunc:Function = null):void 
		{
			if (!isSingle)
			{
				var sound:SingleSound = this.clone();
				sound.play(volume, times, true, stopFunc);
				return;
			}
			
			_transform.volume = volume;
			_transform.pan = 0;
			
			if (times != -1)
			{
				_repeatCount = times;
			}
			else
			{
				_repeatCount = _defaultRepeatCount;
			}
			
			_stopFunc = stopFunc;
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			_channel.stop();
			_channel = _sound.play(0, _repeatCount, _transform);
			
			_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);

			if (_repeatCount == 0)
			{
				_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
			}
			
			_isPlaying = true;
		}
		
		/**
		 * 准备播放  
		 * @param volume
		 * @param times
		 * @param isSingle
		 * @param stopFunc
		 * 
		 */		
		public function readyPlay(volume:Number = 1, times:int = 1, isSingle:Boolean = true, stopFunc:Function = null):void 
		{
			_transform.volume = volume;
			_transform.pan = 0;
			
			if (times != -1)
			{
				_repeatCount = times;
			}
			else
			{
				_repeatCount = _defaultRepeatCount;
			}
			
			_stopFunc = stopFunc;
			_channel.stop();
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			
			if (_repeatCount == 0)
			{
				_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
			}
			
			_isPlaying = false;
			_isPaused = true;
		}
		
		private function loopSound(e:Event):void
		{
			if (SoundManager.enabled)
			{
				play(_transform.volume, 0, true, _stopFunc);
			}
			else
			{
				readyPlay(_transform.volume, 0, true, _stopFunc)
			}
		}
		
		private function soundCompleteHandler(e:Event):void 
		{
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			if (_stopFunc != null)
			{
				_stopFunc();
				_stopFunc = null;
			}
			if (isOncePlay)
			{
				_isPlaying = false;
			}
		}
		
		
		public function stop(useStopCallBack:Boolean = false):void 
		{
			_channel.stop();

			_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			if (useStopCallBack && _stopFunc != null)
			{	
				_stopFunc();
				_stopFunc = null;
			}

			_isPlaying = false;
			_isPaused = false;
		}

		/**
		 * return this sound position
		 */
		public function get position():int	{		return _channel.position;	}
		public function get totalLen():int	{		return _sound.length;	}
		
		public function pause():void
		{
			if (!_isPlaying)
			{
				return;
			}
			
			if (isOncePlay)
			{
				stop();
				return;
			}
			
			_pausePosition = _channel.position;
			_channel.stop();
			_isPaused = true;
			_isPlaying = false;
		}
		
		/**
		 * Unpaused() play this sound if it was paused
		 */
		public function unpause():void 
		{
			if (_isPlaying)
			{
				return;
			}
			if (_isPaused) 
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
				
				_channel = _sound.play(_pausePosition,_repeatCount,_transform);
				_channel.soundTransform = _transform;
				_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				
				if (_repeatCount == 0)
				{
					_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
				}
				
				_isPaused = false;
				_isPlaying = true;
			}
		}
		

		public function clone():SingleSound	
		{
			return new SingleSound(_key, _repeatCount, _sound);
		}
	}
}
