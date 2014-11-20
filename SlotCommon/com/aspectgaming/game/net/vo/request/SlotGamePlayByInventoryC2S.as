package com.aspectgaming.game.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGamePlayByInventoryC2S")]
	public class SlotGamePlayByInventoryC2S
	{
		public var msgId:String;
		public var gameId:int;
		public var remark:Object;
		public var inventorys:Object;

		/**
		 *
		 */
		public function SlotGamePlayByInventoryC2S()
		{
		}
	}
}
