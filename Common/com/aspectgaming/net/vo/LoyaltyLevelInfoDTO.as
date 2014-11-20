package com.aspectgaming.net.vo
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.LoyaltyLevelInfoDTO")]
	public class LoyaltyLevelInfoDTO
	{
		public var levelName:String;
		public var purchaseBonus:Number;
		public var freeChipsEvery:Number;
		public var timeBonus:Number;
		public var enterHighLimits:Boolean;
		public var tableLimit:Number;

		/**
		 *
		 */
		public function LoyaltyLevelInfoDTO()
		{
		}
	}
}
