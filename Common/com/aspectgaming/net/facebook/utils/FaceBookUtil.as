package com.aspectgaming.net.facebook.utils
{
	import com.aspectgaming.constant.GiftType;
	import com.aspectgaming.constant.global.LanguageConfigMap;
	import com.aspectgaming.data.configuration.Configuration;
	import com.aspectgaming.data.vo.TinyPlayer;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.net.facebook.constant.FaceBookFriendType;
	import com.aspectgaming.utils.FormatUtil;
	
	/**
	 * FACEBOOK辅助 
	 * @author mason.li
	 * 
	 */	
	public class FaceBookUtil
	{
		public static const INVITE:String = "invite";
		public static const FILTER_ALEARDY_SEND:int = 1;
		public static const FILTER_APP_USER:int = 2;
		public static const DISPLAY:String = "iframe";
		public static const POPUP:String = "popup";
		public static const RedirectUrl:String = "http://apps.facebook.com/aspectcasinogames";
		public static const ActivityTag:String = "activity/?";
		
		public static const FaceBookGraphUrl:String = "https://graph.facebook.com/";
		
		
		
		public static function getLoginUrl(appID:String, reUrl:String):String
		{
			return 'https://www.facebook.com/dialog/oauth?client_id=' + appID + '&redirect_uri=' + reUrl + '&scope=email%2Cuser_photos%2Cpublish_actions%2Cuser_birthday';
		}
		
		public static function getSendGiftData(giftTo:String, giftType:int):Object
		{
			var str:String;
			var json:Object = { 
				message: Configuration.getConfigedWord(LanguageConfigMap.FB_SendGiftWord),						//"I sent you a free cash gift! Send me back one!"
					to:giftTo,
					title:Configuration.getConfigedWord(LanguageConfigMap.FB_SendGift),							//'Send Gift'
					data : 'Something to track'
			}
			
			switch (giftType) {
				case GiftType.GIFT_TYPE_FREE_GAME://Free Spins
					str = Configuration.getConfigedWord(LanguageConfigMap.FB_FreeSpinRecivie);
					str = str.replace("{num}", Configuration.general.spinAmount);
					json.message = str;
					break;
				case GiftType.GIFT_TYPE_GAME_COIN://Free Coins
					str = Configuration.getConfigedWord(LanguageConfigMap.FB_FreeChipRecivie);
					str = str.replace("{num}", FormatUtil.numFormate(Configuration.general.giftAmount,true));
					json.message = str;
					break;
				case GiftType.GIFT_TYPE_SPIN_PLAY://Free BJ-Hands
					str = Configuration.getConfigedWord(LanguageConfigMap.FB_FreeHandRecivie);
					str = str.replace("{num}", Configuration.general.handAmount);
					json.message = str;
					break;
				case GiftType.GIFT_TYPE_KENO_SPIN://Free keno
					str = Configuration.getConfigedWord(LanguageConfigMap.FB_FreeKenoRecivie);
					str = str.replace("{num}", Configuration.general.kenoAmount);
					json.message = str;
					break;
			}
			return json;
		}
		
		public static function getFaceBookShareInfo(des:String, url:String, title:String = null):Object
		{
			var json:Object = {
				link : ClientManager.facebookCanvasUrl,
				picture : url,
				name: title ? title : Configuration.getConfigedWord(LanguageConfigMap.FB_GOC),												//"Grand Orient Casino "
					caption: ClientManager.facebookCanvasUrl,
					actions: {name: "Play Now", link: ClientManager.facebookCanvasUrl},
					description:des
			};
			return json;
		}
		
		public static function getFriendListByType(type:int):String
		{
			var fql:String;
			switch (type) 
			{
				case FaceBookFriendType.NO_APP_FRIEND:			//非app好友
					fql ='fql?q=SELECT uid, name, first_name, is_app_user FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 0';
					break;
				case FaceBookFriendType.APP_FRIEND:			//app好友
					fql='fql?q=SELECT uid, name, first_name, is_app_user FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1';
					break;
				case FaceBookFriendType.ALL_FRIEND:			//全部好友
					fql='fql?q=SELECT uid, name, first_name, is_app_user FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())';
					break;
			}
			return fql;
		}
		
		public static function changeUserListToDtoList(obj:Object):Array
		{
			var result:Array = [];
			var tinyPlayer:TinyPlayer;
			if (obj.data)
			{
				for (var i:uint = 0; i < obj.data.length; i++)
				{
					tinyPlayer = new TinyPlayer();
					tinyPlayer.fbID = obj.data[i].uid;
					tinyPlayer.fullName = obj.data[i].name;
					tinyPlayer.isAppUser = obj.data[i].is_app_user;
					result.push(tinyPlayer);
				}
			}
			
			return result;
		}
		
		public static function getAcivityUrl():String
		{
			return Configuration.servers.lobbyServer.replace("amfmessage/", "") + FaceBookUtil.ActivityTag;
		}
		
		/**
		 * 提取 TinyPlayer fbID属性  
		 * @param arr
		 * @param tag
		 * @return 返回 fbID 数组
		 * 
		 */		
		public static function getIdsFromTinyPlayer(arr:Array, tag:String = ","):String
		{
			var result:Array = [];
			for (var i:uint = 0; i < arr.length; i++)
			{
				result.push(TinyPlayer(arr[i]).fbID);
			}
			
			return result.join(tag);
		}
		
		/**
		 * 过滤用户 
		 * @param type 过滤类型  1过滤已送过的用户  2.过滤非APP用户
		 * @param array
		 * @return 
		 * 
		 */		
		public static function filterUserByType(type:int, array:Array):Array
		{
			var result:Array = [];
			for (var i:uint = 0; i < array.length; i++)
			{
				if (type == FILTER_ALEARDY_SEND)
				{
					if (!ClientManager.lobbyModel.checkIsSend(TinyPlayer(array[i]).fbID))
					{
						result.push(array[i]);
					}
				}
				else
				{
					if (TinyPlayer(array[i]).isAppUser)
					{
						result.push(array[i]);
					}
				}
			}
			
			result.sortOn("fullName");
			return result;
		}
		
		/**
		 * 通过用户名模糊过滤数组中的用户 
		 * @param name
		 * @param arr
		 * @return 
		 * 
		 */		
		public static function filterUserByName(name:String, arr:Array):Array
		{
			var result:Array = [];
			for (var i:uint = 0; i < arr.length; i++)
			{
				if (TinyPlayer(arr[i]).fullName.toLocaleLowerCase().indexOf(name.toLocaleLowerCase()) != -1)
				{
					result.push(arr[i]);
				}
			}
			
			result.sortOn("fullName");
			return result;
		}
		
		/**
		 * 从数组中过滤  
		 * @param filterList
		 * @param array
		 * @return 返回的数组按fullName排序
		 * 
		 */		
		public static function filterUserByArr(filterList:Array, array:Array):Array
		{
			var result:Array = [];
			var isInList:Boolean;
			for (var i:uint = 0; i < array.length; i++)
			{
				isInList = false;
				for (var j:uint = 0 ; j < filterList.length; j++)
				{
					var fbID:String = filterList[j] is TinyPlayer ? TinyPlayer(filterList[j]).fbID : filterList[j];
					if (fbID == array[i].fbID)
					{
						isInList = true;
						break;
					}
				}
				if (!isInList)
				{
					result.push(array[i]);
				}
			}
			
			result.sortOn("fullName");
			return result;
		}
		
		/**
		 * 数组B删除 数组A中存在的元素  
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		public static function removeDataFromAToB(a:Array,b:Array):Array
		{
			for (var i:uint = 0; i < b.length; i++)
			{
				for each (var player:TinyPlayer in a)
				{
					if (TinyPlayer(b[i]).fbID == player.fbID)
					{
						b.splice(i, 1);
						i--;
						break;
					}
				}
			}
			
			return b;
		}
		
		/**
		 * 设置调试信息 
		 * 
		 */		
		public static function setupDebugInfo():void
		{
			ClientManager.lobbyModel.facebookUser.userEmail = "aaa@aaa.com";
			ClientManager.lobbyModel.facebookUser.adType =  "ad";
			ClientManager.lobbyModel.facebookUser.adID = "18395567";
			ClientManager.lobbyModel.facebookUser.playerID = "33";
			ClientManager.lobbyModel.facebookUser.sessionKey = "d5a42cc1a61bbdb65d81d01ef6fb28a4";
			
			ClientManager.lobbyModel.facebookUser.firstName = "aa";
			ClientManager.lobbyModel.facebookUser.lastName = "bb";
			ClientManager.lobbyModel.facebookUser.userName = "aa bb";
			
			ClientManager.lobbyModel.facebookUser.userBirth = null;
			ClientManager.lobbyModel.facebookUser.userSex = "male";
			ClientManager.lobbyModel.facebookUser.userLocale = "china";
			ClientManager.lobbyModel.facebookUser.userEmail = "";
			ClientManager.lobbyModel.facebookUser.userAge="1-100";
		}
	}
}