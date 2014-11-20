package com.aspectgaming.net.facebook.data
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * FaceBook请求数据 
	 * @author mason.li
	 * 
	 */	
	public class FaceBookRequestData
	{
		public var requestFunc:String;
		
		
		/**
		 * 好友类型 
		 */		
		public var friendType:int;
		
		public var faceBookID:String;
		
		/**
		 * ADID 
		 */		
		public var requestID:String;
		
		/**
		 * 发送邀请者的ID 
		 */		
		public var senderID:String;
		
		/**
		 * 发送列表 
		 */		
		public var giftTo:String;
		
		/**
		 * 图片地址 
		 */		
		public var pictureUrl:String;
		
		/**
		 * 描述 
		 */		
		public var description:String;
		
		public var sharedTitle:String;
		
		/**
		 * fb.api 使用参数 
		 */		
		public var urlID:String;
		
		public var giftType:int;
		
		public var rewardAmount:Number;
		
		/**
		 * 上传数据 
		 */		
		public var uploadData:ByteArray;
		
		public var bitmapData:BitmapData;
		
		public function FaceBookRequestData()
		{
		}
		
		/**
		 * 
		 * @param ftype  邀请好友类型
		 * @param fbid   facebookID
		 * @param reqID  adid
		 * @param sendId 邀请者ID
		 * @param giftIds 邀请 或 送礼物好友列表
		 * @param picUrl feed 图片URL
		 * @param dis    feed 描述
		 * @param apiUrl api url
		 * 
		 */		
		public static function createNewRequestData(ftype:int = 0, fbid:String = null, reqID:String = null, sendId:String = null, giftIds:String = null,
													picUrl:String = null, dis:String = null, apiUrl:String = null, reward:Number = 0):FaceBookRequestData
		{
			var data:FaceBookRequestData = new FaceBookRequestData();
			
			data.friendType = ftype;
			data.faceBookID = fbid;
			data.requestID = reqID;
			data.senderID = sendId;
			data.giftTo = giftIds;
			data.pictureUrl = picUrl;
			data.description = dis;
			data.urlID = apiUrl;
			data.rewardAmount = reward;
			
			return data;
		}
	}
}