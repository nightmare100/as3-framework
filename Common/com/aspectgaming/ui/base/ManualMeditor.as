package com.aspectgaming.ui.base
{
	import com.aspectgaming.ui.event.ComponentEvent;
	import com.aspectgaming.ui.event.ModuleEvent;
	
	import flash.events.Event;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	/**
	 * 手动添加的中介器 
	 * @author mason.li
	 * 
	 */	
	public class ManualMeditor extends ModuleMediator
	{
		public function ManualMeditor()
		{
			super();
		}
		
		override public function onRegister():void
		{
			addViewListener(ModuleEvent.MODULE_REMOVED, onDispose);
			addViewListener(ComponentEvent.DISPOSE, onDispose);
		}
		
		protected function onDispose(e:Event):void
		{
			mediatorMap.removeMediator(this);
		}
		
		
	}
}