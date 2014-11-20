package com.aspectgaming.game.net.vo.dto
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.SingleResultDTO")]
	public class SingleResultDTO
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

		/**
		 *
		 */
		public function SingleResultDTO()
		{
		}
	}
}
