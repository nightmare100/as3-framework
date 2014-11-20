package com.aspectgaming.game.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGambleGameC2S")]
	public class SlotGambleGameC2S
	{
		public var msgId:String;
		public var gameId:int;

		/**
		 *
		 */
		public function SlotGambleGameC2S()
		{
		}
	}
}
