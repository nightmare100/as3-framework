package com.aspectgaming.game.data.singleresult 
{
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.net.vo.dto.SingleResultDTO;
	/**
	 * ...
	 * @author zoe.jin
	 */
	public class SingleResultInfo 
	{
		public var stops:Array;//element Type is int
		public var selectionWin:Array;//element Type is int
		public var selectionWinMultiplier:Array;//element Type is int
		public var selectionSymMask:Array;//element Type is int
		public var scatterWinMask:int;
		public var scatterWin:int;
		public var scatterWinMultiplier:int;
		public var freeSpinsWon:int;
		public var specialMask:int;
			
		public function parse(dto:SingleResultDTO):void
		{
			stops = dto.stops;
			selectionWin = dto.selectionWin;
			selectionWinMultiplier = dto.selectionWinMultiplier;
			selectionSymMask = dto.selectionSymMask;
			scatterWinMask = dto.scatterWinMask;
			scatterWin = dto.scatterWin;
			scatterWinMultiplier = dto.scatterWinMultiplier;
			freeSpinsWon = dto.freeSpinsWon;
			specialMask = dto.specialMask;
		}
		
	}
}