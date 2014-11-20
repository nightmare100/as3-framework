package com.aspectgaming.ui
{
	import com.aspectgaming.constant.global.LobbyGameConstant;
	import com.aspectgaming.constant.global.SoundDefine;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.ui.base.BaseComponent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ToggleButton extends BaseComponent
	{
		public function ToggleButton(mc:MovieClip)
		{
			super(mc);
		}
		
		override protected function init():void
		{
			_viewComponent.gotoAndStop(1);
			
			super.init();
		}
		
		override protected function addEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			addEventListener(MouseEvent.CLICK, onMuteBtnHandler);
		}
		
		override protected function removeEvent():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			removeEventListener(MouseEvent.CLICK, onMuteBtnHandler);
		}
		
		protected function onMuteBtnHandler(e:MouseEvent):void
		{
			
		}
		
		private function onOverHandler(e:MouseEvent):void 
		{
			SoundManager.playSound(SoundDefine.SOUND_MOUSE_OVER);
		}
	}
}