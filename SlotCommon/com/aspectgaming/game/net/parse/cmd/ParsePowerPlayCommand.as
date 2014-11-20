package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBonusDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.game.net.vo.request.SlotGameFreeGamePowerPlayC2S;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	
	public class ParsePowerPlayCommand extends BaseCommand
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
						SlotParse.parserFreeGameDto(data.object as SlotFreeGameDTO);
						break;
					
					
					default:
						break;
				}
			}
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			var powerPlayData:SlotGameFreeGamePowerPlayC2S = new SlotGameFreeGamePowerPlayC2S();
			powerPlayData.msgId = req;
			powerPlayData.gameId = GameGlobalRef.gameInfo.gameID ;
			powerPlayData.remark = {};
			
			powerPlayData.remark.line = GameGlobalRef.gameManager.currentBetLine;
			powerPlayData.remark.bet = GameGlobalRef.gameManager.currentEachLineCash * GameSetting.betTimes;
			
			GameGlobalRef.gameManager.fullSpeicalPowerPlay( powerPlayData.remark);
					
			return powerPlayData;
		}
		
	}
}