package com.aspectgaming.game.control
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.GamePlayType;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBonusDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * 新手引导Play命令 
	 * @author mason.li
	 * 
	 */	
	public class GuildPlayCommand extends ModuleCommand
	{
		[Inject]
		public var slotEvt:SlotEvent;
		
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var gameData:GameData;
		
		override public function execute():void
		{
			var baseGameDto:SlotGameBaseGameDTO = getGuildDto();
			SlotParse.parserbaseGameDto(baseGameDto);
			
			if (slotEvt.content == GamePlayType.FREE_GAME_PLAY || gameMgr.isInFreeGame)
			{
				var obj:Object = gameMgr.speicalParse.getSpeicalData();
				SlotParse.parserFreeGameDto(getFreeDto(obj), SlotAmfCommand.CMD_FREEGAME_PLAY);
			}
			
			gameMgr.gameTick.addTimeout(function():void{
				dispatchToModules(new SlotEvent(SlotEvent.GAME_PLAY_REQUEST_BACK));
			}, 0.5);
			
		}
		
		private function getGuildDto():SlotGameBaseGameDTO
		{
			var dto:SlotGameBaseGameDTO = new SlotGameBaseGameDTO();
			if (NewPlayerGuidManager.isInStepList("slot"))
			{
				if (!gameMgr.isInFreeGame)
				{
					var regionObject:Object = NewPlayerGuidManager.getCurrentStepInfo().jsonData;
					var jsonData:Object = regionObject.baseDto;
					dto.line = jsonData.line;
					dto.mathSpecificParams = jsonData.mathSpecificParams
					dto.stops = jsonData.stops;
					dto.winLineInfo = jsonData.winLineInfo;
					dto.scatterInfo = jsonData.scatterInfo;
						
					dto.totalCash = jsonData.totalCash;
					dto.gambleOn = jsonData.gambleOn;
					dto.baseGameWon = jsonData.baseGameWon;
					dto.gameState = jsonData.gameState;
					dto.playerDragons  = jsonData.playerDragons;
					dto.totalCredits = jsonData.totalCredits;
					dto.totalWager = jsonData.totalWager;
					dto.lastAccumWin = jsonData.lastAccumWin;
					dto.maxLine = jsonData.maxLine;
					dto.bet = jsonData.bet;
					dto.maxBet = jsonData.maxBet;
				}
				else
				{
					var obj:Object = gameMgr.speicalParse.getSpeicalData();
					var baseDto:SlotGameBaseGameDTO = obj.data[obj.currentIdx] as SlotGameBaseGameDTO;
					
					dto.line = gameMgr.currentBetLine;
					dto.mathSpecificParams = {WINLOSSTRACKER:gameData.winTrack.join(",")}
					dto.stops = gameData.currentStops.join(",");
					dto.winLineInfo = null;
					
					dto.totalCash = gameData.totalCent;
					dto.gambleOn = GameSetting.isGambleOn;
					dto.baseGameWon = gameData.totalWin;
					dto.gameState = (obj.currentIdx == obj.data.length - 1) ? GameStatue.FREE_GAME_OUTRO : GameStatue.FREEGAME;
					dto.playerDragons  = gameData.dragon;
					dto.totalCredits = gameData.totalDollar;
					dto.totalWager = baseDto.totalWager;
					dto.lastAccumWin = baseDto.lastAccumWin;
					dto.maxLine = gameMgr.betLineMax;
					dto.bet = gameMgr.currentEachLineCash;
					dto.maxBet = gameMgr.betCashEachLineMax;
				}
			}
			
			return dto;
		}
		
		/**
		 * 做FreegameDto 
		 * @param obj
		 * @return 
		 * 
		 */		
		private function getFreeDto(obj:Object):SlotFreeGameDTO
		{
			var dto:SlotFreeGameDTO = new SlotFreeGameDTO();
			if (obj)
			{
			
				var slotDto:SlotGameBaseGameDTO = obj.data[obj.currentIdx] as SlotGameBaseGameDTO;
				
				dto.currentFreeGameIndex = obj.currentIdx + 1;
				dto.totalFreeGameIndex = obj.data.length;
				
				
				dto.freeGameWon	= slotDto.baseGameWon;	
				dto.totalFreeGameWon = 0;
				
				for (var i:uint = 0; i <= obj.currentIdx; i++)
				{
					dto.totalFreeGameWon += obj.data[i].baseGameWon;
				}
				dto.stops = slotDto.stops;
				
				dto.mathSpecificParams = slotDto.mathSpecificParams;
				dto.winLineInfo = slotDto.winLineInfo;
				dto.scatterInfo = slotDto.scatterInfo;
				
				
				obj.currentIdx += 1;
			}
			else
			{
				dto.currentFreeGameIndex = 0;
				dto.totalFreeGameIndex = 15;
				dto.totalFreeGameWon = 0;
				dto.freeGameWon = 0;
			}
			
			return dto;
		}
	}
}