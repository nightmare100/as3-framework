package com.aspectgaming.game.utils
{
	import com.aspectgaming.game.data.GameGlobalRef;
	
	/**
	 * 游戏资源地址管理 
	 * @author mason.li
	 * 
	 */	
	public class GameUrlUtil
	{
		private static var _baseUrl:String;
		
		public static function setupBase(url:String):void
		{
			_baseUrl = url;
		}
		
		public static function getGameSetUrl():String
		{
			if(GameGlobalRef.gameManager.isMakeliving){
				return getVersion(_baseUrl + "game.set_ml.xml");
			}else{
				return getVersion(_baseUrl + "game.set.xml");
			}
		}
		
		public static function getGameAssetUrlByTag(tag:String):String
		{
			return getVersion(_baseUrl + tag);
		}
		
		public static function getTaskSetUrl():String
		{
			return getVersion(_baseUrl + "taskbar.set.xml");
		}
		
		public static function getGameAssetUrl():String
		{
			if(GameGlobalRef.gameManager.isMakeliving){
				return getVersion(_baseUrl + "game_ml.xml");
			}else{
				return getVersion(_baseUrl + "game.xml");
			}
		}
		
		public static function getLangConfigUrl():String
		{
			return getVersion(_baseUrl + "text.xml");
		}
		
		private static function getVersion(str:String):String
		{
			return str + "?v=" + GameGlobalRef.gameManager.version;
		}
	}
}