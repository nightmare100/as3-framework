package com.aspectgaming.cache.containter
{
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;

	public class AbstractDispatch extends Sprite
	{
		protected var _loader:Loader;
		protected var _displayObject:DisplayObject;
		protected var _url:String;
		protected var _userCache:Boolean;			
		
		public function AbstractDispatch()
		{
			
		}
		
		public function get url():String
		{
			return _url;
		}

		public function setUrl(url:String):void
		{
			_url = url;
		}
		
		protected function startLoad():void
		{
			
		}
		
		protected function addDisplayObject(content:*):void
		{
			
		}
		
		public function setScale(n:Number):void
		{
			this.scaleX = this.scaleY = n;
		}
		
		public function dispose():void
		{

		}
	}
}