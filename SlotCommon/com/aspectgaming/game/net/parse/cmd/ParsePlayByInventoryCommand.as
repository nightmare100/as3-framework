package com.aspectgaming.game.net.parse.cmd 
{
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBonusDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.game.net.vo.request.SlotGamePlayByInventoryC2S;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.item.constant.ItemDefined;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	/**
	 * ...
	 * @author zoe.jin
	 */
	public class ParsePlayByInventoryCommand extends BaseCommand
	{
		private var propId:uint;
		private var propNum:Number;
		private var inventorys:Array;
		override public function execute(data:*=null, requestData:*=null):void
		{
			if (data && data.baseGame)
			{
				var baseGameDto:SlotGameBaseGameDTO = data.baseGame;
				SlotParse.parserbaseGameDto(baseGameDto,SlotAmfCommand.CMD_POWER_SPIN);
				
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
				
				//{ item:[ { id:propId, num:propNum } ] }
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.ON_PROP_ITEM_USED, "", "0", {item:inventorys} ));
			}
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			var propPlay:SlotGamePlayByInventoryC2S = new SlotGamePlayByInventoryC2S();
			propPlay.gameId = int(GameGlobalRef.gameInfo.gameID);
			propPlay.msgId = req;
			propPlay.remark = { };
			propPlay.inventorys = { };
			
			inventorys = [];
			var idx:int = 0
			var inventoryNumber:Number;
			for (var i:int = 0; i < data.length; i++ ) {
				var item:Object = data[i] as Object
				
				if (item["id"] == ItemDefined.ITEM_POWER_SPIN) {
					if (propPlay.remark.line == null)	 propPlay.remark.line = GameGlobalRef.gameManager.currentBetLine
					if (propPlay.remark.bet == null)	propPlay.remark.bet = GameGlobalRef.gameManager.currentEachLineCash
					
					inventoryNumber = item.num
					propPlay.inventorys[String(item["id"])] = "-" + String(inventoryNumber);
					inventorys[idx++] = { id:item["id"], num:inventoryNumber }
					
				}else if (item["id"] == ItemDefined.ITEM_ALL_IN) {
					propPlay.remark.line = item.line
					propPlay.remark.bet = item.bet	
					
					inventoryNumber = 1;
					propPlay.inventorys[String(item["id"])] = "-" + String(inventoryNumber);
					inventorys[idx++] = { id:item["id"], num:inventoryNumber }
					
					//update ui
					GameGlobalRef.gameManager.currentEachLineCash = item.bet
					GameGlobalRef.gameManager.currentBetLine = item.line
				}
			}
			
			return propPlay;
		}
		
	}

}