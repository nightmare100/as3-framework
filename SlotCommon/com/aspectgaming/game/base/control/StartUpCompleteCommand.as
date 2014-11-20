package com.aspectgaming.game.base.control
{
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.game.base.control.init.GameInitliazeCommand;
	import com.aspectgaming.game.base.control.init.RegisterServerCommand;
	import com.aspectgaming.game.constant.OverrideCommandlDefine;
	import com.aspectgaming.game.core.ISpeicalParse;
	import com.aspectgaming.game.data.FreeGameModel;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.gamble.GambleInfo;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.globalization.controller.AssetLoaderInitCommand;
	
	import org.robotlegs.mvcs.Command;
	
	
	/**
	 * 1. StartUpCommand
	 * 2. 执行 GameEvent.GAME_CUSTOM_INIT 事件命令
	 * 3. GameInitliazeCommand
	 * 4. RegisterGameCommand
	 * 5. 执行 GameEvent.GAME_BEFORE_CREATE_UI 事件命令
	 * 6. CreateGameCommand 
	 * @author mason.li
	 * 
	 */	
	public class StartUpCompleteCommand extends Command
	{
		[Inject]
		public var server:IServer;
		
		[Inject]
		public var gameInfo:GameInfo;
		
		[Inject]
		public var gameData:GameData;
		
		[Inject]
		public var gameManager:GameManager;
		
		[Inject]
		public var gambleInfo:GambleInfo;
		
		[Inject]
		public var freeGameInfo:FreeGameModel;
		
		override public function execute():void
		{
			commandMap.mapEvent(GameEvent.GAME_INITIALIZE, gameManager.overrideControl.getCommandByType(OverrideCommandlDefine.GameInitCommand), GameEvent, true);
			commandMap.mapEvent(GameEvent.REGISTER_SERVICE, RegisterServerCommand, GameEvent, true);
			commandMap.mapEvent(GameEvent.ASSETS_LOADER_STARTUP, AssetLoaderInitCommand, GameEvent, true);
			
			GameGlobalRef.gameData = gameData;
			GameGlobalRef.gameServer = server;
			GameGlobalRef.gameInfo = gameInfo;
			GameGlobalRef.gameManager = gameManager;
			GameGlobalRef.gambleInfo = gambleInfo;
			GameGlobalRef.freeGameInfo = freeGameInfo;
			
			
			//自定义初始化事件
			dispatch(new GameEvent(GameEvent.GAME_CUSTOM_INIT));
			
			dispatch(new GameEvent(GameEvent.REGISTER_SERVICE));
			dispatch(new GameEvent(GameEvent.ASSETS_LOADER_STARTUP));
			dispatch(new GameEvent(GameEvent.GAME_INITIALIZE));
		}
		
	}
}