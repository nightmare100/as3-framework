package com.aspectgaming.net.vo.response
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.trackserver.web.facade.msg.payment.DataTrackMessageS2C")]
	public class DataTrackMessageS2C
	{
		public var msgId:String;
		public var retCode:int;
		public var result:String;

		/**
		 *
		 */
		public function DataTrackMessageS2C()
		{
		}
	}
}
