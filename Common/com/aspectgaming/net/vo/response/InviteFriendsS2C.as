package com.aspectgaming.net.vo.response
{
	import com.aspectgaming.net.vo.TinyPlayerDTO;
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.lobby.InviteFriendsS2C")]
	public class InviteFriendsS2C
	{
		public var msgId:String;
		public var retCode:int;
		public var player:TinyPlayerDTO;
		public var inviteReward:Number;
		public var inviteCount:int;
		public var bounsId:Number;

		public var result:String;

		/**
		 *
		 */
		public function InviteFriendsS2C()
		{
		}
	}
}
