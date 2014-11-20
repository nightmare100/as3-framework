package com.aspectgaming.data.newplayerguide
{
	public class GuildAreaInfo
	{
		public var x : Number;
		
		public var y : Number;
		
		public var width : Number;
		
		public var height : Number;
		
		public var radius : Number;
		
		public var isRec : Boolean;
		
		public var isEpCircle:Boolean;
		
		public function GuildAreaInfo(xml:XML)
		{
			x = Number(xml.@x);
			
			y = Number(xml.@y);
			
			width = Number(xml.@width);
			
			height = Number(xml.@height);
			
			radius = Number(xml.@radius);
			
			isRec = Boolean(uint(xml.@isRec));
			
			isEpCircle = Boolean(uint(xml.@isEpCircle));
		}
	}
}