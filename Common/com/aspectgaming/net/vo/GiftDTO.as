package com.aspectgaming.net.vo
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.GiftDTO")]
	public class GiftDTO
	{
		public var giftId:Number;
		public var giftName:String;
		public var amount:Number;
		public var giftType:int;
		public var senderId:Number;
		public var senderFirstName:String;
		public var senderLastName:String;
		public var receiveId:Number;
		public var status:int;
		public var sendDate:Date;
		public var expireDate:Date;
		public var giftBack:Boolean;

		/**
		 *
		 */
		public function GiftDTO()
		{
		}
	}
}
