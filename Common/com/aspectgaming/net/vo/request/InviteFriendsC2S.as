package com.aspectgaming.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.lobby.InviteFriendsC2S")]
	public class InviteFriendsC2S
	{
		public var msgId:String;
		public var inviteeFbIds:Array;

		/**
		 *
		 */
		public function InviteFriendsC2S()
		{
		}
	}
}
