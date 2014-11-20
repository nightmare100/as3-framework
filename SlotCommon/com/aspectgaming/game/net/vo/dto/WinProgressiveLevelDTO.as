package com.aspectgaming.game.net.vo.dto
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.onlinePlatform.gameserver.game.slotgame.dto.WinProgressiveLevelDTO")]
	public class WinProgressiveLevelDTO
	{
		public var progressiveLevelName:String;
		public var progressiveAmount:Number;
		public var rewardWinAmount:Number;
		public var recordId:Number;

		/**
		 *
		 */
		public function WinProgressiveLevelDTO()
		{
		}
	}
}
