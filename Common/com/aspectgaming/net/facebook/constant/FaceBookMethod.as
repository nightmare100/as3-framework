package com.aspectgaming.net.facebook.constant
{
	/**
	 * Fcaebook方法 
	 * @author mason.li
	 * 
	 */	
	public class FaceBookMethod
	{
		/**
		 * 初始化 
		 */		
		public static const Initialize:String = "initialize";
		
		/**
		 * 登陆 
		 */		
		public static const LogIn:String = "login";
		
		/**
		 * 注销 
		 */		
		public static const LogOut:String = "logout";
		
		/**
		 * 获取好友列表 
		 */		
		public static const GetFriendList:String = "getFriendList";
		
		/**
		 * 邀请好友 
		 */		
		public static const InviteFriends:String = "inviteFriends";
		
		/**
		 * 获取faceBook好友头像 
		 */		
		public static const GetFriendHeadIcon:String = "getFriendIcon";
		
		/**
		 * 获取邀请者的ID 
		 */		
		public static const GetInviteSenderID:String = "getInviteSenderID";
		
		/**
		 * 向邀请者发送 一个请求 - 被邀请者已进入游戏 
		 */		
		public static const SendInviteSenderBack:String = "sendInviteSenderBack";
		
		
		/**
		 * 删除邀请者所发的邀请信息 
		 */		
		public static const DelInviteMessage:String = "delInviteMessage";
		
		
		/**
		 * 向所有好友发送礼物 
		 */		
		public static const SendGiftToAllFriend:String = "sendGiftToAllFriend";
		
		/**
		 * 向所选的好友发送礼物 
		 */		
		public static const SendGiftToSelectFriend:String = "sendGiftToSelectFriend";
		
		/**
		 * 获取指定FBID 用户的FACEBOOK基本信息 
		 */		
		public static const GetUserDetail:String = "getUserDetail";
		
		/**
		 * 分享到Feed 
		 */		
		public static const ShareToFeed:String = "shareToFeed";
		
		/**
		 * 分享到FEED LEVELUP 
		 */		
		public static const SendLevelUp:String = "sendLevelUp";
		
		/**
		 * 分享到FEED GAME UNLOCK 
		 */		
		public static const SendGameUnLocked:String = "sendGameUnLocked";
		
		
		/**
		 * 张贴loyalty tier up
		 */
		public static const SendTierUp:String = "sendTierUp";
		
		
		/**
		 * share Tier Up with friends
		 */
		//public static const ShareTierUp:String = "shareTierUp";
		
		
		public static const SendToTimeLine:String = "SendToTimeLine";
		
		public static const SendGamePlay:String = "SendGamePlay";
		
		/**
		 * 获取游戏Token 
		 */		
		public static const getAppToken:String = "getAppToken";
		
		/**
		 * 获取用户是否已Like过 
		 */		
		public static const getLikes:String = "getLikes";
		
		/**
		 * 发送 reward事件 
		 */		 
		public static const sendFreeSpin:String = "sendFreeSpin";
		
		/**
		 * 发送 win事件 
		 */		 
		public static const sendBigWins:String = "sendBigWin";
		
		
		
		/**
		 * 获取用户年龄
		 */		 
		public static const getUserAge:String = "getUserAge";
		
		/**
		 * 发照片到相册 
		 */		
		public static const postToAlbums:String = "postToAlbums"
		
		/**
		 * 检测和创建用户相册
		 */		
		public static const checkAlbums:String = "checkAlbums"
			
		/**
		 * 检查用户相册权限 
		 */			
		public static const CheckPhotoPreMission:String = "checkPhtooPre";	
		
		/**
		 * 获得了促销小游戏的奖励
		 */
		//public static const getPromotionBonus:String = "getPromotionBonus";
		
		
	}
}