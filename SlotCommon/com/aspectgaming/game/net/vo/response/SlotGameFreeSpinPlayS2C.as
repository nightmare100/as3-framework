package com.aspectgaming.game.net.vo.response
{
	import com.aspectgaming.game.net.vo.dto.FreeSpinDTO;
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameFreeSpinPlayS2C")]
	public class SlotGameFreeSpinPlayS2C
	{
		public var msgId:String;
		public var baseGame:SlotGameBaseGameDTO;
		public var freeSpin:FreeSpinDTO;
		public var retCode:int;
		public var result:String;

		/**
		 *
		 */
		public function SlotGameFreeSpinPlayS2C()
		{
		}
	}
}
