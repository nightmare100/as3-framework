package com.aspectgaming.game.net.vo.dto
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.SlotGameBaseGameDTO")]
	public class SlotGameBaseGameDTO
	{
		public var baseGameWon:Number;
		public var stops:String;
		public var winLineInfo:Array;//element Type is String
		public var mathSpecificParams:Object;
		public var scatterInfo:String;
		public var maxLine:int;
		public var maxBet:int;
		public var line:int;
		public var bet:int;
		public var totalCredits:Number;
		public var totalCash:Number;
		public var totalWager:Number;
		public var gameState:String;
		public var gambleOn:Boolean;
		public var lastAccumWin:Number;
		public var playerDragons:Number;		
		public var singleResult:SingleResultDTO;//LuckySpinDoubleWild for now

		/**
		 *
		 */
		public function SlotGameBaseGameDTO()
		{
		}
	}
}
