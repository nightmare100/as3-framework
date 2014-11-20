package com.aspectgaming.game.control
{
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.constant.GameModuleDefined;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.iface.IGameModule;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.module.help.HelpModule;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	
	import org.robotlegs.mvcs.Command;
	
	public class ShowHelpCommand extends Command
	{
		[Inject]
		public var slotUiEvent:SlotUIEvent;
		
		[Inject]
		public var gameMgr:GameManager;
		
		public function ShowHelpCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			SoundManager.playSound(SlotSoundDefined.BUTTON_CLICK);
			var helpModule:IGameModule = gameMgr.getModule(GameModuleDefined.GAME_HELP);
			var isShow:Boolean = Boolean(slotUiEvent.data);
			if (isShow)
			{
				if (!helpModule)
				{
					var cls:Class = gameMgr.getModuleClass(GameModuleDefined.GAME_HELP);
					helpModule = new cls();
				}
				gameMgr.addModule(helpModule, GameModuleDefined.GAME_HELP, GameLayerManager.lowLayer);
				
			}
			else
			{
				if (helpModule)
				{
					helpModule.hide();
				}
			}
			
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_STATUE_CHANGE, "", "", isShow));
		}
		
		
	}
}