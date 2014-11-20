package com.aspectgaming.game.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGamePlayC2S")]
	public class SlotGamePlayC2S
	{
		public var msgId:String;
		public var gameId:int;
		//public var buttonName:String;
		public var remark:Object;

		/**
		 *
		 */
		public function SlotGamePlayC2S()
		{
		}
	}
}
