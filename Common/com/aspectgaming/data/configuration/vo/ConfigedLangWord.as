package com.aspectgaming.data.configuration.vo 
{
	import flash.utils.Dictionary;
	
	public class ConfigedLangWord 
	{
		private var _langDic:Dictionary;
		
		public function ConfigedLangWord(langXML:XML) 
		{
			_langDic = new Dictionary();
			getData(langXML);
		}
		
		public function getWord(key:String):String
		{
			if (_langDic[key])
			{
				return _langDic[key];
			}
			else
			{
				return "";
			}
		}
		
		private function getData(langXML:XML):void
		{
			var xml:XML;
			for (var i:uint = 0; i < langXML.txt.length(); i++ ) 
			{ 
				xml = langXML.txt[i];
				_langDic[String(xml.@id)] = String(xml);
			}
		}
	}
}