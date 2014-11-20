package com.aspectgaming.data.newplayerguide
{
	public class GuildSymbolInfo
	{
		public var symbolId : Number;
		
		public var symbolName : String;
		
		public var width : Number;
		
		public var height : Number;
		
		public var x : Number;
		
		public var y : Number;
		
		public var angle : Number;
		
		public var mouseDisable : String;
		
		public var mouseEnabled:Boolean;
		
		public function GuildSymbolInfo(xml:XML)
		{
			symbolName = xml.@symbolName;
			
			symbolId = Number(xml.@symbolId);
			
			x = Number(xml.@x);
			
			y = Number(xml.@y);
			
			
			width = Number(xml.@width);
			
			
			height = Number(xml.@height);
			
			angle = Number(xml.@angle);
			
			mouseDisable = xml.@mousedisable;
			
			mouseEnabled = Boolean(uint(xml.@mouseEnabled));
		}
	}
}