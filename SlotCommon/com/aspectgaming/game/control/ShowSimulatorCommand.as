package com.aspectgaming.game.control
{
	import com.aspectgaming.core.ISimulator;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowSimulatorCommand extends Command
	{
		[Inject]
		public var slotUiEvent:SlotUIEvent;
		
		[Inject]
		public var gameMgr:GameManager;
		
		private var _loader:SWFLoader;
		override public function execute():void
		{
			if(GameGlobalRef.simulator)
			{
				GameGlobalRef.simulator.callme();
				if (callBack != null)
				{
					callBack();
				}
			}
			else
			{
				this._loader = new SWFLoader("../../NewSimulator.swf", {name:"simulator", container:contextView, onComplete:onCompleteHandler,context:new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain))})			
				_loader.load();
			}
		}
		
		public function get callBack():Function
		{
			return slotUiEvent.data as Function;
		}
		
		private function onCompleteHandler(event:LoaderEvent):void 
		{
			var content:ContentDisplay = _loader.getContent("simulator");
			GameGlobalRef.simulator  = content.rawContent;
			
			if (callBack != null)
			{
				callBack();
			}
		}
	}
}