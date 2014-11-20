package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBonusDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.game.net.vo.request.SlotFreeGamePlayC2S;
	import com.aspectgaming.game.net.vo.request.SlotGamePlayC2S;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	
	import flash.sampler.Sample;
	
	public class ParseGamePlayCommand extends BaseCommand
	{
		
		override public function execute(data:*=null, requestData:*=null):void
		{
			if (data && data.baseGame)
			{
				var baseGameDto:SlotGameBaseGameDTO = data.baseGame;
				SlotParse.parserbaseGameDto(baseGameDto);
				switch (baseGameDto.gameState)
				{
					case GameStatue.GAMBLE:
					case GameStatue.GAMBLE_OR_TAKEWIN:
					case GameStatue.GAMBLE_PENDING:
						SlotParse.parseGambleDto(data.object as SlotGameGambleDTO);
						break;
					
					case GameStatue.BONUS_OUTRO:
					case GameStatue.BONUS_GAME:
						SlotParse.parserBonusDto(data.object as SlotGameBonusDTO);
						break;
					
					case GameStatue.PROGRESSIVE:
						SlotParse.parserProgressiveDto(data.object as WinProgressiveDTO);
						break;
					
					case GameStatue.FREEGAME:
					case GameStatue.FREE_GAME_INTRO:
					case GameStatue.FREE_GAME_OUTRO:
						SlotParse.parserFreeGameDto(data.object as SlotFreeGameDTO, requestData.msgId);
						break;
					
					
					default:
						break;
				}
			}
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			if (req == SlotAmfCommand.CMD_FREEGAME_PLAY)
			{
				//free game play
				var freegame:SlotFreeGamePlayC2S = new SlotFreeGamePlayC2S();
				freegame.msgId = req;
				freegame.gameId = int(GameGlobalRef.gameInfo.gameID);
				freegame.remark = {};
				freegame.remark.line = GameGlobalRef.gameManager.currentBetLine;
				freegame.remark.bet = GameGlobalRef.gameManager.currentBet * GameSetting.betTimes;
				

				GameGlobalRef.gameManager.fullSpeicalBaseGameData(freegame.remark);
				
				if (data) 
				{
					for (var key:String in data)
					{
						freegame.remark[key] = data[key];
					}
				}
				return freegame;
			}
			else
			{
				//base game play
				
				var registerData:SlotGamePlayC2S = new SlotGamePlayC2S();
				registerData.gameId = int(GameGlobalRef.gameInfo.gameID);
				registerData.msgId = req;

				registerData.remark = {};
				
				registerData.remark.line = GameGlobalRef.gameManager.currentBetLine;
				registerData.remark.bet = GameGlobalRef.gameManager.currentEachLineCash * GameSetting.betTimes;
				
				if (data) 
				{
					for (var str:String in data)
					{
						registerData.remark[str] = data[str];
					}
				}
				return registerData;
			}
		}
		
	}
}