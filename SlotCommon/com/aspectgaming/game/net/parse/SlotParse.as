package com.aspectgaming.game.net.parse
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.constant.SpeicalObjectVar;
	import com.aspectgaming.game.data.FreeGameModel;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.cmd.ParseFreeGameCommand;
	import com.aspectgaming.game.net.parse.cmd.ParseFreeSpinPlayCommand;
	import com.aspectgaming.game.net.parse.cmd.ParseGambleCommand;
	import com.aspectgaming.game.net.parse.cmd.ParseGameEndCommand;
	import com.aspectgaming.game.net.parse.cmd.ParseGamePlayCommand;
	import com.aspectgaming.game.net.parse.cmd.ParsePlayByInventoryCommand;
	import com.aspectgaming.game.net.parse.cmd.ParsePowerPlayCommand;
	import com.aspectgaming.game.net.parse.cmd.ParseProgressiveCommand;
	import com.aspectgaming.game.net.parse.cmd.ParseRegisterFreeSpinCommand;
	import com.aspectgaming.game.net.parse.cmd.ParseRegisterGameCommand;
	import com.aspectgaming.game.net.parse.cmd.ParseRegisterGameOnlineCommand;
	import com.aspectgaming.game.net.vo.dto.FreeSpinDTO;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBonusDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.game.utils.SlotUtil;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	import com.aspectgaming.net.amf.parse.BaseServerParse;
	import com.aspectgaming.utils.NumberUtil;
	import com.aspectgaming.utils.StringUtil;
	
	/**
	 * Slot公共解析器 有修改请继承 
	 * 重写 
	 * @author mason.li
	 * 
	 */	
	public class SlotParse extends BaseServerParse
	{
		override protected function registerCommand():void
		{
			parseMgr.addParseCommand(SlotAmfCommand.CMD_SLOTGAME_REGISTER, ParseRegisterGameCommand);
			parseMgr.addParseCommand(SlotAmfCommand.CMD_SLOTGAME_REGISTER_FOR_ONLINE, ParseRegisterGameOnlineCommand);
			parseMgr.addParseCommand(SlotAmfCommand.CMD_SLOTFREESPIN_REGISTER, ParseRegisterFreeSpinCommand);
			
			parseMgr.addParseCommand(SlotAmfCommand.CMD_GAME_PLAY, ParseGamePlayCommand);
			parseMgr.addParseCommand(SlotAmfCommand.CMD_FREEGAME_PLAY, ParseGamePlayCommand);
			parseMgr.addParseCommand(SlotAmfCommand.CMD_GAME_FREESPIN_PLAY, ParseFreeSpinPlayCommand);
			parseMgr.addParseCommand(SlotAmfCommand.CMD_POWER_PLAY, ParsePowerPlayCommand);
			
			parseMgr.addParseCommand(SlotAmfCommand.CMD_GAME_END, ParseGameEndCommand);
			parseMgr.addParseCommand(SlotAmfCommand.CMD_GAME_PROGRESSIVE_END, ParseProgressiveCommand);
			parseMgr.addParseCommand(SlotAmfCommand.CMD_FREEGAME_INTRO, ParseFreeGameCommand);
			parseMgr.addParseCommand(SlotAmfCommand.CMD_FREEGAME_OUTRO, ParseFreeGameCommand);
			
			parseMgr.addParseCommand(SlotAmfCommand.CMD_GAMBLE_GAME, ParseGambleCommand);
			parseMgr.addParseCommand(SlotAmfCommand.CMD_GAMBLE_GAMESELETE, ParseGambleCommand);
			
			parseMgr.addParseCommand(SlotAmfCommand.CMD_POWER_SPIN, ParsePlayByInventoryCommand);
			
		}
		
		//==================================== Public Static Method ===============================================
		
		/**
		 * BaseGame DTO 解析 
		 * @param baseGame
		 * @param cmd
		 * 
		 */		
		public static function parserbaseGameDto(baseGame:SlotGameBaseGameDTO, cmd:String = null):void
		{
			if (baseGame != null) 
			{
				//FreeSpin Play 无需关注状态
				if (cmd != SlotAmfCommand.CMD_GAME_FREESPIN_PLAY)
				{
					GameGlobalRef.gameData.currentStatue = baseGame.gameState;
				}
				
				GameGlobalRef.gameManager.checkProgressiveEnd(cmd);
				
				GameSetting.isCashOn =  baseGame.gameState == GameStatue.INTERAL_WALLET;
				GameSetting.isGambleOn	= baseGame.gambleOn;

				trace("parserDobaseGameDto dragonDollars/totalcash:", baseGame.playerDragons, baseGame.totalCredits);
				GameGlobalRef.gameData.lastWin 		= baseGame.lastAccumWin;
				GameGlobalRef.gameData.totalWager 	= NumberUtil.centToDollar(baseGame.totalWager);
				GameGlobalRef.gameData.totalCent 	= baseGame.totalCash;
				GameGlobalRef.gameData.totalDollar 	= baseGame.totalCredits;
				GameGlobalRef.gameData.dragon		= NumberUtil.centToDollar(baseGame.playerDragons);
				
				
				
				
				/*if (cmd == SlotAmfCommand.CMD_SLOTGAME_REGISTER && baseGame.gameState == GameStatue.GAMEIDLE)	
				{
					if (baseGame.maxLine != -1)
					{
						GameGlobalRef.gameManager.setCurrentLine(baseGame.maxLine);	
					}
				}
				else */
				if (cmd != SlotAmfCommand.CMD_GAME_END)
				{
					GameGlobalRef.gameManager.setCurrentLine(baseGame.line);
				}
				
				if (GameGlobalRef.gameInfo.isVip) 
				{
					var betArr:Array = [];
					betArr = GameGlobalRef.gameInfo.range.split("-");
					baseGame.maxBet = int(betArr[1]);				
					//GameData.response.minbet = betArr[0];
				}
				trace("parserDo  isVip/betmax", GameGlobalRef.gameInfo.isVip, "maxBet:",baseGame.maxBet,"bet:",baseGame.bet);
				
				var maxBet:int = baseGame.maxBet;
				var totalBet:int = baseGame.bet > baseGame.maxBet ? baseGame.maxBet : baseGame.bet;
				if (totalBet > 0 && maxBet > 0) 
				{
					/*if (cmd == SlotAmfCommand.CMD_SLOTGAME_REGISTER && baseGame.gameState == GameStatue.GAMEIDLE)	
					{
						GameGlobalRef.gameManager.setCrrentEachLineCash(maxBet);
					}
					else */
						
					if(cmd != SlotAmfCommand.CMD_GAME_END && cmd != SlotAmfCommand.CMD_POWER_SPIN)
					{
						GameGlobalRef.gameManager.setCrrentEachLineCash( baseGame.bet );
					}
				}
				GameGlobalRef.gameManager.betLineMax = baseGame.maxLine;
				GameGlobalRef.gameManager.betCashEachLineMax = baseGame.maxBet;
				GameGlobalRef.gameData.totalWin	= baseGame.baseGameWon;
				GameGlobalRef.gameData.currentStops = baseGame.stops.split(",");
				GameGlobalRef.gameData.baseGameStops = GameGlobalRef.gameData.currentStops;
				
				
				if ((cmd == SlotAmfCommand.CMD_SLOTGAME_REGISTER || cmd == SlotAmfCommand.CMD_SLOTFREESPIN_REGISTER) && 
					(baseGame.gameState == GameStatue.GAMBLE || baseGame.gameState == GameStatue.GAMBLE_OR_TAKEWIN))
				{
					GameGlobalRef.gameData.totalWin = GameGlobalRef.gameData.lastWin;
				}

				//解析WINLINE
				GameGlobalRef.gameData.setWinLineInfo(SlotUtil.parseStringArray(baseGame.winLineInfo));
					
				//解析ScatterInfo
				GameGlobalRef.gameData.setWinLineInfo(StringUtil.isEmptyString(baseGame.scatterInfo) ? [] : [String(baseGame.scatterInfo).split(",")], false);
				
				//游戏特殊处理
				if (baseGame.mathSpecificParams != null) 
				{
					GameGlobalRef.gameManager.parseSpeicalBaseGame(baseGame.mathSpecificParams);
					GameGlobalRef.gameData.winTrack = SlotUtil.stringToArray(baseGame.mathSpecificParams[SpeicalObjectVar.WINLOSSTRACKER]);
				}
				else
				{
					GameGlobalRef.gameData.winTrack = [];
				}
				
				if (cmd == SlotAmfCommand.CMD_SLOTGAME_REGISTER && NewPlayerGuidManager.isInGuild)
				{
					GameGlobalRef.gameData.totalCent 	= 50000;
					GameGlobalRef.gameData.totalDollar 	= 500;
					GameGlobalRef.gameManager.setCrrentEachLineCash(1);
					GameGlobalRef.gameManager.setCurrentLine(50);
					GameGlobalRef.gameManager.betLineMax = 50;
					GameGlobalRef.gameManager.betCashEachLineMax = 10;
				}
			}
		}
		
		/**
		 * Gamble Dto解析 
		 * @param gamble
		 * @param cmd
		 * 
		 */		
		public static function parseGambleDto(gamble:SlotGameGambleDTO, cmd:String = null):void
		{
			if (gamble != null) 
			{
				GameGlobalRef.gambleInfo.parse(gamble, cmd);
			}
			if (cmd == SlotAmfCommand.CMD_GAME_END) 
			{
				GameGlobalRef.gambleInfo.reset();
			}
		}
		
		public static function parserProgressiveDto(progressive:WinProgressiveDTO):void
		{
			if (progressive != null)
			{
				GameGlobalRef.gameData.progressiveInfo.parse(progressive);
			}
		}
		
		public static function parserFreeGameDto(freeGame:SlotFreeGameDTO, cmd:String = null):void
		{
			if (freeGame != null) 
			{
				GameGlobalRef.freeGameInfo.parse(freeGame, cmd);
			}
		}
		
		public static function parserBonusDto(bonus:SlotGameBonusDTO):void
		{
			if (bonus != null) 
			{
				GameGlobalRef.gameData.bonusInfo.pickOrder 		= bonus.pickOrder;
				GameGlobalRef.gameData.bonusInfo.bonusValue		= bonus.pickValues;
				GameGlobalRef.gameData.bonusInfo.maxSelected 	= bonus.maxSelectableBonus;
				GameGlobalRef.gameData.bonusInfo.bonusPickMask 	= bonus.pickedSymMask;
				GameGlobalRef.gameData.bonusInfo.bonusTotalWon 	= bonus.totalBonusPickWin;
			}
		}
		
		/**
		 * 解析FreeSpinDTO 和FreeGameDTO基本相同
		 * @param	progressive
		 */
		public static function parserFreeSpin(slot:FreeSpinDTO, resQName:String = null):void
		{
			var freeInfo:FreeGameModel = GameGlobalRef.freeGameInfo;
			if (slot != null) 
			{
				freeInfo.isShowGirl = freeInfo.totalTimes < GameSetting.showGirlTimes && freeInfo.totalTimes < slot.totalFreeGameIndex;
				
				freeInfo.checkRetrigger(resQName, slot.totalFreeGameIndex);
				
				freeInfo.freeGameIndex = slot.currentFreeGameIndex;
				freeInfo.totalTimes = slot.totalFreeGameIndex;	
				
				freeInfo.currentWon	= slot.freeGameWon;	
				freeInfo.totalWon	= slot.totalFreeGameWon;
				
				if (freeInfo.freeGameIndex >= freeInfo.totalTimes)
				{
					//Free Spin 手动切换状态
					GameGlobalRef.gameData.currentStatue = GameStatue.FREE_GAME_OUTRO;
				}
				
				if (freeInfo.freeGameIndex != -1 && slot.stops != null) 
				{
					GameGlobalRef.gameData.currentStops = GameGlobalRef.gameManager.parseSpeicalStops( SlotUtil.stringToArray(slot.stops) );
					
					GameGlobalRef.gameData.setWinLineInfo(SlotUtil.parseStringArray(slot.winLineInfo));
					
					GameGlobalRef.gameData.setWinLineInfo(StringUtil.isEmptyString(slot.scatterInfo) ? [] : [String(slot.scatterInfo).split(",")], false);
				}
				
				if (slot.mathSpecificParams != null) 
				{
					GameGlobalRef.gameManager.parseSpeicalFreeGame(slot.mathSpecificParams);
				}
				
			}
		}
	}
}