package com.aspectgaming.game.control
{
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.constant.GameModuleDefined;
	import com.aspectgaming.game.iface.IGameModule;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.module.gamble.GambleModule;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowGambleCommand extends Command
	{
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var slotUiEvent:SlotUIEvent;
		
		public function ShowGambleCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			var gambleModule:IGameModule = gameMgr.getModule(GameModuleDefined.GAMBLE);
			var isShow:Boolean = Boolean(slotUiEvent.data);
			if (isShow)
			{
				if (!gambleModule)
				{
					gambleModule = new GambleModule();
				}
				gameMgr.addModule(gambleModule, GameModuleDefined.GAMBLE, GameLayerManager.topLayer);
				
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_STATUE_CHANGE, "", "", true));
			}
			else
			{
				if (gambleModule)
				{
					gambleModule.hide();
				}
			}
		}
	}
}