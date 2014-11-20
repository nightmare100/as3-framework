package com.aspectgaming.game.net.vo.response
{
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGamePlayS2C")]
	public class SlotGamePlayS2C
	{
		public var msgId:String;
		public var baseGame:SlotGameBaseGameDTO;
		public var object:Object;
		public var retCode:int;
		public var result:String;

		/**
		 *
		 */
		public function SlotGamePlayS2C()
		{
		}
	}
}
