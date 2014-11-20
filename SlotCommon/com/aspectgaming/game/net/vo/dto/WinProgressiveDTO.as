package com.aspectgaming.game.net.vo.dto
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.onlinePlatform.gameserver.game.slotgame.dto.WinProgressiveDTO")]
	public class WinProgressiveDTO
	{
		public var levels:Array;//element Type is WinProgressiveLevelDTO
		public var totalRewardWinAmount:Number;

		/**
		 *
		 */
		public function WinProgressiveDTO()
		{
		}
	}
}
