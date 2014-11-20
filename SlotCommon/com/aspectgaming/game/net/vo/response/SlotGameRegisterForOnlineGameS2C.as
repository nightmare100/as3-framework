package com.aspectgaming.game.net.vo.response
{
	import com.aspectgaming.game.net.vo.dto.SlotGameBaseGameDTO;
	import com.aspectgaming.net.vo.PlayerDTO;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.SlotGameRegisterForOnlineGameS2C")]
	public class SlotGameRegisterForOnlineGameS2C
	{
		public var msgId:String;
		public var baseGame:SlotGameBaseGameDTO;
		public var object:Object;
		public var retCode:int;
		public var player:PlayerDTO;
		public var result:String;

		/**
		 *
		 */
		public function SlotGameRegisterForOnlineGameS2C()
		{
		}
	}
}
