package com.aspectgaming.net.vo.request
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.trackserver.web.facade.msg.payment.SendPaymentTrackMessageC2S")]
	public class SendPaymentTrackMessageC2S
	{
		public var msgId:String;
		public var trackPath:String;
		public var playerId:Number;

		/**
		 *
		 */
		public function SendPaymentTrackMessageC2S()
		{
		}
	}
}
