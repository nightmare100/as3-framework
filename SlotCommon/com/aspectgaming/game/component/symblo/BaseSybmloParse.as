package com.aspectgaming.game.component.symblo
{
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.ui.iface.IAssetLibrary;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	public class BaseSybmloParse implements IAssetLibrary
	{
		protected var _bitmapDataCache:Dictionary;
		protected const NORMAL_SYMBOL_TAG:String = "S";
		protected const ANI_SYMBOL_TAG:String = "ANI_";
		protected const STOP_TAG:String = "_stop";
		protected const STOP_OVER_TAG:String = "_over";
		
		public function BaseSybmloParse()
		{
			_bitmapDataCache = new Dictionary();
		}
		
		public function set extraDic(dic:Dictionary):void
		{
			
		}
		
		public function processStopAnimation(mc:DisplayObject=null, info:*=null):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		
		
		public function getAniObject(name:String, isStop:Boolean = false,index:int=0):MovieClip
		{
			name = getAniName(name, isStop);
			return GameAssetLibrary.getMovieClip(name);
		}
		
		public function getAniOverObject(name:String):MovieClip
		{
			name = getAniName(name, true);
			return GameAssetLibrary.getMovieClip(name + STOP_OVER_TAG);
		}
		
		public function getDisplayObject(name:String):DisplayObject
		{
			name = getSymbloName(name);
			var bd:BitmapData;
			if (_bitmapDataCache[name])
			{
				bd = _bitmapDataCache[name];
			}
			else
			{
				bd = GameAssetLibrary.getBitMapData(name);
				_bitmapDataCache[name] = bd;
			}
			return new Bitmap(bd);
		}
		
		protected function getAniName(name:String, isStop:Boolean):String
		{
			name = getSymbloName(name);
			if (isStop)
			{
				return ANI_SYMBOL_TAG + name + STOP_TAG;
			}
			else
			{
				return ANI_SYMBOL_TAG + name;
			}
		}
		
		public function getSymbloName(name:String):String
		{
			return name;
		}
		
		public function getSymbloAdvName(name:String):String
		{
			return name;
		}
		
		public function getMutiObject(nameList:Array, space:Number=0):DisplayObject
		{
			return null;
		}
	}
}