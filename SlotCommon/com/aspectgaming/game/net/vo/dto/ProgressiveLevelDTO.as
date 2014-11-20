package com.aspectgaming.game.net.vo.dto
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.onlinePlatform.gameserver.game.slotgame.dto.ProgressiveLevelDTO")]
	public class ProgressiveLevelDTO
	{
				public var progressiveLevelName:String;
		public var progressiveAmount:Number;
		public var baseCurrency:String;

		/**
		 *
		 */
		public function ProgressiveLevelDTO()
		{
		}
	}
}
