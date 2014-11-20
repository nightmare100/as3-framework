package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.dto.FreeSpinDTO;
	import com.aspectgaming.game.net.vo.request.SlotGameFreeSpinRegisterC2S;
	import com.aspectgaming.game.net.vo.response.SlotGameFreeSpinRegisterS2C;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	
	
	/**
	 * 注册FREE SPIN游戏 
	 * @author mason.li
	 * 
	 */	
	public class ParseRegisterFreeSpinCommand extends BaseCommand
	{
		
		override public function execute(data:*=null, requestData:*=null):void
		{
			var backData:SlotGameFreeSpinRegisterS2C = data as SlotGameFreeSpinRegisterS2C;
			if (backData)
			{
				SlotParse.parserbaseGameDto(backData.baseGame, SlotAmfCommand.CMD_SLOTFREESPIN_REGISTER);
				GameSetting.maxLineNum = backData.baseGame.maxLine; 
				GameGlobalRef.gameManager.gameMode = GameStatue.FREEGAME;

				if (backData.freeSpin != null && backData.freeSpin.line != -1) 
				{
					if (backData.freeSpin.bet > 0) 
					{
						GameGlobalRef.gameManager.setCrrentEachLineCash(backData.freeSpin.bet);
					}
					GameGlobalRef.gameManager.setCurrentLine(backData.freeSpin.line);
					GameGlobalRef.gameManager.betLineMax   		= backData.freeSpin.line;
				}
				GameGlobalRef.gameData.totalWin = 0;
				SlotParse.parserFreeSpin(backData.freeSpin as FreeSpinDTO);
			}
			
			GameGlobalRef.freeGameInfo.freeGameIndex = 0;
			GameGlobalRef.freeGameInfo.totalTimes = GameGlobalRef.gameInfo.freespinCount;
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			var request:SlotGameFreeSpinRegisterC2S = new SlotGameFreeSpinRegisterC2S();
			request.gameId = GameGlobalRef.gameInfo.gameID;
			request.remark = {};
			request.remark.freeSpinNumber = GameGlobalRef.gameInfo.freespinCount;
			
			return request;
		}
		
	}
}