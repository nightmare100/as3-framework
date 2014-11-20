package com.aspectgaming.game.config.text
{
	import flash.utils.Dictionary;

	/**
	 * 游戏多语言文本包 
	 * @author mason.li
	 * 
	 */	
	public class GameLanguageTextConfig
	{
		private static var _textDic:Dictionary;
		
		public static function init(config:XML, lang:String):void
		{
			_textDic = new Dictionary();
			for each (var xml:XML in config.text)
			{
				_textDic[String(xml.@id)] = String(xml[lang]);
			}
		}
		
		public static function getLangText(key:String):String
		{
			if (_textDic[key])
			{
				return _textDic[key];
			}
			else
			{
				return "";
			}
		}
	}
}