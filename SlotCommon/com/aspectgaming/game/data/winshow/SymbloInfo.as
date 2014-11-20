package com.aspectgaming.game.data.winshow
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * 元件信息 
	 * @author mason.li
	 * 
	 */	
	public class SymbloInfo
	{
		/**
		 * 元件名称 
		 */		
		public var name:String;
		
		/**
		 * 元件相对0,0点的矩形位置 
		 */		
		public var pos:Rectangle;
		
		/**
		 * 元件在轮子中的索引 
		 */		
		public var idx:uint;
		
		/**
		 * 元件所属的 reel名称 
		 */		
		public var reelName:String;
		
		public var displayObject:DisplayObject;
		
		public function get reelIndex():uint
		{
			return uint(reelName.substr(reelName.length - 1)) - 1;
		}
		
		public function isEquip(symbol:SymbloInfo):Boolean
		{
			return name == symbol.name &&　pos == symbol.pos && idx == symbol.idx && reelName == symbol.reelName;
		}
		/**复制当前对象symbol 到传入symbol*/
		public function copySymblo(symbol:SymbloInfo):void
		{
			symbol.name = name;
			symbol.pos = pos;
			symbol.idx = idx;
			symbol.reelName = reelName;
			symbol.displayObject = displayObject;
		}
	}
}