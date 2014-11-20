package com.aspectgaming.game.net.vo.response
{
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameEndS2C")]
	public class SlotGameEndS2C
	{
		public var msgId:String;
		public var baseGame:SlotGameBaseGameDTO;
		public var retCode:int;
		public var result:String;

		/**
		 *
		 */
		public function SlotGameEndS2C()
		{
		}
	}
}
