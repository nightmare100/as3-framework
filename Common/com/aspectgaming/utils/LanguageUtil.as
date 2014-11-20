package com.aspectgaming.utils
{
	import com.aspectgaming.constant.global.LanguageType;
	import com.aspectgaming.data.configuration.Configuration;
	import com.aspectgaming.globalization.managers.ClientManager;

	public class LanguageUtil
	{
		private static var _loading:String;
		private static var _connectFB:String;
		private static var _searchWord:String;
		
		initliaze();

		public static function get searchWord():String
		{
			return _searchWord;
		}

		private static function initliaze():void
		{
			var lang:String = StringUtil.isEmptyString(ClientManager.currentLanuage) ? Configuration.general.defautLanguage : ClientManager.currentLanuage;
			switch(lang)
			{
				case LanguageType.LANG_EN_US:
					_loading = "Loading";
					_connectFB = "Connecting to Facebook...";
					_searchWord = "Search";
					break;
					
				case LanguageType.LANG_TH_TH:
					_loading = "กำลังโหลด";
					_connectFB = "กำลังเชื่อมต่อกับเฟซบุ๊ค...";
					_searchWord = "ค้นหาเพื่อน";
					break;
					
				case LanguageType.LANG_ZH_TW:
					_loading = "加载中";
					_connectFB = "正在連接臉書...";
					_searchWord = "搜索好友";
					break;
					
				case LanguageType.LANG_ES_ES:
					_loading = "Cargando";
					_connectFB = "Conectando a Facebook...";
					_searchWord = "Buscar";
					break;	
					
				default:
					_loading = "Loading";
					_connectFB = "Connecting to Facebook...";
					_searchWord = "Search";
					break;
			}
		}
		
		public static function get connectFB():String
		{
			return _connectFB;
		}

		public static function get loading():String
		{
			return _loading;
		}
	}
}