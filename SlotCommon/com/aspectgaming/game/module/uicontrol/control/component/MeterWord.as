package com.aspectgaming.game.module.uicontrol.control.component
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.ui.base.BaseComponent;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class MeterWord extends BaseComponent
	{
		private var _txt:TextField;
		
		private var _defaultValue:Number;
		
		private var _targetNumber:Number;
		
		private var _currentValue:Number;
		
		/**
		 * Meter完成时间 
		 */		
		private var _completeSec:Number;
		
		private var _perAddNum:Number;
		
		private var _isRolling:Boolean;
		
		public function MeterWord(mc:InteractiveObject, name:String, defvalue:Number)
		{
			_txt = mc[name];
			_defaultValue = defvalue;
			_currentValue = _defaultValue;
			super(mc);
		}
		
		public function get currentValue():Number
		{
			return _currentValue;
		}

		public function get isRolling():Boolean
		{
			return _isRolling;
		}
		
		override protected function init():void
		{
			_txt.text = _defaultValue.toString();
			super.init();
		}
		
		public function set text(value:String):void
		{
			reset();

			_txt.text = value;
		}
		
		public function set meterNumber(n:Number):void
		{
			resetWithCurrent();
			
			_isRolling = true;
			_targetNumber = n;
			var winTimes:Number = (n-_currentValue) / GameGlobalRef.gameManager.currentBet;
			_completeSec = GameSetting.getMeterSecond(winTimes, GameGlobalRef.gameManager.isInFreeGame);
			trace( _targetNumber - _currentValue , ClientManager.frameRate * _completeSec)
			_perAddNum = (_targetNumber - _currentValue)  / (ClientManager.frameRate * _completeSec);
			GameGlobalRef.gameManager.frameRender.addRender(onMeter);
			SoundManager.playSound(GameGlobalRef.gameManager.currentMeterSoundName + GameSetting.getSoundIdx(winTimes), true, GameGlobalRef.gameManager.isBaseGame||GameGlobalRef.gameManager.isPropGame ? null : resetFreeBgMusic);
			
		}
		
		public function directToTarget():void
		{
			if (_isRolling)
			{
				text = _targetNumber.toString();
			}
		}
		
		private function resetFreeBgMusic():void
		{
			SoundManager.unPauseSound(SlotSoundDefined.FREE_GAME_BG);
		}
		private function resetWithCurrent():void
		{
			_isRolling = false;
			GameGlobalRef.gameManager.frameRender.removeRender(onMeter);
			_currentValue = Number(_txt.text);
			SoundManager.stopSoundByFacede(GameGlobalRef.gameManager.currentMeterSoundName);
		}
		public function reset():void
		{
			_isRolling = false;
			GameGlobalRef.gameManager.frameRender.removeRender(onMeter);
			_currentValue = _defaultValue;
			_txt.text = _defaultValue.toString();
			SoundManager.stopSoundByFacede(GameGlobalRef.gameManager.currentMeterSoundName);
		}
		
		private function onMeter():void
		{
			if (_currentValue >= _targetNumber)
			{
				GameGlobalRef.gameManager.frameRender.removeRender(onMeter);
				_isRolling = false;
				_txt.text = _targetNumber.toString();
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				_currentValue += _perAddNum;
				_txt.text = int(_currentValue).toString();
			}
		}
		
		override public function dispose():void
		{
			GameGlobalRef.gameManager.frameRender.removeRender(onMeter);
			SoundManager.stopSoundByFacede(GameGlobalRef.gameManager.currentMeterSoundName);
			_txt.text = "";
			super.dispose();
		}
		
		
	}
}