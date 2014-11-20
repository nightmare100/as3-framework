package com.aspectgaming.game.net.vo.response
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRefreshBalanceS2C")]
	public class SlotGameRefreshBalanceS2C
	{
		public var msgId:String;
		public var retCode:int;
		public var totalCash:Number;
		public var totalDragon:Number;
		public var result:String;

		/**
		 *
		 */
		public function SlotGameRefreshBalanceS2C()
		{
		}
	}
}
