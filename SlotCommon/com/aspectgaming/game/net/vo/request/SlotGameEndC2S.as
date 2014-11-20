package com.aspectgaming.game.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameEndC2S")]
	public class SlotGameEndC2S
	{
		public var msgId:String;
		public var gameId:int;

		/**
		 *
		 */
		public function SlotGameEndC2S()
		{
		}
	}
}
