package com.aspectgaming.game.base.control.init
{
	import com.aspectgaming.constant.ComeFromSource;
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.game.base.control.OverrideCommandControl;
	import com.aspectgaming.game.constant.OverrideCommandlDefine;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.net.event.ServerEvent;
	import com.aspectgaming.net.vo.request.RegisterPlayerC2S;
	
	import flash.external.ExternalInterface;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * INIT注册游戏 
	 * @author mason.li
	 * 
	 */	
	public class RegisterGameCommand extends Command
	{
		[Inject]
		public var gameInfo:GameInfo;
		
		[Inject]
		public var server:IServer;
		
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var gameEvent:GameEvent;
		
		override public function execute():void
		{
			if (!gameEvent.data)
			{
				commandMap.mapEvent(GameEvent.GAME_CREATED_COMMAND, gameMgr.overrideControl.getCommandByType(OverrideCommandlDefine.CreateGameCommand), GameEvent, true);
			}
			
			if (ClientManager.isLocalDebug)
			{
				//注册大厅
				var registerLobby:RegisterPlayerC2S = new RegisterPlayerC2S();
				registerLobby.firstName = "aa";
				registerLobby.lastName = "bb";
				registerLobby.email = "nightmareljy@gmail.com";
				registerLobby.facebookId = gameInfo.playerID;
				registerLobby.adSource = "";
				registerLobby.thirdPathId = "";
				registerLobby.sex = "male";
				registerLobby.brithday = null;
				registerLobby.language = gameInfo.lang;
				
				server.addEventListener(SlotAmfCommand.CMD_LOBBY_REGISTER, onRegisterLobby);
				server.sendRequest(SlotAmfCommand.CMD_LOBBY_REGISTER, registerLobby);
			}
			else
			{
				registerGame();
			}
		}
		
		private function onRegisterLobby(e:ServerEvent):void
		{
			server.removeEventListener(SlotAmfCommand.CMD_LOBBY_REGISTER, onRegisterLobby);
			registerGame();
		}
		
		protected function registerGame():void
		{
			if (gameInfo.clientSource == ComeFromSource.SOURCE_ONLINE)
			{
				server.addEventListener(SlotAmfCommand.CMD_SLOTGAME_REGISTER_FOR_ONLINE, onRegisterGame);
				server.sendRequest(SlotAmfCommand.CMD_SLOTGAME_REGISTER_FOR_ONLINE);
				return;
			}
			
			
			if (gameInfo.isFreeSpin)
			{
				server.addEventListener(SlotAmfCommand.CMD_SLOTFREESPIN_REGISTER, onRegisterGame);
				server.sendRequest(SlotAmfCommand.CMD_SLOTFREESPIN_REGISTER);
			}
			else
			{
				server.addEventListener(SlotAmfCommand.CMD_SLOTGAME_REGISTER, onRegisterGame);
				server.sendRequest(SlotAmfCommand.CMD_SLOTGAME_REGISTER);
			}
		}
		
		private function onRegisterGame(e:ServerEvent):void
		{
			server.removeEventListener(SlotAmfCommand.CMD_SLOTGAME_REGISTER, onRegisterGame);
			server.removeEventListener(SlotAmfCommand.CMD_SLOTFREESPIN_REGISTER, onRegisterGame);
			server.removeEventListener(SlotAmfCommand.CMD_SLOTGAME_REGISTER_FOR_ONLINE, onRegisterGame);
			
			if (gameEvent.data)
			{
				var resetCommand:Class = gameMgr.overrideControl.getCommandByType(OverrideCommandlDefine.RestartGameCommand);
				if (resetCommand)
				{
					commandMap.mapEvent(GameEvent.GAME_RESTART, resetCommand, GameEvent, true);
					dispatch(new GameEvent(GameEvent.GAME_RESTART));
				}
			}
			else
			{
				dispatch(new GameEvent(GameEvent.GAME_CREATED_COMMAND));
			}
		}
		
	}
}