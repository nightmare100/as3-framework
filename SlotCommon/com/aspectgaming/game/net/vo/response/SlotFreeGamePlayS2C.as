package com.aspectgaming.game.net.vo.response
{
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotFreeGamePlayS2C")]
	public class SlotFreeGamePlayS2C
	{
		public var msgId:String;
		public var baseGame:SlotGameBaseGameDTO;
		public var object:SlotFreeGameDTO;
		public var retCode:int;
		public var result:String;

		/**
		 *
		 */
		public function SlotFreeGamePlayS2C()
		{
		}
	}
}
