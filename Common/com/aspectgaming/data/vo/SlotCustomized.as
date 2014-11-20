package com.aspectgaming.data.vo 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author zoe.jin
	 */
	public class SlotCustomized 
	{
		private static const SymbolWidth:int = 74;
		private static const SymbolHeight:int = 74;
		
		public static const DEFAULT_NAME:String = "MakeMillions";
		
		public var displayName:String;
		private var _imageData:ByteArray;
		
		private var _symbol:BitmapData;
		
		public function SlotCustomized() 
		{
			displayName = DEFAULT_NAME;
			_imageData = null;
		}
		public function set imageData(byteA:ByteArray):void
		{
			_imageData = byteA;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, setdate);
			loader.loadBytes(byteA);
		}
		private function setdate(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, setdate);
			_symbol = (loaderInfo.content as Bitmap).bitmapData
		}
		
		public function get symbol():BitmapData
		{
			if (_imageData == null) return null;
			
			if (!_symbol)
			{
				_symbol = new BitmapData(SymbolWidth, SymbolHeight, true, 0xFFFFFF);
			}
			//_symbol.setPixels(_symbol.rect, _imageData);
			
			return _symbol;
		}
		
	}

}