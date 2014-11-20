package com.aspectgaming.game.data
{
	import com.aspectgaming.game.component.bitmapfont.BitmapFontParse;
	import com.aspectgaming.game.constant.WinShowBallDefined;
	import com.aspectgaming.game.constant.asset.AssetDefined;
	import com.aspectgaming.ui.iface.IAssetLibrary;
	import com.aspectgaming.ui.iface.IAssetLibraryEx;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import org.assetloader.core.ILoader;

	/**
	 * 游戏资源类库 
	 * @author mason.li
	 * 
	 */	
	public class GameAssetLibrary
	{
		public static var version:String;
		public static var symbolLibrary:IAssetLibrary;
		public static var bitmapFont:IAssetLibrary;
		
		/**
		 * gambleHistory图标 
		 */		
		public static var gambleHistory:IAssetLibrary;
		
		private static var _gameAssets:Dictionary; 
		
		private static var _gameAssetDomain:ApplicationDomain;
		
		public static function set gameAssetDomain(value:ApplicationDomain):void
		{
			_gameAssetDomain = value;
		}
		
		public static function get customSlotSymbloParse():IAssetLibraryEx
		{
			return symbolLibrary as IAssetLibraryEx;
		}

		public static function set gameAssets(value:Dictionary):void
		{
			_gameAssets = value;
			setupBallInfo();
		}
		
		public static function getGameAssets(key:String):*
		{
			if (_gameAssets[key])
			{
				return ILoader(_gameAssets[key]).data;
			}
			else
			{
				return null;
			}
		}
			

		public static function get gameAssetDomain():ApplicationDomain
		{
			return _gameAssetDomain;
		}

		public static function initBitmap(xml:XML,bitmapData:BitmapData):void
		{
			var dic:Dictionary = new Dictionary();
			for (var i:uint = 0; i < xml.order.length(); i++)
			{
				processGroup(xml.order[i].@area, xml.order[i].@match, xml.order[i].@type, dic);
			}
			bitmapFont = new BitmapFontParse(bitmapData, dic);
		}
		
		public static function initGambleHistory(xml:XML, bitmapData:BitmapData):void
		{
			var dic:Dictionary = new Dictionary();
			var areaArr:Array = String(xml.@area).split(",");
			var rect:Rectangle = new Rectangle(areaArr[0], areaArr[1], areaArr[2], areaArr[3]);
			var matchArr:Array = String(xml.@match).split(",");
			for (var i:uint = 0; i < matchArr.length; i++)
			{
				var tag:String = matchArr[i];
				dic[tag] = [rect.x + i * rect.width, rect.y, rect.width, rect.height].join(",");
			}
			gambleHistory = new BitmapFontParse(bitmapData, dic);
		}
		
		private static function processGroup(area:String, match:String, type:String, dic:Dictionary):void
		{
			var areaArr:Array = area.split(",");
			var rect:Rectangle = new Rectangle(areaArr[0], areaArr[1], areaArr[2], areaArr[3]);
			var matchArr:Array;
			
			if (type == "sign")
			{
				matchArr= match.split(",");
			}
			else
			{
				matchArr= match.split("");
			}
			
			for (var i:uint = 0; i < matchArr.length; i++)
			{
				var tag:String = matchArr[i];
				dic[tag] = [rect.x + i * rect.width, rect.y, rect.width, rect.height].join(",");
			}
		}
		
		public static function getMovieClip(name:String):MovieClip
		{
			var o:DisplayObject = getDisplayObject(name);
			return ((o == null) ? null : (o as MovieClip));
		}
		
		/**
		 * 从应用程序域中获取Sprite
		 * @param name
		 * @param domain
		 * @return 
		 * 
		 */		
		public static function getSprite(name:String):Sprite
		{
			var o:DisplayObject = getDisplayObject(name);
			return ((o == null) ? null : (o as Sprite));
		}
		
		/**
		 * 从应用程序域中获取Sound
		 * @param name
		 * @param domain
		 * @return 
		 * 
		 */		
		public static function getSound(name:String):Sound
		{
			var classReference:Class = getClass(name);
			if(classReference)
			{
				try
				{
					return new classReference() as Sound;
				}
				catch(e:Error)
				{
					trace("DomainUtil getSound error:" + e.toString());
				}
			}
			return null;
		}
		
		/**
		 * 从应用程序域中获取DisplayObject
		 * @param name
		 * @param loader
		 * @return 
		 * 
		 */		
		public static function getDisplayObject(name:String):DisplayObject
		{
			var classReference:Class = getClass(name);
			if (classReference != null)
			{
				try
				{
					return new classReference() as DisplayObject;
				}
				catch(e:Error)
				{
					trace("DomainUtil getDisplayObject error:" + e.toString());
					return null;
				}
			}
			return null;
		}
		
		public static function getBitMapData(name:String):BitmapData
		{
			var classReference:Class = getClass(name);
			if (classReference != null)
			{
				try
				{
					return new classReference() as BitmapData;
				}
				catch(e:Error)
				{
					trace("DomainUtil getDisplayObject error:" + e.toString());
					return null;
				}
			}
			return null;
		}
		
		/**
		 * 从应用程序域中获取Class
		 * @param name
		 * @param domain
		 * @return 
		 * 
		 */	
		public static function getClass(name:String):Class
		{
			if(gameAssetDomain.hasDefinition(name))
			{
				return gameAssetDomain.getDefinition(name)as Class;
			}
			else
			{
//				trace("GameAsset getClass not hasDefinition:"+name);
			}
			return null;
		}
		
		public static function hasDefinition(name:String):Boolean
		{
			
			if(gameAssetDomain.hasDefinition(name))
			{
				return true;
			}
			else
			{
				return false;	
			}
		}
		
		/**
		 * 取WINSHOW球体元件 
		 * @param type
		 * @param ballType
		 * @return 
		 * 
		 */		
		public static function getWinShowBall(type:String, ballType:String = "ballsmall"):DisplayObject
		{
			if (ballType == AssetDefined.BALL_SMALL)
			{
				return _ballParse.getDisplayObject(type);
			}
			else
			{
				return _bigBallParse.getDisplayObject(type);
			}
		}
		
		/**
		 * Winshow球体 
		 * 
		 */		
		private static function setupBallInfo():void
		{
			var assetBallSmall:Bitmap = getGameAssets(AssetDefined.BALL_SMALL);
			var assetBallBig:Bitmap = getGameAssets(AssetDefined.BALL_BIG);
			
			_ballParse = new BitmapFontParse(assetBallSmall.bitmapData, getDicInfo(assetBallSmall, AssetDefined.BALL_SMALL));
			_bigBallParse = new BitmapFontParse(assetBallBig.bitmapData, getDicInfo(assetBallBig, AssetDefined.BALL_BIG));
		}
		
		private static function getDicInfo(bitmap:Bitmap, type:String):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			var width:Number = bitmap.width / 3;
			var height:Number = bitmap.height;
			dic[WinShowBallDefined.FREE_GAME_BLUE] = [0, 0, width, height].join(",");
			dic[WinShowBallDefined.NO_WIN_YELLOW] = [width, 0, width, height].join(",");
			dic[WinShowBallDefined.WIN_RED] = [width * 2, 0, width, height].join(",");
			
			if (type == AssetDefined.BALL_BIG)
			{
				bigBallInfo = new Rectangle(0, 0,width, height);
			}
			else
			{
				smallBallInfo = new Rectangle(0, 0,width, height);
			}
			
			return dic;
		}
		
		private static var _ballParse:IAssetLibrary; 
		private static var _bigBallParse:IAssetLibrary;
		public static var bigBallInfo:Rectangle;
		public static var smallBallInfo:Rectangle;
		
		public static function dispose():void
		{
			symbolLibrary 	= null;
			bitmapFont		= null;

			gambleHistory	= null;
			
			_gameAssets		= null; 
			_gameAssetDomain = null;
			_ballParse = null;
			_bigBallParse = null;
		}
	}
}