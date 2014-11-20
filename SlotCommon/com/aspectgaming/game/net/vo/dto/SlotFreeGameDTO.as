package com.aspectgaming.game.net.vo.dto
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.SlotFreeGameDTO")]
	public class SlotFreeGameDTO
	{
		public var totalWager:Number;
		public var freeGameWon:Number;
		public var totalFreeGameWon:Number;
		public var stops:String;
		public var winLineInfo:Array;//element Type is String
		public var mathSpecificParams:Object;
		public var currentFreeGameIndex:int;
		public var totalFreeGameIndex:int;
		public var scatterInfo:String;

		/**
		 *
		 */
		public function SlotFreeGameDTO()
		{
		}
	}
}
