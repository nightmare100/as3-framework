package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.net.vo.request.SlotGambleGameC2S;
	import com.aspectgaming.game.net.vo.request.SlotGambleGameSelectC2S;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	
	/**
	 * Gamble处理 
	 * @author mason.li
	 * 
	 */	
	public class ParseGambleCommand extends BaseCommand
	{
		
		override public function execute(data:*=null, requestData:*=null):void
		{
			trace("ParseGambleCommand",data,requestData)
			SlotParse.parserbaseGameDto(data.baseGame as SlotGameBaseGameDTO);
			SlotParse.parseGambleDto(data.object as SlotGameGambleDTO, requestData.msgId);
			if (data.baseGame.lastAccumWin > 0 && GameGlobalRef.freeGameInfo.totalWon == 0)
			{
				GameGlobalRef.gameData.totalWin = data.baseGame.lastAccumWin;
			}
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			if (req == SlotAmfCommand.CMD_GAMBLE_GAME) 
			{
				var gamblegame:SlotGambleGameC2S = new SlotGambleGameC2S();
				gamblegame.msgId = req;
				gamblegame.gameId = GameGlobalRef.gameInfo.gameID ;
				return gamblegame;
			}
			else
			{
				//gamble Selected
				var gambleSelect:SlotGambleGameSelectC2S = new SlotGambleGameSelectC2S();
				gambleSelect.msgId = req;
				gambleSelect.gameId = GameGlobalRef.gameInfo.gameID ;
				gambleSelect.remark = {};
				
				gambleSelect.remark.gambleHalf = data.betHalf;
				gambleSelect.remark.selection = data.pickValue;
				return gambleSelect;
			}
		}
		
	}
}