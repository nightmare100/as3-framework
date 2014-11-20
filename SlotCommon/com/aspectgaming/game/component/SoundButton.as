package com.aspectgaming.game.component
{
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.ui.base.BaseComponent;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	public class SoundButton extends BaseComponent
	{
		private var _soundID:String;
		public function SoundButton(o:InteractiveObject, soundID:String = "BtnClick")
		{
			_soundID = soundID;
			super(o);
		}
		
		public function get x():Number
		{
			return _interactiveObject.x;
		}
		
		public function get y():Number
		{
			return _interactiveObject.y;
		}
		
		override protected function addEvent():void
		{
			addEventListener(MouseEvent.CLICK, onMosueHandler);
		}
		
		override protected function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK, onMosueHandler);
		}
		
		private function onMosueHandler(e:MouseEvent):void
		{
			SoundManager.playSound(_soundID);
		}
	}
}