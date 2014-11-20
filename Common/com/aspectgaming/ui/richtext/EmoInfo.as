package com.aspectgaming.ui.richtext
{
	import flash.display.DisplayObject;

	/**
	 * 记录元件信息 
	 * @author mason.li
	 * 
	 */	
	internal class EmoInfo
	{
		public var name:String;
		
		/**
		 * 行内索引 
		 */		
		public var hindex:uint;
		
		/**
		 * 行间索引 
		 */		
		public var vindex:uint;
		public var displayObject:DisplayObject;
		
		public function get sourceName():String
		{
			return "[" + name +  "]";
		}
	}
}