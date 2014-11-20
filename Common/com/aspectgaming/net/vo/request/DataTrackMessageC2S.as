package com.aspectgaming.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.trackserver.web.facade.msg.payment.DataTrackMessageC2S")]
	public class DataTrackMessageC2S
	{
		public var msgId:String;
		public var trackPath:String;
		public var playerId:Number;
		public var trackType:String;

		/**
		 *
		 */
		public function DataTrackMessageC2S()
		{
		}
	}
}
