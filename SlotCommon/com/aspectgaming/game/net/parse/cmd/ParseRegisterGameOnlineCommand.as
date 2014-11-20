package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.request.SlotGameRegisterForOnlineGameC2S;
	import com.aspectgaming.game.net.vo.response.SlotGameRegisterForOnlineGameS2C;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	import com.aspectgaming.utils.NumberUtil;
	
	public class ParseRegisterGameOnlineCommand extends BaseCommand
	{
		override public function execute(data:*=null, requestData:*=null):void
		{
			var backData:SlotGameRegisterForOnlineGameS2C = data as SlotGameRegisterForOnlineGameS2C;
			if (backData)
			{
				//分
				backData.baseGame.totalCash = backData.player.totalAmount;
				backData.baseGame.totalCredits = NumberUtil.centToDollar(backData.player.totalAmount);
				GameSetting.maxLineNum = backData.baseGame.maxLine; 
				
				SlotParse.parserbaseGameDto(backData.baseGame, SlotAmfCommand.CMD_SLOTGAME_REGISTER);
				
				//普通注册时 需要切换模式
				GameGlobalRef.gameManager.gameMode = GameGlobalRef.gameData.currentStatue;
			}
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			var request:SlotGameRegisterForOnlineGameC2S = new SlotGameRegisterForOnlineGameC2S();
			request.gameId = int(GameGlobalRef.gameInfo.gameID);
			request.operator = GameGlobalRef.gameInfo.operator;
			request.currency = GameGlobalRef.gameInfo.currency;
			request.sessionKey = GameGlobalRef.gameInfo.sessionKey;
			request.sig = GameGlobalRef.gameInfo.sig;
			request.userName = GameGlobalRef.gameInfo.playerID;
			
			
			return request;
		}
	}
}