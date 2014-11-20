package com.aspectgaming.game.net.vo.dto
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.SlotGameGambleDTO")]
	public class SlotGameGambleDTO
	{
		public var gambleCradDraw:int;
		public var gambleSelection:int;
		public var gambleWon:Boolean;
		public var currentGambleIndex:int;
		public var totalGambleIndex:int;
		public var totalGambleWon:Number;
		public var gambleWager:Number;
		public var gambleCardDrawHistory:String;
		public var gambleHalf:Boolean;

		/**
		 *
		 */
		public function SlotGameGambleDTO()
		{
		}
	}
}
