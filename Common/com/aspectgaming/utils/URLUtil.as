package com.aspectgaming.utils 
{
	import com.aspectgaming.data.configuration.Configuration;

	/**
	 * 资源路径管理
	 * @author Mason.Li
	 */
	public class URLUtil 
	{
		public static const LeaderBoardAssetName:String = "LeaderBoard";
		public static const POSTFIX_XML:String = ".xml";
		public static const POSTFIX_SWF:String = ".swf";
		public static const POSTFIX_MP3:String = ".mp3";
		public static const POSTFIX_JPG:String = ".jpg";
		public static const POSTFIX_PNG:String = ".png";
		
		private static const faceBookHeadPicUrl:String = "http://graph.facebook.com/";
		//一级目录
		private static var _lobbyAssetsPath:String;
		private static var _gameAssetsPath:String;
		private static var _lang:String;
		private static var _version:String;
		
		private static const GAME_LOADING_ASSET:String = "loading";
		private static const GAME_NAME:String = "game";
		private static const GAME_SIMULATOR:String = "simulator";
		private static const GAME_SIMULATOR_NEW:String = "NewSimulator";
		
		public static function setupLobbyPath(rootURL:String, lang:String, ver:String, gameUrl:String):void
		{
			_lobbyAssetsPath = rootURL;
			_lang = lang;
			_version = ver;
			_gameAssetsPath = gameUrl;
		}
		
		public static function getLobbyXml(name:String):String
		{
			var url:String = _lobbyAssetsPath + _lang + "/xml/" + name + POSTFIX_XML;
			return getVersion(url);
		}
		
		public static function getLobbySwf(name:String):String
		{
			var url:String = _lobbyAssetsPath + _lang + "/swf/" + name + POSTFIX_SWF;
			return getVersion(url);
		}
		
		public static function getMiniGameSwf(name:String):String
		{
			var url:String = _lobbyAssetsPath + _lang + "/swf/miniGame/" + name + POSTFIX_SWF;
			return url;
		}
		
		public static function getGuideSwf(name:String):String
		{
			var url:String = _lobbyAssetsPath + _lang + "/swf/guide/" + name + POSTFIX_SWF;
			return url;
		}
		
		
		public static function getLobbyImage(name:String):String
		{
			var url:String = _lobbyAssetsPath + _lang + "/image/" + name;
			return getVersion(url);
		}
		
		/**
		 * 新游戏加载路径 
		 * @return 
		 * 
		 */		
		public static function getGameUrl(folder:String):String
		{
			var url:String = _gameAssetsPath + folder + "/" + GAME_NAME + POSTFIX_SWF;
			return getVersion(url);
		}
		
		public static function getSimulatorUrl(isNewGame:Boolean = false):String
		{
			var url:String;
			if (isNewGame)
			{
				url = _gameAssetsPath + GAME_SIMULATOR_NEW + POSTFIX_SWF;
			}
			else
			{
				url = _gameAssetsPath + GAME_SIMULATOR + POSTFIX_SWF;
			}
			return getVersion(url);
		}
		
		/**
		 * 通过完整路径取资源 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getAssetByHolePath(name:String):String
		{
			var url:String = _lobbyAssetsPath + _lang + "/" + name;
			return getVersion(url);
		}
		
		private static function getVersion(url:String):String
		{
			return url + "?v=" + _version;
		}
		
		
		public static function getFacebookPicUrl(id:*, type:String = "square"):String
		{
			return faceBookHeadPicUrl + id + "/picture?type=" + type;
		}
		
		/**
		 * BuyChips资源 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getPromotionUrl(name:String):String
		{
			var url:String = _lobbyAssetsPath + _lang + "/" + Configuration.assetsPath.promotion + name + POSTFIX_SWF;
			return getVersion(url);
		}
		
		/**
		 * 获取新游戏Loading素材 
		 * @param path
		 * @return 
		 * 
		 */		
		public static function getLoadingAsset(path:String):String
		{
			var url:String = _gameAssetsPath + path + "/" + GAME_LOADING_ASSET + POSTFIX_SWF;
			return getVersion(url);
		}
	}

}