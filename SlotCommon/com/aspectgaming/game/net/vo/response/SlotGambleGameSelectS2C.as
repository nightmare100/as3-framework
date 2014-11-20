package com.aspectgaming.game.net.vo.response
{
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameGambleDTO;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGambleGameSelectS2C")]
	public class SlotGambleGameSelectS2C
	{
		public var msgId:String;
		public var baseGame:SlotGameBaseGameDTO;
		public var object:SlotGameGambleDTO;
		public var retCode:int;
		public var result:String;

		/**
		 *
		 */
		public function SlotGambleGameSelectS2C()
		{
		}
	}
}
