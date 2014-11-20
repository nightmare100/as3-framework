package com.aspectgaming.game.control
{
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.constant.GambleType;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.constant.asset.AnimationDefined;
	import com.aspectgaming.game.data.FreeGameModel;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.utils.SlotInfoUtil;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * 处理游戏各种状态
	 * @author mason.li
	 * 
	 */	
	public class CheckGameStatueCommand extends ModuleCommand
	{
		[Inject]
		public var evt:SlotEvent;
		
		[Inject]
		public var gameData:GameData;
		
		[Inject]
		public var freeModel:FreeGameModel;
		
		[Inject]
		public var gameInfo:GameInfo;
		
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var server:IServer;
		
		override public function execute():void
		{
			if (isInit)
			{
				if (gameData.currentStatue == GameStatue.GAMBLE)
				{
					dispatch(new SlotUIEvent(SlotUIEvent.SHOW_GAMBLE, true));
					dispatchToModules(new SlotEvent(SlotEvent.GAMBLE_GAME_REQUEST_BACK,null,SlotAmfCommand.CMD_GAMBLE_GAME));
				}
				return;
			}
			
			switch(gameData.currentStatue)
			{
				case GameStatue.FREE_GAME_INTRO:
					trace("GameIntroProcess!!", delay);
					gameMgr.gameTick.addTimeout(doIntro, delay, GameStatue.FREE_GAME_INTRO);
					
					break;
				
				case GameStatue.FREE_GAME_OUTRO:
					gameMgr.gameTick.addTimeout(doOutro, delay, GameStatue.FREE_GAME_OUTRO);
					
					break;
				
				case GameStatue.PROGRESSIVE:
					dispatch(new SlotEvent(SlotEvent.SHOW_GLOBAL_ANIMATION, gameData.progressiveInfo , AnimationDefined.PROGRESSIVE));
					break;
					
				default:
					break;
			}
		}
		
		private function doIntro():void
		{
			gameMgr.gameTick.removeTimeout(GameStatue.FREE_GAME_INTRO);
			dispatch(new SlotEvent(SlotEvent.SHOW_GLOBAL_ANIMATION, gameData.scatterInfo.symbloLength, AnimationDefined.FREE_INTRO));
		}
		
		private function doOutro():void
		{
			dispatch(new SlotEvent(SlotEvent.SHOW_GLOBAL_ANIMATION, freeModel.totalWinAddBase, AnimationDefined.FREE_OUTRO));
			var freeGameInfo:Object = SlotInfoUtil.getFreeGameInfo(gameInfo.gameName, freeModel.totalTimes, freeModel.totalWon);
			if (gameInfo.isFreeSpin)
			{
				gameInfo.isFreeSpin = false;
				server.sendRequest(SlotAmfCommand.CMD_SLOTGAME_REGISTER);
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_FREESPIN_END, null, null, freeGameInfo));
			}
			else
			{
				if (!NewPlayerGuidManager.isInGuild)
				{
					server.sendRequest(SlotAmfCommand.CMD_FREEGAME_OUTRO);
				}
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_FREEGAME_END, null, null, freeGameInfo));
			}
			
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_BIG_WIN, null, null, SlotInfoUtil.getBigWinInfo(freeModel.totalWinAddBase, gameMgr.currentEachLineCash)));
		}
		
		public function get isInit():Boolean
		{
			return Boolean(evt.content == "true");
		}
		
		public function get delay():uint
		{
			return uint(evt.data);
		}
		
	}
}