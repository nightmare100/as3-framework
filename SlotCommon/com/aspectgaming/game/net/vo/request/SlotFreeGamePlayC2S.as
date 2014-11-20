package com.aspectgaming.game.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotFreeGamePlayC2S")]
	public class SlotFreeGamePlayC2S
	{
		public var msgId:String;
		public var gameId:int;
		public var remark:Object;

		/**
		 *
		 */
		public function SlotFreeGamePlayC2S()
		{
		}
	}
}
