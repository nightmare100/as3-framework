package com.aspectgaming.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 位图数字 
	 * @author mason.li
	 * 
	 */	
	public class BmpFontUtil 
	{
		private static var dict:Dictionary; 
		
		initliaze();
		private static function initliaze():void
		{
			dict = new Dictionary();
			dict["1"] = 1;
			dict["2"] = 2;
			dict["3"] = 3;
			dict["4"] = 4;
			dict["5"] = 5;
			dict["6"] = 6;
			dict["7"] = 7;
			dict["8"] = 8;
			dict["9"] = 9;
			dict["0"] = 10;
			dict["$"] = 11;
			dict[","] = 12;
			dict["."] = 13;
		}
		
		/**
		 * 获取位图数字
		 * @param str
		 * @param fontName  : CashFont|BonusFont|RankFont|LvUpFont
		 * @param space
		 * @return 
		 * 
		 */		
		public static function getBmpString(str:String, fontName:String, space:Number = 0):Bitmap 
		{	
			var bmpString:Bitmap = makeMcString(str, fontName, space);
			return bmpString;
		}
		
		private static function makeMcString(str:String, fontName:String, space:Number):Bitmap 
		{
			var spr:Sprite = new Sprite();
			var charNum:int = str.length;
			var fontMc:MovieClip = DomainUtil.getMovieClip(fontName);
			
			for (var i:int = 0; i < charNum; i++ ) 
			{
				var myChar:String = str.slice(i, i + 1);
				var charFrame:int = dict[myChar];
				
				fontMc.gotoAndStop(charFrame);
				var bmp:Bitmap = bitmapFromSymblo(fontMc);
				if (i > 0) 
				{
					bmp.x = spr.width + space;
				}
				
				bmp.y = 0;
				
				spr.addChild(bmp);
			}
			
			return bitmapFromSymblo(spr);
		}
		
		private static function bitmapFromSymblo(o:DisplayObject):Bitmap
		{
			var bitmapData:BitmapData = new BitmapData(o.width, o.height, true, 0);
			bitmapData.draw(o);
			return new Bitmap(bitmapData);
		}
	}

}