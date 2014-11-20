package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.request.SlotGameEndC2S;
	import com.aspectgaming.game.net.vo.response.SlotGameEndS2C;
	import com.aspectgaming.game.utils.SlotInfoUtil;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	
	public class ParseGameEndCommand extends BaseCommand
	{
		
		override public function execute(data:*=null, requestData:*=null):void
		{
			var backData:SlotGameEndS2C = data as SlotGameEndS2C;
			SlotParse.parserbaseGameDto(backData.baseGame, SlotAmfCommand.CMD_GAME_END);
			GameGlobalRef.freeGameInfo.totalWon = 0;
			
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_STATUE_CHANGE, "", "", false));
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			var registerData:SlotGameEndC2S = new SlotGameEndC2S();
			registerData.gameId = GameGlobalRef.gameInfo.gameID;
			return registerData;
		}
		
	}
}