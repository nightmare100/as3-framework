package com.aspectgaming.globalization.sound
{
	import com.aspectgaming.constant.global.ResourceType;
	import com.aspectgaming.event.GlobalEvent;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.module.ModuleDefine;
	import com.aspectgaming.ui.iface.IModule;
	import com.aspectgaming.utils.URLUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;


	/**
	 * 音效管理  
	 * @author mason.li
	 * 
	 */	
	public class SoundManager 
	{
		private static var _idXML:XMLList;
		private static var _soundObj:Object = {};
		private static var _registerMap:Dictionary = new Dictionary();
		private static var _volume:Number = 1;		// current volume
		
		private static var _enabled:Boolean = true;
		

		public function SoundManager():void 
		{	
			
		}

		/**
		 * 声音开关 
		 * @return 
		 * 
		 */		
		public static function get enabled():Boolean
		{
			return _enabled;
		}

		public static function set enabled(value:Boolean):void
		{
			_enabled = value;
			for (var sid:* in _soundObj)
			{
				if (_soundObj[sid])
				{
					if (value)
					{
						SingleSound(_soundObj[sid]).unpause();
					}
					else
					{
						SingleSound(_soundObj[sid]).pause();
					}
				}
			}
			if (_enabled) {
				setVolume(1);	//恢复TableGame中可能存在的时间轴声音
			}
			dispatchToBanner(new GlobalEvent(GlobalEvent.SOUND_CONTROL_CHANGED));
		}
		
		private static function setVolume(volumn:Number):void
		{	
			
			var trans:SoundTransform = new SoundTransform(volumn, 0);
			SoundMixer.soundTransform = trans;
		}
		
		//<sound id="bonuseChip" link="goc_balance_meter_ding.mp3" repeat="1" />
		/**
		 * 大厅用 
		 * @param xl
		 * 
		 */		
		public static function init(xl:XMLList):void
		{
			for (var i:int = 0; i < xl.sound.length(); i++ ) 
			{
				var xml:XML =  xl.sound[i];
				
				try 
				{
					var id:String = xml.@id;
					var url:String = URLUtil.getAssetByHolePath(xml.@link);
					//trace(url)
					var snd:Sound = new Sound(new URLRequest(url));
					snd.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					snd.addEventListener(Event.COMPLETE, onComplete);
					var singleSound:SingleSound = new SingleSound(id, xml.@repeat, snd);
					singleSound.type = ResourceType.GOBLE;
					_soundObj[id] = singleSound;
				}
				catch (e:Error) 
				{
					trace("! sound", e);
				}
			}
		}
		
		private static function onIOError(e:IOErrorEvent):void
		{
			var snd:Sound = e.currentTarget as Sound;
			snd.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			snd.removeEventListener(Event.COMPLETE, onComplete);
		}
		
		private static function onComplete(e:Event):void
		{
			var snd:Sound = e.currentTarget as Sound;
			snd.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			snd.removeEventListener(Event.COMPLETE, onComplete);
		}
		
		/**
		 * 游戏注册声音 代理
		 * 
		 */		
		public static function registerSoundRefer(key:String, snd:Class, repeat:uint, isMusic:Boolean):void
		{
			if (_soundObj[key] || snd == null)
			{
				return;
			}
			else
			{
				var sInfo:SoundInfo = new SoundInfo();
				sInfo.repeat = repeat;
				sInfo.soundClass = snd;
				sInfo.isMusic = isMusic;
				_registerMap[key] = sInfo;
			}
		}

		public static function setSoundVolume(sid:String, volume:Number):void 
		{
			var single:SingleSound = _soundObj[sid];
			if (single != null)	
			{
				single.volume = volume;
			}
		}
		
		public static function getSoundIsPlaying(sid:String):Boolean
		{
			var single:SingleSound = getSound(sid);
			if (single)
			{
				return single.isPlaying;
			}
			else
			{
				return false;
			}
		}
		
		public static function playSound(sid:String, isSingle:Boolean = true, stopFunc:Function = null, times:int = -1,vol:Number=-1):void
		{
			var single:SingleSound = getSound(sid, times);
			if (single == null) 
			{
				return;
			}
			if (vol < 0 || vol > 1 ) 
			{
				vol = volume;
			}
			
			if (single.isMusic)
			{
				for (var key:String in _soundObj)
				{
					if (SingleSound(_soundObj[key]).isMusic && SingleSound(_soundObj[key]).isPlaying && SingleSound(_soundObj[key]) != single)
					{
						SingleSound(_soundObj[key]).pause();
					}
				}
			}
			
			if (enabled)
			{
				single.play(vol,times, isSingle, stopFunc);
			}
			else if (single.isMusic)
			{
				single.readyPlay(vol,times, isSingle, stopFunc);
			}
		}
		
		/**
		 * 停止单个声音 
		 * @param sid
		 * 
		 */
		public static function stopSound(sid:String):void 
		{
			var single:SingleSound = _soundObj[sid];
			if (single != null)
			{
				//trace("stopSound : ", sid, sound.position, sound.volume)
				single.stop(true);
			}
		}
		
		/**
		 * 停止批量声音 (模糊匹配)
		 * @param sid
		 * 
		 */		
		public static function stopSoundByFacede(sid:String):void 
		{
			for (var key:String in _soundObj)
			{
				if (key.indexOf(sid) != -1)
				{
					SingleSound(_soundObj[key]).stop(true);
				}
			}
		}
		
		/**
		 * 暂停单个音乐 
		 * @param sid
		 * 
		 */		
		public static function pauseSound(sid:String):void
		{
			var single:SingleSound = _soundObj[sid];
			if (single != null)
			{
				//trace("stopSound : ", sid, sound.position, sound.volume)
				single.pause();
			}
		}
		
		public static function unPauseSound(sid:String):void
		{
			if (enabled)
			{
				var single:SingleSound = _soundObj[sid];
				if (single != null)
				{
					//trace("stopSound : ", sid, sound.position, sound.volume)
					single.unpause();
				}
			}
		}

		
		public static function playSoundByFadeIn(sid:String, step:Number = .05):void 
		{
			var single:SingleSound = getSound(sid, 1);
			if (single != null && enabled)	
			{
				single.play(0, 1);
				single.fadein(step);
			}
		}
		// @ 2sec
		public static function stopSoundByFadeOut(sid:*, step:Number = -.02):void 
		{
			var single:SingleSound = _soundObj[sid];
			if (single != null)
			{
				single.fadeout(step);
			}
		}

		public static function toggleMute():void 
		{
			enabled =  enabled ? false : true;
		}

		public static function dispose():void 
		{
			var single:SingleSound;
			for (var sid:* in _soundObj)
			{
				single = _soundObj[sid];
				single.stop();
				_soundObj[sid] = null;
				delete _soundObj[sid];
			}
		}
	
		/**
		 * 销毁某类型的声音 
		 * @param type
		 * 
		 */		
		public static function disposeByType(type:String):void 
		{
			var single:SingleSound;
			for (var sid:* in _soundObj)
			{
				single = _soundObj[sid];
				if (single.type == type)
				{
					single.stop();
					_soundObj[sid] = null;
					delete _soundObj[sid];
				}
			}
		}
		
		public static function getPosition(sid:String):int 
		{
			var single:SingleSound = _soundObj(sid);
			if (single == null) 
			{
				return -1;
			}
			return single.position;
		}

		public static function getSoundLen(sid:String):int 
		{
			var single:SingleSound = _soundObj(sid);
			if (single == null)
			{
				return -1;
			}
			return single.totalLen;
		}

		private static function getSound(sid:String, repeat:uint = 1):SingleSound 
		{		
			var sound:SingleSound = _soundObj[sid] as SingleSound;
			if (sound)
			{
				return sound;	
			}
			else
			{
				if (_registerMap[sid])
				{
					var info:SoundInfo = _registerMap[sid];
					_soundObj[sid] = new SingleSound(sid, info.repeat, new info.soundClass());
					_soundObj[sid].type = ResourceType.GAME;
					_soundObj[sid].isMusic = info.isMusic;
					return _soundObj[sid];
				}
				else
				{
					return null;
				}
			}
		}
		
		public static function get volume():Number 
		{
			return _volume;
		}
		
		public static function set volume(value:Number):void 
		{
			_volume = Math.min(1, Math.max(0, value));
			var s:SingleSound;
			for (var key:String in _soundObj)
			{
				s = _soundObj[key];
				s.volume = _volume;
			}
		}
		
		private static function dispatchToBanner(evt:Event):void
		{
			var bannerModule:IModule = ModuleManager.getModule(ModuleDefine.BannerModule);
			if (bannerModule && bannerModule.context)
			{
				bannerModule.context.eventDispatcher.dispatchEvent(evt);
			}
		}
		
	}
}
import flash.media.Sound;

class SoundInfo
{
	public var repeat:uint;
	public var soundClass:Class;
	public var isMusic:Boolean;
}

