package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.request.SlotGameFreeSpinPlayC2S;
	import com.aspectgaming.game.net.vo.response.SlotGameFreeSpinPlayS2C;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	
	/**
	 * FreeSpin Play 
	 * @author mason.li
	 * 
	 */	
	public class ParseFreeSpinPlayCommand extends BaseCommand
	{
		override public function execute(data:*=null, requestData:*=null):void
		{
			var backData:SlotGameFreeSpinPlayS2C = data as SlotGameFreeSpinPlayS2C;
			
			if (backData.baseGame)
			{
				SlotParse.parserbaseGameDto(backData.baseGame, requestData.msgId);
			}

			//注册后无需再次 设置
			/*if (backData.freeSpin != null || backData.freeSpin.line != -1) 
			{
				if (backData.freeSpin.bet > 0) 
				{
					GameGlobalRef.gameManager.setCrrentEachLineCash( backData.freeSpin.bet );
				}
				GameGlobalRef.gameManager.setCurrentLine( backData.freeSpin.line );
				GameGlobalRef.gameManager.betLineMax = backData.freeSpin.line;
			}*/
			
			SlotParse.parserFreeSpin(backData.freeSpin, requestData.msgId)
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			var freeSpinC2S:SlotGameFreeSpinPlayC2S = new SlotGameFreeSpinPlayC2S();
			freeSpinC2S.msgId = req;
			freeSpinC2S.gameId = GameGlobalRef.gameInfo.gameID ;
			freeSpinC2S.remark = {};
			freeSpinC2S.remark.line = GameGlobalRef.gameManager.currentBetLine;
			freeSpinC2S.remark.bet = GameGlobalRef.gameManager.currentBet;
			
			GameGlobalRef.gameManager.fullSpeicalBaseGameData(freeSpinC2S.remark);
			if (data) 
			{
				for (var key:String in data)
				{
					freeSpinC2S.remark[key] = data[key];
				}
			}
			return freeSpinC2S;
		}
		
	}
}