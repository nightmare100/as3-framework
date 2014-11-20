package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBonusDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.game.net.vo.request.SlotGameRegisterC2S;
	import com.aspectgaming.game.net.vo.response.SlotGameRegisterS2C;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	
	
	/**
	 * 游戏普通注册 
	 * @author mason.li
	 * 
	 */	
	public class ParseRegisterGameCommand extends BaseCommand
	{
		
		override public function execute(data:*=null, requestData:*=null):void
		{
			var backData:SlotGameRegisterS2C = data as SlotGameRegisterS2C;
			if (backData)
			{
				SlotParse.parserbaseGameDto(backData.baseGame, SlotAmfCommand.CMD_SLOTGAME_REGISTER);
				GameSetting.priceVariable = backData.pricevariable; 
				
				//普通注册时 需要切换模式
				GameGlobalRef.gameManager.gameMode = GameGlobalRef.gameData.currentStatue;

				if (backData.baseGame)
				{
					GameSetting.maxLineNum = backData.baseGame.maxLine; 
					
					switch (backData.baseGame.gameState)
					{
						case GameStatue.GAMBLE:
						case GameStatue.GAMBLE_OR_TAKEWIN:
							SlotParse.parseGambleDto(backData.object as SlotGameGambleDTO);
							break;
						
						case GameStatue.BONUS_OUTRO:
						case GameStatue.BONUS_PICK:
							SlotParse.parserBonusDto(backData.object as SlotGameBonusDTO);
							break;
						
						case GameStatue.PROGRESSIVE:
							SlotParse.parserProgressiveDto(backData.object as WinProgressiveDTO);
							break;
						
						case GameStatue.FREEGAME:
						case GameStatue.FREE_GAME_INTRO:
						case GameStatue.FREE_GAME_OUTRO:
							SlotParse.parserFreeGameDto(backData.object as SlotFreeGameDTO, SlotAmfCommand.CMD_SLOTGAME_REGISTER);
							break;
						
						
						default:
							break;
					}
				}
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_STATUE_CHANGE, "", "",  GameGlobalRef.gameData.isGaming));
			}
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			var request:SlotGameRegisterC2S = new SlotGameRegisterC2S();
			request.gameId = int(GameGlobalRef.gameInfo.gameID);
			return request;
		}
		
	}
}