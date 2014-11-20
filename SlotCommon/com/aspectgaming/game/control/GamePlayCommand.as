package com.aspectgaming.game.control
{
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GamePlayType;
	import com.aspectgaming.game.constant.asset.AssetRefDefined;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.manager.GameTipsManager;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.utils.SlotInfoUtil;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	import com.aspectgaming.net.event.ServerEvent;
	import com.aspectgaming.utils.NumberUtil;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * 玩游戏Play 命令 
	 * @author mason.li
	 * 
	 */	
	public class GamePlayCommand extends ModuleCommand
	{
		[Inject]
		public var slotEvent:SlotEvent;
		
		[Inject]
		public var server:IServer;
		
		[Inject]
		public var gameData:GameData;
		
		[Inject]
		public var gameMgr:GameManager;
		
		override public function execute():void
		{
			gameMgr.isAfterFreeOutro = false;
			dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.GOOD_LUCK)));
			
			var cash:Number = gameData.totalCent;
			var dragon:Number = NumberUtil.dollarToCent(gameData.dragon);
			switch (slotEvent.content)
			{
				case GamePlayType.BASE_GAME_PLAY:
					cash = gameData.totalCent + NumberUtil.dollarToCent(gameData.totalWin) + NumberUtil.dollarToCent(GameGlobalRef.freeGameInfo.totalWon) - NumberUtil.dollarToCent(gameMgr.currentBet);
					resetWin();
					if (NewPlayerGuidManager.isInGuild)
					{
						dispatch(new SlotEvent(SlotEvent.GUILD_PLAY, slotEvent.data, slotEvent.content));
					}
					else
					{
						server.addEventListener(SlotAmfCommand.CMD_GAME_PLAY, onPlayBack);
						server.sendRequest(SlotAmfCommand.CMD_GAME_PLAY, slotEvent.data);
					}
					break;
				case GamePlayType.FREE_GAME_PLAY:
					if (NewPlayerGuidManager.isInGuild)
					{
						dispatch(new SlotEvent(SlotEvent.GUILD_PLAY, slotEvent.data, slotEvent.content));
					}
					else
					{
						server.addEventListener(SlotAmfCommand.CMD_FREEGAME_PLAY, onPlayBack);
						server.sendRequest(SlotAmfCommand.CMD_FREEGAME_PLAY, slotEvent.data);
					}
					break;
				case GamePlayType.POWER_PLAY:
					resetWin();
					cash = slotEvent.data;
					dragon = NumberUtil.dollarToCent(gameData.dragon - GameSetting.dragonPlayNum);
					GameTipsManager.popUp(AssetRefDefined.BONUS_TIPS);
					server.addEventListener(SlotAmfCommand.CMD_POWER_PLAY, onPlayBack);
					server.sendRequest(SlotAmfCommand.CMD_POWER_PLAY, slotEvent.data);
					break;
				case GamePlayType.FREE_SPIN_PLAY:
					server.addEventListener(SlotAmfCommand.CMD_GAME_FREESPIN_PLAY, onPlayBack);
					server.sendRequest(SlotAmfCommand.CMD_GAME_FREESPIN_PLAY, slotEvent.data);
					break;
				case GamePlayType.POWER_SPIN:
					resetWin();
					server.addEventListener(SlotAmfCommand.CMD_POWER_SPIN, onPlayBack);
					server.sendRequest(SlotAmfCommand.CMD_POWER_SPIN, slotEvent.data);
					
				default:
					break;
			}
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_UPDATE_BALANCE, "", "", SlotInfoUtil.getUpdateBalanceInfo(cash, dragon)));
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_STATUE_CHANGE, "", "", true));
		}
		
		private function onPlayBack(e:ServerEvent):void
		{
			server.removeEventListener(SlotAmfCommand.CMD_GAME_PLAY, onPlayBack);
			server.removeEventListener(SlotAmfCommand.CMD_FREEGAME_PLAY, onPlayBack);
			server.removeEventListener(SlotAmfCommand.CMD_POWER_PLAY, onPlayBack);
			server.removeEventListener(SlotAmfCommand.CMD_GAME_FREESPIN_PLAY, onPlayBack);
			server.removeEventListener(SlotAmfCommand.CMD_POWER_SPIN, onPlayBack);
			
			dispatchToModules(new SlotEvent(SlotEvent.GAME_PLAY_REQUEST_BACK, e.data, e.req));
		}
		private function resetWin():void
		{
			GameGlobalRef.freeGameInfo.totalWon = 0;
			GameGlobalRef.gambleInfo.totalGambleWin = 0;
		}
	}
}