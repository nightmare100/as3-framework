package com.aspectgaming.game.net
{
	import com.aspectgaming.core.IParse;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.event.SimulatorEvent;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.vo.dto.FreeSpinDTO;
	import com.aspectgaming.game.net.vo.dto.SingleResultDTO;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBonusDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.net.vo.dto.UserDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveLevelDTO;
	import com.aspectgaming.game.net.vo.request.ProgressiveInfoC2S;
	import com.aspectgaming.game.net.vo.request.SlotBonusGameOutroC2S;
	import com.aspectgaming.game.net.vo.request.SlotBonusGameSelectC2S;
	import com.aspectgaming.game.net.vo.request.SlotFreeGameIntroC2S;
	import com.aspectgaming.game.net.vo.request.SlotFreeGameOutroC2S;
	import com.aspectgaming.game.net.vo.request.SlotFreeGamePlayC2S;
	import com.aspectgaming.game.net.vo.request.SlotGambleGameC2S;
	import com.aspectgaming.game.net.vo.request.SlotGambleGameSelectC2S;
	import com.aspectgaming.game.net.vo.request.SlotGameEndC2S;
	import com.aspectgaming.game.net.vo.request.SlotGameFreeGamePowerPlayC2S;
	import com.aspectgaming.game.net.vo.request.SlotGameFreeSpinPlayC2S;
	import com.aspectgaming.game.net.vo.request.SlotGameFreeSpinRegisterC2S;
	import com.aspectgaming.game.net.vo.request.SlotGamePlayByInventoryC2S;
	import com.aspectgaming.game.net.vo.request.SlotGamePlayC2S;
	import com.aspectgaming.game.net.vo.request.SlotGameProgressiveEndC2S;
	import com.aspectgaming.game.net.vo.request.SlotGameRefreshBalanceC2S;
	import com.aspectgaming.game.net.vo.request.SlotGameRegisterC2S;
	import com.aspectgaming.game.net.vo.request.SlotGameRegisterForOnlineGameC2S;
	import com.aspectgaming.game.net.vo.response.ProgressiveInfoS2C;
	import com.aspectgaming.game.net.vo.response.SlotBonusGameOutroS2C;
	import com.aspectgaming.game.net.vo.response.SlotBonusGameSelectS2C;
	import com.aspectgaming.game.net.vo.response.SlotFreeGameIntroS2C;
	import com.aspectgaming.game.net.vo.response.SlotFreeGameOutroS2C;
	import com.aspectgaming.game.net.vo.response.SlotFreeGamePlayS2C;
	import com.aspectgaming.game.net.vo.response.SlotGambleGameS2C;
	import com.aspectgaming.game.net.vo.response.SlotGambleGameSelectS2C;
	import com.aspectgaming.game.net.vo.response.SlotGameEndS2C;
	import com.aspectgaming.game.net.vo.response.SlotGameFreeGamePowerPlayS2C;
	import com.aspectgaming.game.net.vo.response.SlotGameFreeSpinPlayS2C;
	import com.aspectgaming.game.net.vo.response.SlotGameFreeSpinRegisterS2C;
	import com.aspectgaming.game.net.vo.response.SlotGamePlayByInventoryS2C;
	import com.aspectgaming.game.net.vo.response.SlotGamePlayS2C;
	import com.aspectgaming.game.net.vo.response.SlotGameProgressiveEndS2C;
	import com.aspectgaming.game.net.vo.response.SlotGameRefreshBalanceS2C;
	import com.aspectgaming.game.net.vo.response.SlotGameRegisterForOnlineGameS2C;
	import com.aspectgaming.game.net.vo.response.SlotGameRegisterS2C;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.net.ServerManager;
	import com.aspectgaming.net.event.ServerErrorEvent;
	import com.aspectgaming.net.event.ServerEvent;
	import com.aspectgaming.net.mapping.ClassRegister;
	import com.aspectgaming.net.vo.LevelInfoDTO;
	import com.aspectgaming.net.vo.PlayerDTO;
	import com.aspectgaming.net.vo.request.RegisterPlayerC2S;
	import com.aspectgaming.net.vo.response.RegisterPlayerS2C;
	import com.aspectgaming.utils.constant.LogType;
	import com.aspectgaming.utils.constant.TickConstant;
	
	public class SlotServerManager extends ServerManager
	{
		public static var isInTakeWinRequest:Boolean;
		
		private const TIME_OUT_NUM:uint = 10;
		private var _parse:IParse;
		public function SlotServerManager()
		{
			super();
			registerClass();
		}
		override public function init(appurl:String, isEncode:Boolean, parse:IParse=null, logFunc:Function=null, type:String="AMF"):void
		{
			_parse = parse;
			super.init(appurl, isEncode, parse, logFunc, type);
		}
		/**
		 *  注册映射类 
		 * 
		 */		
		protected function registerClass():void
		{
			//注册JAVA数据类(请求包) 类名为服务端命名空间
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_FREEGAME_INTRO, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotFreeGameIntroC2S", SlotFreeGameIntroC2S,"com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotFreeGameIntroS2C", SlotFreeGameIntroS2C);
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_FREEGAME_OUTRO, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotFreeGameOutroC2S", SlotFreeGameOutroC2S,"com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotFreeGameOutroS2C", SlotFreeGameOutroS2C);
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_FREEGAME_PLAY, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotFreeGamePlayC2S", SlotFreeGamePlayC2S, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotFreeGamePlayS2C", SlotFreeGamePlayS2C);
			
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_BONUS_GAME_OUTRO, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotBonusGameOutroC2S", SlotBonusGameOutroC2S,"com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotBonusGameOutroS2C", SlotBonusGameOutroS2C);
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_BONUS_GAME_SLELECT, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotBonusGameSelectC2S", SlotBonusGameSelectC2S, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotBonusGameSelectS2C", SlotBonusGameSelectS2C);
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_GAMBLE_GAME, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGambleGameC2S", SlotGambleGameC2S,"com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGambleGameS2C", SlotGambleGameS2C);
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_GAMBLE_GAMESELETE, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGambleGameSelectC2S", SlotGambleGameSelectC2S, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGambleGameSelectS2C", SlotGambleGameSelectS2C);
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_GAME_END, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameEndC2S", SlotGameEndC2S,"com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameEndS2C", SlotGameEndS2C);
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_GAME_PLAY, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGamePlayC2S", SlotGamePlayC2S, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGamePlayS2C", SlotGamePlayS2C);
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_GAME_PROGRESSIVE_END, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameProgressiveEndC2S", SlotGameProgressiveEndC2S, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameProgressiveEndS2C", SlotGameProgressiveEndS2C);
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_FRESHBALANCE, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRefreshBalanceC2S", SlotGameRefreshBalanceC2S, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRefreshBalanceS2C", SlotGameRefreshBalanceS2C);
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_SLOTGAME_REGISTER, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRegisterC2S", SlotGameRegisterC2S, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRegisterS2C", SlotGameRegisterS2C);
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_GAME_FREESPIN_PLAY, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameFreeSpinPlayC2S", SlotGameFreeSpinPlayC2S, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameFreeSpinPlayS2C", SlotGameFreeSpinPlayS2C);
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_SLOTFREESPIN_REGISTER, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameFreeSpinRegisterC2S", SlotGameFreeSpinRegisterC2S,"com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameFreeSpinRegisterS2C", SlotGameFreeSpinRegisterS2C);
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_POWER_PLAY, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameFreeGamePowerPlayC2S", SlotGameFreeGamePowerPlayC2S,"com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameFreeGamePowerPlayS2C", SlotGameFreeGamePowerPlayS2C);
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_POWER_SPIN, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGamePlayByInventoryC2S", SlotGamePlayByInventoryC2S, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGamePlayByInventoryS2C", SlotGamePlayByInventoryS2C);
			
			//lobby用S2C和C2S
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_LOBBY_REGISTER, "com.aspectgaming.facebook.gameserver.web.facade.msg.lobby.RegisterPlayerC2S", RegisterPlayerC2S,"com.aspectgaming.facebook.gameserver.web.facade.msg.lobby.RegisterPlayerS2C", RegisterPlayerS2C);//大厅register
			
			
			ClassRegister.addDataStruct(SlotAmfCommand.CMD_SLOTGAME_REGISTER_FOR_ONLINE, "com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRegisterForOnlineGameC2S", SlotGameRegisterForOnlineGameC2S,"com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRegisterForOnlineGameS2C", SlotGameRegisterForOnlineGameS2C);//大厅register
			//注册DTO
			
			ClassRegister.registerSingle("com.aspectgaming.onlinePlatform.gameserver.webservice.dto.UserDTO", UserDTO);
			
			//lobby用DTO
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.PlayerDTO", PlayerDTO);
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.LevelInfoDTO", LevelInfoDTO);
			
			//slot用DTO
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.SlotFreeGameDTO", SlotFreeGameDTO);
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.SlotGameBaseGameDTO", SlotGameBaseGameDTO);
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.SlotGameBonusDTO", SlotGameBonusDTO);
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.SlotGameGambleDTO", SlotGameGambleDTO);
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.WinProgressiveDTO", WinProgressiveDTO);
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.WinProgressiveLevelDTO", WinProgressiveLevelDTO);
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.FreeSpinDTO", FreeSpinDTO);
			ClassRegister.registerSingle("com.aspectgaming.facebook.gameserver.web.facade.msg.SingleResultDTO", SingleResultDTO);
		}
		
		override protected function onData(e:ServerEvent):void
		{
			if (e.req == SlotAmfCommand.CMD_GAME_END)
			{
				isInTakeWinRequest = false;
			}
			
			if (GameGlobalRef.gameManager.gameTick.isTimeoutComplete(e.req))
			{
				return;
			}
			else
			{
				GameGlobalRef.gameManager.gameTick.removeTimeout(e.req);
			}
			
			super.onData(e);
			if(GameGlobalRef.simulator){
				GameGlobalRef.simulator.loggerAdd(LogType.LOG_REQUEST_BACK+":", e.data);
			}
		}
		
		override public function sendRequest(req:String, parm:Object=null):void
		{
			isInTakeWinRequest = req == SlotAmfCommand.CMD_GAME_END;
			
			
			GameGlobalRef.gameManager.gameTick.addTimeout(timeOutHandler, TIME_OUT_NUM, req);
			super.sendRequest(req, parm);
			
			if(GameGlobalRef.simulator)
			{
				GameGlobalRef.simulator.loggerAdd(LogType.LOG_REQUEST_SEND+":", _parse.parseRequestData(req, parm));
			}
		}
		override protected function onError(e:ServerEvent):void
		{
			super.onError(e);
			if(GameGlobalRef.simulator)
			{
				GameGlobalRef.simulator.loggerAdd(LogType.LOG_REQUEST_ERROR+":", e.data);
			}
			dispatch(new ServerErrorEvent(ServerErrorEvent.AMF_ERROR));
		}
		private function timeOutHandler():void
		{
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_ERROR));
			dispatch(new ServerErrorEvent(ServerErrorEvent.AMF_ERROR));
		}
		
	}
}