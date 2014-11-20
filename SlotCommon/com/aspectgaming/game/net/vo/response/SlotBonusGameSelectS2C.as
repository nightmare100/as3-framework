package com.aspectgaming.game.net.vo.response
{
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBonusDTO;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotBonusGameSelectS2C")]
	public class SlotBonusGameSelectS2C
	{
		public var msgId:String;
		public var baseGame:SlotGameBaseGameDTO;
		public var object:SlotGameBonusDTO;
		public var retCode:int;
		public var result:String;

		/**
		 *
		 */
		public function SlotBonusGameSelectS2C()
		{
		}
	}
}
