package com.aspectgaming.data.configuration.vo 
{
	
	public dynamic class GameDescription
	{
		private var _length:int = 0;
		private var _desc:Vector.<DescriptionInfo>;
		
		public function GameDescription(xml:XMLList) 
		{
			_desc = new Vector.<DescriptionInfo>();
			parseData(xml);
		}
		
		private function parseData(xml:XMLList):void
		{
			_length = xml.length();
			
			for (var i:int = 0; i < _length; i++ ) 
			{
				_desc[i] = new DescriptionInfo();
				_desc[i].index = i;
				_desc[i].gameName = xml[i].@gameName;
				_desc[i].description = xml[i].@desc;
				_desc[i].pic = xml[i].@pic;
				_desc[i].bePoped = false;
			}
		}
		
		public function popGame(gameName:String) :DescriptionInfo
		{
			for (var i:int = 0; i < _length; i++ )
			{
				if (_desc[i].gameName == gameName && !_desc[i].bePoped) 
				{
					_desc[i].bePoped = true;
					return _desc[i];
				}
			}
			return null;
		}
		
		public function getDisc(gameName:String):String 
		{
			for (var i:int = 0; i < _length; i++ ) {
				if (_desc[i].gameName == gameName ) {
					return _desc[i].description;
				}
			}
			return null;
		}
		
		public function getPic(gameName:String):String 
		{
			for (var i:int = 0; i < _length; i++ ) {
				if (_desc[i].gameName == gameName ) {
					return _desc[i].pic;
				}
			}
			return null;
		}
	}
}