package com.aspectgaming.game.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGambleGameSelectC2S")]
	public class SlotGambleGameSelectC2S
	{
		public var msgId:String;
		public var gameId:int;
		public var remark:Object;

		/**
		 *
		 */
		public function SlotGambleGameSelectC2S()
		{
		}
	}
}
