package com.aspectgaming.net.vo
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.TinyPlayerDTO")]
	public class TinyPlayerDTO
	{
		public var membershipPoints:Number;
		
		/**
		 * 总共的钱 
		 */		
		public var totalAmount:Number;

		/**
		 *
		 */
		public function TinyPlayerDTO()
		{
		}
	}
}
