package com.aspectgaming.game.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRegisterC2S")]
	public class SlotGameRegisterC2S
	{
		public var msgId:String;
		public var gameId:int;
		public var needInitStops:int;

		/**
		 *
		 */
		public function SlotGameRegisterC2S()
		{
		}
	}
}
