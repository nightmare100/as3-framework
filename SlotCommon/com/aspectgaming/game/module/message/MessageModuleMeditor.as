package com.aspectgaming.game.module.message
{
	import com.aspectgaming.game.event.SlotEvent;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	public class MessageModuleMeditor extends ModuleMediator
	{
		[Inject]
		public var messageModule:MessageModule;
		
		public function MessageModuleMeditor()
		{
			super();
		}
		
		override public function onRegister():void
		{
			addContextListener(SlotEvent.SHOW_MESSAGE, onMessage, SlotEvent);
			super.onRegister();
		}
		
		
		
		private function onMessage(e:SlotEvent):void
		{
			messageModule.changeText(e.content);
		}
		
	}
}