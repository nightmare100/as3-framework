package com.aspectgaming.game.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRegisterForOnlineGameC2S")]
	public class SlotGameRegisterForOnlineGameC2S
	{
		public var msgId:String;
		public var gameId:int;
		public var userName:String;
		public var operator:String;
		public var sessionKey:String;
		public var sig:String;
		public var currency:String;

		/**
		 *
		 */
		public function SlotGameRegisterForOnlineGameC2S()
		{
		}
	}
}
