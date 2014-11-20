package com.aspectgaming.globalization.managers 
{
	import com.aspectgaming.constant.JSMethodType;
	import com.aspectgaming.constant.global.ShareObjectsDictionary;
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.data.client.CurrGame;
	import com.aspectgaming.data.configuration.Configuration;
	import com.aspectgaming.event.GlobalEvent;
	import com.aspectgaming.globalization.module.ModuleDefine;
	import com.aspectgaming.model.LobbyModel;
	import com.aspectgaming.ui.iface.IModule;
	import com.aspectgaming.utils.ExternalUtil;
	import com.aspectgaming.utils.LoggerUtil;
	
	import flash.net.SharedObject;

	/**
	 * 客户端信息管理
	 * @author Mason.Li
	 */
	public class ClientManager 
	{
		public static const FACE_BOOK_SOURCE:String = "facebook";
		public static const UN_LIKE_ID:String = "139688656165154";
		
		//--------------------------------------------------------------
		// 
		//--------------------------------------------------------------
		
		public static var itemMgr:ItemManager;
		
		/**
		 * Lobby model对象 引用 
		 */		
		public static var lobbyModel:LobbyModel;
		
		/**
		 * Lobby server对象 引用 
		 */		
		public static var lobbyServer:IServer;
		
		/**
		 * Game server对象 引用 
		 */	
		public static var gameServer:IServer;
			
		/**
		 * 协议信息 
		 */		
		public static var protocolType:String;
		
		/**
		 * 版本信息 
		 */		
		public static var version:String;
		
		/**
		 * Code 
		 */		
		public static var casionCode:String = "Aspect Gaming";
		
		public static var currGame:CurrGame = new CurrGame();
		 
		public static var appID:String;
		public static var appName:String;
		public static var appAccessToken:String;
		public static var appSecret:String;	
		
		/**
		 * Cookie相关 
		 */		
		public static var canUseCookie:Boolean;
		public static var cookieStr:String;
		
		/**
		 * 当前语言 
		 */		
		public static var currentLanuage:String;
		
		private static var _actionType:String;
		
		/**
		 * 是否和FACEBOOK 通信 
		 */		
		public static var useFaceBookConnect:Boolean;
		
		/**
		 * 是否和自己的服务 通信
		 */		
		public static var useAgServer:Boolean;
		
		/**
		 * 是否使用通信加密 
		 */		
		public static var useEncode:Boolean;
		
		private static var _useAutoCarmer:Boolean = true;
		
		/**
		 * 是否有 user_photos权限 
		 */		
		public static var hasPhotoPremission:Boolean = false;
		
		/**
		 * 是否为本地调试 
		 */		
		public static var isLocalDebug:Boolean;
		
		/**
		 * 来自FACEBOOK 还是 MAKELIVING 见 ComeFromSource 
		 */		
		public static var comeFromSource:String;
		
		/**
		 * Facebook Canvas Url 
		 */		
		public static var facebookCanvasUrl:String;
		
		/**
		 * 当前页面 
		 */		
		public static var currentPage:String;
		
		private static var _isDebug:Boolean = false; 
		
		public static function initSetting():void
		{
			var carmerInfo:SharedObject = SharedObjectManager.getUserSharedObject("carmerInfo");
			_useAutoCarmer = carmerInfo.data[ShareObjectsDictionary.CARMER_SETTING] != null ? carmerInfo.data[ShareObjectsDictionary.CARMER_SETTING] : true;
		}
		
		
		public function ClientManager() 
		{
			
		}
		
		/**
		 * 自动摄像捕捉 
		 */
		public static function get useAutoCarmer():Boolean
		{
			return _useAutoCarmer;
		}

		/**
		 * @private
		 */
		public static function set useAutoCarmer(value:Boolean):void
		{
			_useAutoCarmer = value;
			
			
			var carmerInfo:SharedObject = SharedObjectManager.getUserSharedObject("carmerInfo");
			carmerInfo.data[ShareObjectsDictionary.CARMER_SETTING] = _useAutoCarmer;
			SharedObjectManager.flush(carmerInfo);
			
			var bannerModule:IModule = ModuleManager.getModule(ModuleDefine.BannerModule);
			if (bannerModule && bannerModule.context)
			{
				bannerModule.context.eventDispatcher.dispatchEvent(new GlobalEvent(GlobalEvent.CARMER_CONTROL_CHANGED));
			}
		}

		/**
		 * ActionType 从URL中过来 
		 */
		public static function get actionType():String
		{
			return _actionType;
		}

		/**
		 * @private
		 */
		public static function set actionType(value:String):void
		{
			if (value == "null" || value == "undefined")
			{
				value = null;
			}
			
			_actionType = value;
		}

		public static function init(info:Object):void
		{
			version  				= info["version"];
			currentLanuage 			= info["currentLanuage"];
			actionType 				= info["actionType"]; 		
			protocolType 			= info["protocolType"];
			isDebug 				= info["isDebug"];
			isLocalDebug			= info["isLocal"];
			useEncode				= info["isEncode"];
			useFaceBookConnect 		= info["useFaceBookConnect"];
			useAgServer				= info["useAgServer"];
			canUseCookie 			= info["canUseCookie"];
			appID 					= ExternalUtil.call(JSMethodType.GET_APPID);
			appName					= ExternalUtil.call(JSMethodType.GET_APPNAME);
			appSecret				= ExternalUtil.call(JSMethodType.GET_APPSECRECT);
			facebookCanvasUrl		= info["onlineUrl"];
			
			
			LoggerUtil.enabled = isDebug; 
		}
		
		public static function get isReachNewHighFreeSpin():Boolean
		{
			return ClientManager.currGame.freeSpinRunNum >= Configuration.general.freePopNum && ClientManager.currGame.freeSpinWon >= Configuration.general.freePopAmount;
		}
		
		static public function get isDebug():Boolean 
		{
			return _isDebug;
		}
		
		static public function set isDebug(value:Boolean):void 
		{
			_isDebug = value;
		}
		
		static public function get frameRate():Number
		{
			return LayerManager.stage.frameRate;
		}
		
		/**
		 * 是否为新注册用户 
		 */		
		static public function get isNewPlayer():Boolean
		{
			return lobbyModel.facebookUser.isNewUser;	
		}
		
	}

}