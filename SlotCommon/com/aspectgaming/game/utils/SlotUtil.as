package com.aspectgaming.game.utils
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.config.text.LanguageReplaceTag;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	/**
	 * SlotGame辅助逻辑 
	 * @author mason.li
	 * 
	 */	
	public class SlotUtil
	{
		public static function parseStringArray(arr:Array, tag:String = ","):Array
		{
			var result:Array = [];
			if (arr)
			{
				for (var i:uint = 0; i < arr.length; i++)
				{
					result[i] = arr[i].split(tag);
				}
			}
			
			return result;
		}
		
		public static function stringToArray(str:String, tag:String = ","):Array
		{
			if (!StringUtil.isEmptyString(str))
			{
				return str.split(tag);
			}
			else
			{
				return [];
			}
		}
		
		/**
		 * 获取线赢的位置 
		 * @return 返回数组  234WAY 长度小于5  
		 * 
		 */		
		public static function getLineWinPos(sLists:Number):Array
		{
			var result:Array = [];
			var str:String = sLists.toString(2);
			var symbloList:Array = str.split("").reverse();
			
			return symbloList;
		}
		
		public static function copyDisplayObject(o:DisplayObject):Bitmap
		{
			if (!o)
			{
				return null;
			}
			var offset:Rectangle = o.getBounds(o);
			lineMatrix.tx = 0 - offset.x;
			lineMatrix.ty = 0 - offset.y;
			
			var bd:BitmapData = new BitmapData(offset.width, offset.height, true, 0);
			bd.draw(o, lineMatrix);
			var bmp:Bitmap = new Bitmap(bd);
			bmp.smoothing = true;
			bmp.width = o.width;
			bmp.height = o.height;
			
			return bmp;
		}
		
		/**
		 * 获取WINLINE组合 精灵 
		 * @return 
		 * 
		 */		
		public static function madeWinLineBox(o:DisplayObject, rects:Vector.<Rectangle>, color:uint, isOutSide:Boolean, thickness:uint):Sprite
		{
			var resultSpr:Sprite = new Sprite();
			var copyObj:Bitmap = copyDisplayObject(o);
			if (copyObj)
			{
				resultSpr.addChild(copyObj);
			}
			
			for (var i:uint = 0; i < rects.length; i++)
			{
				resultSpr.addChild(getRectSpr(isOutSide, thickness, color, rects[i]));
			}
			
			if (copyObj)
			{
				var offset:Rectangle = o.getBounds(o);
				copyObj.x = o.x + offset.x * (o.width / offset.width);
				copyObj.y = o.y + offset.y * (o.height / offset.height);
			}
			
			var bd:BitmapData = new BitmapData(resultSpr.width, resultSpr.height, true, 0);
			var rect:Rectangle = resultSpr.getRect(resultSpr);
			lineMatrix.tx = 0 - rect.x;
			lineMatrix.ty = 0 - rect.y;
			bd.draw(resultSpr, lineMatrix);
			
			for (i = 0; i < rects.length; i++)
			{
				var tempR:Rectangle = rects[i].clone();
				tempR.x -= rect.x;
				tempR.y -= rect.y;
				
				tempR.width = GameSetting.winLine.width;
				tempR.height = GameSetting.winLine.height;
				
				if (!isOutSide)
				{
					tempR.x += thickness;
					tempR.y += thickness;
					tempR.width -= thickness * 2;
					tempR.height -= thickness * 2;
				}
				tempR.x += (rects[i].width - GameSetting.winLine.width) / 2;
				
				bd.fillRect(tempR , 0);
			}
			
			var bitMap:Bitmap = new Bitmap(bd);
			bitMap.smoothing = true;
			var newSpr:Sprite = new Sprite();
			newSpr.addChild(bitMap);
			newSpr.x = rect.x;
			newSpr.y = rect.y;

			newSpr.mouseEnabled = false;
			newSpr.mouseChildren = false;
			return newSpr;
		}
		
		public static function stopScattarSound():void
		{
			for (var i:uint = 1; i <= 3; i++)
			{
				SoundManager.stopSound(SlotSoundDefined.REEL_SCATTOR + i);
			}
		}
		
		public static function processStops(stops:Array):Array
		{
			var result:Array = [];
			for (var i:uint = 0; i < stops.length;i++)
			{
				if (uint(i / GameSetting.reelColume) < 1)
				{
					result.push([]);
				}
				result[i % GameSetting.reelColume].push(stops[i]);
			}
			GameGlobalRef.gameManager.parseSpeicalReel(result);
			return result;
		}
		
		private static function getRectSpr(isOutSide:Boolean, thickNess:uint, color:uint, rect:Rectangle):Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(color, 1);
			
			if (isOutSide)
			{
				s.graphics.drawRect(rect.x - thickNess + (rect.width - GameSetting.winLine.width) / 2, rect.y - thickNess, GameSetting.winLine.width + thickNess * 2, GameSetting.winLine.height + thickNess * 2);
			}
			else
			{
				s.graphics.drawRect(rect.x + (rect.width - GameSetting.winLine.width) / 2, rect.y, GameSetting.winLine.width, GameSetting.winLine.height);	
			}
			
			s.graphics.endFill();
			
			return s;
		}
		
		/**
		 * GetMoreThree Message 
		 * @return 
		 * 
		 */		
		public static function getScatterInfoMsg():String
		{
			var msg:String = GameLanguageTextConfig.getLangText(ConfigTextDefined.GET_3_MORE);
			
			var symbloName:String = GameAssetLibrary.symbolLibrary.getSymbloAdvName("12");
			msg = msg.replace(LanguageReplaceTag.SYMBOL, "["+ symbloName + "]");
			
			return msg;
		}
		
		private static var lineMatrix:Matrix = new Matrix();
	}
}