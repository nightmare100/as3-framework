package com.aspectgaming.net.vo
{
	import flash.utils.ByteArray;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.SlotCustomizedDTO")]
	public class SlotCustomizedDTO
	{
		public var gameName:String;
		public var gameId:int;
		public var gameImage:ByteArray;

		/**
		 *
		 */
		public function SlotCustomizedDTO()
		{
		}
	}
}
