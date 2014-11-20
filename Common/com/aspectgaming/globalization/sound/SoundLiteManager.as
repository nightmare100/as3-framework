package com.aspectgaming.globalization.sound
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class SoundLiteManager 
	{
		private static var _instance:SoundLiteManager = new SoundLiteManager;
		private var _soundlib:Dictionary = new Dictionary()
		private var _soundChannelList:Dictionary = new Dictionary()
		private var _muteList:Object = new Object
		private var _soundLib:MovieClip;
		private var _disposed:Boolean = false;
		
		public function SoundLiteManager() 
		{
			if (_instance) throw new Error();
		}
		public function setSoundLib(sound:MovieClip):void {
			_soundLib = sound;
		}
		public function volume(val:Number):void {
			var transform:SoundTransform = SoundMixer.soundTransform;
			transform.volume = val;
			SoundMixer.soundTransform = transform;
		}
		
		private function getSoundClass(name:String):Class {
			if (_soundLib!=null) {
				return _soundLib.loaderInfo.applicationDomain.getDefinition(name) as Class;
			}
			return null
		}

		public function playSound(soundName:*, completedCallback:Function = null, repeat:uint = 0, volume:Number = 1 ):void {
			if (_disposed || soundName == null ) return;
			var sound:Sound
			var channel:SoundChannel
			
			var soundClass :Class
			if (soundName is Class) {
				soundClass = soundName;
			}else {
				soundClass = getSoundClass(soundName);
			}
			if (soundClass == null) return;
			if (_soundlib[soundClass] == null) {
				 sound= new soundClass();
				_soundlib[soundClass] = sound
			}else {
				sound = _soundlib[soundClass]
			}
			
			if (sound != null) {
				var transform:SoundTransform = new SoundTransform;
				transform.volume = volume;
				channel = sound.play(0, repeat,transform)
				if (channel!=null && completedCallback!=null) {
					channel.addEventListener(Event.SOUND_COMPLETE, function():void {
						completedCallback();
					});
				}
				_soundChannelList[soundClass] = channel;
			}
		}
		public function stopSound(soundName:*):Sound {
			if (soundName == null) return null;
			var soundClass :Class
			if (soundName is Class) {
				soundClass = soundName;
			}else {
				soundClass = getSoundClass(soundName);
			}
			
			var sound:Sound = _soundlib[soundClass]
			var channel:SoundChannel=_soundChannelList[soundClass]
			if (sound != null) {
				try { 
					channel.stop();
					return sound
					} catch (e:*) { };
			}
			return null;
		}
		public function getSound(soundName:*):SoundChannel {
			if (soundName == null) return null;
			var soundClass :Class
			if (soundName is Class) {
				soundClass = soundName;
			}else {
				soundClass = getSoundClass(soundName);
			}
			if (_soundlib[soundClass] == null) {
				return null
			}else {
				var channel:SoundChannel = _soundChannelList[soundClass]
				return channel
			}
		}
		static public function get instance():SoundLiteManager 
		{
			return _instance;
		}
			
		public function dispose():void 
		{
			var oldTransform :SoundTransform = SoundMixer.soundTransform;
			var transform:SoundTransform = SoundMixer.soundTransform;
			transform.volume = 0;
			SoundMixer.soundTransform = transform;
			_disposed=true
			for (var cl:* in _soundlib) {
				stopSound(cl);
				delete _soundlib[cl];
				delete _soundChannelList[cl];
			}
			SoundMixer.soundTransform = oldTransform;
		}
		
		public function stopAllSounds():void
		{
			var oldTransform :SoundTransform = SoundMixer.soundTransform;
			var transform:SoundTransform = SoundMixer.soundTransform;
			transform.volume = 0;
			SoundMixer.soundTransform = transform;
			for (var cl:* in _soundlib) {
				stopSound(cl);
			}
			SoundMixer.soundTransform = oldTransform;
		}
	}

}