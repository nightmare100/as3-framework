package com.aspectgaming.game.net.vo.dto
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.onlinePlatform.gameserver.webservice.dto.UserDTO")]
	public class UserDTO
	{
		public var gameName:String;
		public var userName:String;
		public var operator:String;
		public var sessionKey:String;
		public var sig:String;

		/**
		 *
		 */
		public function UserDTO()
		{
		}
	}
}
