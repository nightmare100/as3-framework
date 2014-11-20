package com.aspectgaming.net.facebook
{
	import com.aspectgaming.constant.JSMethodType;
	import com.aspectgaming.constant.global.LanguageConfigMap;
	import com.aspectgaming.data.configuration.Configuration;
	import com.aspectgaming.error.ServerErrorAgent;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.net.facebook.constant.FaceBookMethod;
	import com.aspectgaming.net.facebook.constant.FaceBookUIMethod;
	import com.aspectgaming.net.facebook.data.FaceBookDataSimulation;
	import com.aspectgaming.net.facebook.data.FaceBookRequestData;
	import com.aspectgaming.net.facebook.utils.FaceBookUtil;
	import com.aspectgaming.popup.AlertManager;
	import com.aspectgaming.utils.ExternalUtil;
	import com.aspectgaming.utils.LoggerUtil;
	import com.aspectgaming.utils.URLUtil;
	import com.aspectgaming.utils.constant.LogType;
	import com.brokenfunction.json.decodeJson;
	import com.brokenfunction.json.encodeJson;
	import com.facebook.graph.Facebook;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * faceBook 相关请求处理  
	 * 原 AGTOFACEBOOK 类
	 * @author mason.li
	 * 
	 */	
	public class FaceBookHandler
	{
		private const ALBUMS_NAME:String = "Grand Orient Casino";
		
		/**
		 * 相册ID 
		 */		
		private var albumsId:String;
		
		private var _faceBookRequestInfo:Dictionary;
		
		public static function faceBookAction(method:String, callBack:Function = null, facebookData:FaceBookRequestData = null):void
		{
			getInstance().faceBookAction(method, callBack, facebookData)
		}
		
		
		public function FaceBookHandler()
		{
			if (!ClientManager.useFaceBookConnect)
			{
				_faceBookSimulation = new FaceBookDataSimulation();
			}
			_faceBookRequestInfo = new Dictionary();
		}
		
		/**
		 * 请求FACEBOOK 
		 * @param method    方法名
		 * @param callBack  回调函数 统一格式 callBack(obj:Object);	
		 * @param arg		参数
		 * 
		 */		
		public function faceBookAction(method:String, callBack:Function = null, facebookData:FaceBookRequestData = null):void
		{
			if (callBack != null)
			{
				_faceBookRequestInfo[callBack] = new RequestData(method, facebookData);
			}
			madeRequestLog(method, facebookData);
			
			if (!ClientManager.useFaceBookConnect)
			{
				processCallBack(callBack, _faceBookSimulation.getDataByType(method));
				return;
			}
			else
			{
				var url:String;
				var data:Object;
				switch (method)
				{
					//基本功能
					case FaceBookMethod.Initialize:
						Facebook.init(ClientManager.appID , callBack);
						break;
					case FaceBookMethod.LogIn:
						url = FaceBookUtil.getLoginUrl(ClientManager.appID, FaceBookUtil.RedirectUrl); 
						ExternalUtil.call(JSMethodType.TO_LOGIN, url)
						break;
					case FaceBookMethod.LogOut:
						Facebook.logout(callBack);
						break;
					
					//使用原始Urlload请求
					case FaceBookMethod.GetFriendList:
					case FaceBookMethod.GetFriendHeadIcon:
					case FaceBookMethod.GetInviteSenderID:
					case FaceBookMethod.SendInviteSenderBack:
					case FaceBookMethod.DelInviteMessage:
					case FaceBookMethod.getAppToken:
					case FaceBookMethod.SendTierUp:
						processSourceRequest(method, callBack, facebookData);
						break;
					
					//Fb.ui
					case FaceBookMethod.InviteFriends:
					case FaceBookMethod.SendGiftToAllFriend:
					case FaceBookMethod.SendGiftToSelectFriend:
					case FaceBookMethod.ShareToFeed:
					case FaceBookMethod.SendLevelUp:
					case FaceBookMethod.SendGameUnLocked:
					//case FaceBookMethod.ShareTierUp:
						processFBUI(method, callBack, facebookData);
						break;
					
					/*case FaceBookMethod.getPromotionBonus:
						trace("faceBookAction_getPromotionBonus");
						processFBUI(method, callBack, facebookData);
						break;*/
						
					//Fb.api
					case FaceBookMethod.GetUserDetail:
						Facebook.api("/" + facebookData.faceBookID , getLogCallBack(callBack));
						break;
					
					case FaceBookMethod.getLikes:
						Facebook.api("/" + ClientManager.lobbyModel.facebookUser.facebookID + "/likes", getLogCallBack(callBack) );
						break;
					
					case FaceBookMethod.SendToTimeLine:
						data = {new_level:FaceBookUtil.getAcivityUrl() + facebookData.urlID };
						Facebook.api("/me/" + ClientManager.appName + ":reach", getLogCallBack(callBack), data, "POST");
						break;
					
					case FaceBookMethod.sendBigWins:
						data = {big_win:FaceBookUtil.getAcivityUrl() + facebookData.urlID };
						Facebook.api("/me/" + ClientManager.appName + ":win", getLogCallBack(callBack), data, "POST");
						sendToURL(new URLRequest(Configuration.servers.shareServerUrl));
						break;
					
					case FaceBookMethod.sendFreeSpin:
						data = {free_spin:FaceBookUtil.getAcivityUrl() + facebookData.urlID };
						Facebook.api("/me/" + ClientManager.appName + ":reward", getLogCallBack(callBack), data, "POST");
						sendToURL(new URLRequest(Configuration.servers.shareServerUrl));
						break;
					
					case FaceBookMethod.SendGamePlay:
						data = {game_play:FaceBookUtil.getAcivityUrl() + facebookData.urlID };
						Facebook.api("/me/" + ClientManager.appName + ":play", getLogCallBack(callBack), data, "POST");
						sendToURL(new URLRequest(Configuration.servers.shareServerUrl));
						break;
					
					case FaceBookMethod.postToAlbums:
						uploadPhoto(facebookData ,getLogCallBack(callBack));
						break;
					
					case FaceBookMethod.checkAlbums:
						processAlbums();
						break;
					
					case FaceBookMethod.CheckPhotoPreMission:
						checkPhtoPremission(getLogCallBack(callBack));
						break;
				}
			}
		}
		
		/**
		 * 监测user_photos权限 
		 * 
		 */		
		private function checkPhtoPremission(callBack:Function):void
		{
			Facebook.api("/me/permissions", function(obj:Object):void{
				if (callBack != null)
				{
					callBack(obj);
				}
			}, null, "GET");
		}
		
		/**
		 * Facebook .ui方式 调用网页JS 
		 * @param method
		 * @param callBack
		 * @param data
		 * 
		 */		
		private function processFBUI(method:String, callBack:Function = null, data:FaceBookRequestData = null):void
		{
			var json:Object = {};
			var fbMethod:String;
			switch (method)
			{
				case FaceBookMethod.InviteFriends:
					json.message = Configuration.getConfigedWord(LanguageConfigMap.FB_LeaderCompetition);						//'Slot Game Invite Request'
					json.title = Configuration.getConfigedWord(LanguageConfigMap.FB_InviteFriendWord);						//'Invite your friends to join Grand Orient Casino'
					json.data = 'Something to track';
					if (data.giftTo)
					{
						json.to = data.giftTo;
					}
					else
					{
						json.filters = "['app_non_users']";
					}
					
					fbMethod = FaceBookUIMethod.AppRequest;
					
					break;
				
				case FaceBookMethod.SendGiftToAllFriend:
					json.message = Configuration.getConfigedWord(LanguageConfigMap.FB_SendGiftWord);							//'I sent you a free cash gift! Send me back one!'
					json.title = Configuration.getConfigedWord(LanguageConfigMap.FB_SendGiftToFriend);						//'Send gifts to your friends!'
					json.filters = "['app_users']";
					json.data = 'Something to track';
					json.exclude_ids = '[' + ClientManager.lobbyModel.getSendList().join(",") + ']';
					fbMethod = FaceBookUIMethod.AppRequest;
					break;
				
				case FaceBookMethod.SendGiftToSelectFriend:
					json = FaceBookUtil.getSendGiftData(data.giftTo, data.giftType);
					fbMethod = FaceBookUIMethod.AppRequest;
					break;
					
				case FaceBookMethod.ShareToFeed:	//通用的share to friend，传入data中包含3个属性
					json = FaceBookUtil.getFaceBookShareInfo(data.description, data.pictureUrl, data.sharedTitle);
					fbMethod = FaceBookUIMethod.Feed;
					sendToURL(new URLRequest(Configuration.servers.shareServerUrl));
					break;
				
				case FaceBookMethod.SendLevelUp:
					var str:String = Configuration.getConfigedWord(LanguageConfigMap.FB_REACH_LEVEL);
					str = str.replace("{levelName}", ClientManager.lobbyModel.levelInfo.currentLevel);
					str = str.replace("{num}", (data.rewardAmount).toString());
					str = str.replace("{publishName}", ClientManager.currGame.publishName);
					
					json = FaceBookUtil.getFaceBookShareInfo(str, URLUtil.getLobbyImage("post_levelup_200.png"));
					fbMethod = FaceBookUIMethod.Feed;
					sendToURL(new URLRequest(Configuration.servers.shareServerUrl));
					break;
				case FaceBookMethod.SendGameUnLocked:
					
					json = FaceBookUtil.getFaceBookShareInfo(data.sharedTitle, data.pictureUrl);
					fbMethod = FaceBookUIMethod.Feed;
					sendToURL(new URLRequest(Configuration.servers.shareServerUrl));
					break;
					
				/*case FaceBookMethod.getPromotionBonus:
					trace("processFBUI_getPromotionBonus");
					var str1:String = Configuration.getConfigedWord(LanguageConfigMap.MiniGameBonus);
					str1 = str1.replace("{num}", (data.rewardAmount).toString());
					json = FaceBookUtil.getFaceBookShareInfo(str1, URLUtil.getLobbyImage("post_levelup_200.png"));
					fbMethod = FaceBookUIMethod.Feed;
					sendToURL(new URLRequest(Configuration.servers.shareServerUrl));
					break;*/
					
			}
			
			callBack = getLogCallBack(callBack);
			Facebook.ui(fbMethod, json, callBack, FaceBookUtil.DISPLAY);
		}
		
		private function getLogCallBack(callBack:Function):Function
		{
			if (callBack == null)
			{
				return callBack;
			}
			else
			{
				var backFunction:Function = function(obj:Object):void
				{
					madeResponseLog(callBack, obj);
					callBack(obj);
				};
				return backFunction;
			}
		}
		
		private function madeRequestLog(type:String, data:FaceBookRequestData):void
		{
			LoggerUtil.logServer(data, LogType.LOG_FACEBOOK_REQUEST, type);
		}
		
		private function madeResponseLog(cb:Function, backData:Object):void
		{
			var data:RequestData = _faceBookRequestInfo[cb];
			if (data)
			{
				LoggerUtil.logServer(backData, LogType.LOG_FACEBOOK_RESPONSE, data.methodName);
				_faceBookRequestInfo[cb] = null;
				delete _faceBookRequestInfo[cb];
			}
		}
		
		private function processCallBack(cb:Function, backData:Object):void
		{
			if (cb != null)
			{
				cb(backData);
				madeResponseLog(cb, backData);
			}
		}
		
		/**
		 * UrlLoader方式请求 
		 * @param method
		 * @param callBack
		 * @param data
		 * 
		 */		
		private function processSourceRequest(method:String, callBack:Function = null, data:FaceBookRequestData = null):void
		{
			var fql:String;
			var url:String;
			
			switch (method)
			{
				case FaceBookMethod.GetFriendList:
					fql = FaceBookUtil.getFriendListByType(data.friendType);
					if (!Facebook.getAuthResponse())
					{
						return;
					}
					url = FaceBookUtil.FaceBookGraphUrl + fql + "&access_token=" +Facebook.getAuthResponse().accessToken;
					
					break;
				case FaceBookMethod.GetFriendHeadIcon:
					fql = 'fql?q=SELECT pic_small FROM user WHERE uid =' + data.faceBookID + "&access_token=" + Facebook.getAuthResponse().accessToken;
					url = FaceBookUtil.FaceBookGraphUrl + fql ;
					break;
				case FaceBookMethod.GetInviteSenderID:
					fql = 'fql?q=SELECT request_id, app_id, recipient_uid, sender_uid FROM apprequest WHERE request_id = ' + data.requestID + "&access_token=" + Facebook.getAuthResponse().accessToken;
					url = FaceBookUtil.FaceBookGraphUrl + fql;
					break;
				case FaceBookMethod.SendInviteSenderBack:
					var str:String = Configuration.getConfigedWord(LanguageConfigMap.FB_ACCEPT);		//20121012
					str = str.replace("{username}", ClientManager.lobbyModel.facebookUser.userName);
					url = FaceBookUtil.FaceBookGraphUrl + data.senderID + "/apprequests?message=" + encodeURIComponent(str) + "&access_token=" + ClientManager.appAccessToken + "&method=post";
					break;
				case FaceBookMethod.DelInviteMessage:
					url= FaceBookUtil.FaceBookGraphUrl + data.requestID + "_" + ClientManager.lobbyModel.facebookUser.facebookID + "?access_token=" + ClientManager.appAccessToken + "&method=delete"
					break;
				case FaceBookMethod.getAppToken:
					url = "https://graph.facebook.com/oauth/access_token?client_id=" + ClientManager.appID + "&client_secret=" + ClientManager.appSecret + "&grant_type=client_credentials";
					break;
			}
			
			
			var urlRequest:URLRequest = new URLRequest(url);
			var urlLoader:URLLoader = new URLLoader();
			if (callBack != null)
			{
				urlLoader.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					urlLoader.removeEventListener(Event.COMPLETE, arguments.callee);
					urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
					var backData:Object;
					try
					{
						backData = decodeJson(e.target.data);
					}
					catch (err:Error)
					{
						backData = {data:String(e.target.data)}
					}
					processCallBack(callBack, backData);
				});
			}
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError(method), false, 0, true);
			urlLoader.load(urlRequest);
		}
		
		private function isInErrorList(str:String):Boolean
		{
			if (str == FaceBookMethod.GetFriendList || str == FaceBookMethod.GetFriendHeadIcon)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 上传照片 
		 * @param bm
		 * @param fileName
		 * 
		 */		
		private function uploadPhoto(facebookData:FaceBookRequestData, callBack:Function):void
		{
			if (albumsId)
			{
				Facebook.api("/" + albumsId + "/photos", function(obj:Object):void{
					if (callBack != null)
					{
						callBack();
					}
				}, {source: facebookData.bitmapData,message:facebookData.description , fileName : "ScreenShoot" + getTimer()}, "POST");
			}
		}
		
		/**
		 * 相册处理逻辑 
		 * @param callBack
		 * @param data
		 * 
		 */		
		private function processAlbums():void
		{
			if (!albumsId)
			{
				Facebook.api("/me/albums", function(backData:Object):void{
					for (var i:uint = 0; i < backData.length; i++)
					{
						if (backData[i].name == ALBUMS_NAME)
						{
							albumsId = backData[i].id;
							return;
						}
					}
					if (!albumsId)
					{
						//create
						var postData:Object = {name : ALBUMS_NAME, message:"", privacy:encodeJson({value: "EVERYONE"})};
						Facebook.api("/me/albums", function(obj:Object):void{
							if (obj.id)
							{
								albumsId = obj.id;
							}
						}, postData, "POST");
					}
				}, null, "GET");
			}
		}
		
		private function onError(method:String):Function
		{
			var fun:Function = function(e:IOErrorEvent):void
			{
				var target:URLLoader = e.target as URLLoader;
				target.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				target.removeEventListener(Event.COMPLETE, arguments.callee);
				
				if (method == FaceBookMethod.getAppToken)
				{
					AlertManager.showAlert(Configuration.getConfigedWord(LanguageConfigMap.FaceBookAppTokenError), function():void{
						ExternalUtil.call(JSMethodType.PAGE_REFLUSH);
					});
					return;
				}
				
				if (isInErrorList(method))
				{
					LoggerUtil.traceNormal("FaceBook Request Error!!");
					ServerErrorAgent.defaultError();
				}
			}
			return fun;
		}
		
		private static var _instance:FaceBookHandler;
		
		/**
		 * faceBook数据模拟对象 
		 */		
		private var _faceBookSimulation:FaceBookDataSimulation;
		
		private static function getInstance():FaceBookHandler
		{
			if (!_instance)
			{
				_instance = new FaceBookHandler();
			}
			return _instance;
		}
	}
}
import com.aspectgaming.net.facebook.data.FaceBookRequestData;

class RequestData
{
	public var methodName:String;
	public var faceBookData:FaceBookRequestData;
	public function RequestData(name:String, fbData:FaceBookRequestData)
	{
		methodName = name;
		faceBookData = fbData;
	}
}