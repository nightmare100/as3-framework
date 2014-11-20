package com.aspectgaming.game.data.gamble
{
	import com.aspectgaming.game.constant.GambleType;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	import com.aspectgaming.game.utils.SlotUtil;
	
	import org.robotlegs.mvcs.Actor;

	/**
	 * Gamble信息 
	 * @author mason.li
	 * 
	 */	
	public class GambleInfo extends Actor
	{
		public var history:Array;
		
		public var isGambleHalf:Boolean;
		
		public var gambleWager:Number;
		
		public var totalGambleWin:Number = 0;
		
		public var currentIndex:int;
		
		public var totalIndex:int;
		
		public var isWon:Boolean;
		
		public var gambleSelection:int;
		
		public var currentDrawCardVal:int;

		public function parse(gamble:SlotGameGambleDTO, cmd:String):void
		{
			trace("GambleInfo parse",cmd)
			history = SlotUtil.stringToArray(gamble.gambleCardDrawHistory);
			isGambleHalf	= gamble.gambleHalf;
			
			gambleWager = gamble.gambleWager;
			totalGambleWin = gamble.totalGambleWon;
			
			if (cmd == SlotAmfCommand.CMD_GAMBLE_GAMESELETE || cmd == SlotAmfCommand.CMD_GAMBLE_GAME) 
			{
				currentIndex 		= gamble.currentGambleIndex;
				totalIndex			= gamble.totalGambleIndex;
				isWon 				= gamble.gambleWon;
				gambleSelection 		= gamble.gambleSelection;
				currentDrawCardVal 	= gamble.gambleCradDraw;
			}
		}
		
		public function reset():void
		{
			isGambleHalf = false;
			isWon = false;
			currentIndex = -1;
			gambleSelection = -1;
			currentDrawCardVal = -1;
			gambleWager = -1;
			totalGambleWin = 0;
			
		}
	}
}