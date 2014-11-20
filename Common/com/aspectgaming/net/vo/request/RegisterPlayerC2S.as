package com.aspectgaming.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.lobby.RegisterPlayerC2S")]
	public class RegisterPlayerC2S
	{
		public var msgId:String;
		public var firstName:String;
		public var lastName:String;
		public var email:String;
		public var facebookId:String;
		public var adSource:String;
		public var thirdPathId:String;		//from ClientManager.lobbyModel.facebookUser.adID
		public var sex:String;
		public var brithday:String;
		public var language:String;
		public var timelineId:String;
		public var timelineExpireDate:String;
		public var location:String;
		public var age:String;
		/**
		 *
		 */
		public function RegisterPlayerC2S()
		{
		}
	}
}
