package com.aspectgaming.game.net.parse.cmd
{
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.parse.SlotParse;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.request.SlotFreeGameIntroC2S;
	import com.aspectgaming.game.net.vo.request.SlotFreeGameOutroC2S;
	import com.aspectgaming.net.amf.parse.cmd.BaseCommand;
	
	public class ParseFreeGameCommand extends BaseCommand
	{
		override public function execute(data:*=null, requestData:*=null):void
		{
			SlotParse.parserbaseGameDto(data.baseGame as SlotGameBaseGameDTO, data.msgId);
			if(data.msgId == SlotAmfCommand.CMD_FREEGAME_INTRO)
			{
				SlotParse.parserFreeGameDto(data.object as SlotFreeGameDTO, requestData.msgId);
			}
		}
		
		override public function parse(req:String, data:Object=null):*
		{
			if (req == SlotAmfCommand.CMD_FREEGAME_INTRO)
			{
				var freeintro:SlotFreeGameIntroC2S = new SlotFreeGameIntroC2S();
				freeintro.gameId = GameGlobalRef.gameInfo.gameID ;
				freeintro.msgId = SlotAmfCommand.CMD_FREEGAME_INTRO;
				return freeintro;
			}
			else
			{
				var freeOutro:SlotFreeGameOutroC2S = new SlotFreeGameOutroC2S();
				freeOutro.gameId = GameGlobalRef.gameInfo.gameID ;
				freeOutro.msgId = SlotAmfCommand.CMD_FREEGAME_OUTRO;
				return freeOutro;
			}
		}
		
	}
}