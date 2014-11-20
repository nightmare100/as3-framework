package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBonusDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.game.net.vo.request.SlotGameProgressiveEndC2S;
	import com.aspectgaming.game.utils.SlotInfoUtil;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	import com.aspectgaming.utils.NumberUtil;
	
	public class ParseProgressiveCommand extends BaseCommand
	{
		override public function execute(data:*=null, requestData:*=null):void
		{
			if (data && data.baseGame)
			{
				var baseGameDto:SlotGameBaseGameDTO = data.baseGame;
				SlotParse.parserbaseGameDto(baseGameDto, SlotAmfCommand.CMD_GAME_PROGRESSIVE_END);
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
				GameGlobalRef.gameManager.dispatchToContext(new SlotEvent(SlotEvent.GAME_UPDATE_BALANCE));
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_UPDATE_BALANCE, "", "", SlotInfoUtil.getUpdateBalanceInfo(GameGlobalRef.gameData.totalCent, baseGameDto.playerDragons)));
			}
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			var registerData:SlotGameProgressiveEndC2S = new SlotGameProgressiveEndC2S();
			registerData.msgId = req;
			registerData.gameId = GameGlobalRef.gameInfo.gameID ;
			return registerData;
		}
		
	}
}