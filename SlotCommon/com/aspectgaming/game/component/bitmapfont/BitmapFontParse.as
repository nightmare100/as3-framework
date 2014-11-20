package com.aspectgaming.game.component.bitmapfont
{
	import com.aspectgaming.ui.iface.IAssetLibrary;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 位图字体 
	 * @author mason.li
	 * 
	 */	
	public class BitmapFontParse implements IAssetLibrary
	{
		private var _sourceBitmap:BitmapData;
		private var _bitmapConfig:Dictionary;
		private var _extraDic:Dictionary;
		private var _matrix:Matrix;
		public function BitmapFontParse(bd:BitmapData, dic:Dictionary)
		{
			init(bd, dic);
		}
		
		public function processStopAnimation(mc:DisplayObject=null, info:*=null):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		
		
		public function set extraDic(dic:Dictionary):void
		{
			_extraDic = dic;
		}
		
		public function get matrix():Matrix
		{
			if (!_matrix)
			{
				_matrix = new Matrix();
			}
			
			return _matrix;
		}
		
		public function getSymbloName(name:String):String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		

		/**
		 * 初始化位图信息 
		 * @param bd 	原始
		 * @param dic	对应 key <=> rect 的string 节省内存
		 * 
		 */		
		public function init(bd:BitmapData, dic:Dictionary):void
		{
			_sourceBitmap = bd;
			_bitmapConfig = dic;
		}
		
		public function getAniObject(name:String, isStop:Boolean = false,index:int=0):MovieClip
		{
			return null;
		}
		
		public function getDisplayObject(name:String):DisplayObject
		{
			var bd:BitmapData;
			if (_extraDic && _extraDic[name])
			{
				var bmp:Bitmap = _extraDic[name]
				bd = new BitmapData(bmp.width,bmp.height, true, 0);
				bd.draw(bmp);
				var extraBM:Bitmap = new Bitmap(bd)
				extraBM.smoothing=true
				
				return extraBM;
			}
			if (_bitmapConfig[name])
			{
				var rect:Rectangle = stringToRect(_bitmapConfig[name]);
				var result:Bitmap = new Bitmap();
				bd = new BitmapData(rect.width, rect.height, true, 0);
				matrix.tx = 0 - rect.x;
				matrix.ty = 0 - rect.y;
				bd.draw(_sourceBitmap, matrix);
				result.bitmapData = bd;
				result.smoothing = true;
				
				return result;
			}
			return null;
		}
		
		public function getMutiObject(nameList:Array, space:Number = 0):DisplayObject
		{
			var lastObj:DisplayObject;
			var spr:Sprite = new Sprite();
			for (var i:uint = 0; i < nameList.length; i++)
			{
				var obj:DisplayObject = getDisplayObject(nameList[i]);
				obj.x = lastObj ? (lastObj.x + lastObj.width) : 0 + (i > 0 ? space : 0);
				lastObj = obj;
				spr.addChild(obj);
			}
			var bd:BitmapData = new BitmapData(spr.width, spr.height, true, 0);
			bd.draw(spr);
			return new Bitmap(bd);
		}
		
		public function getSymbloAdvName(name:String):String
		{
			return null;
		}
		
		
		
		private function stringToRect(str:String):Rectangle
		{
			var arr:Array = str.split(",");
			return new Rectangle(arr[0], arr[1], arr[2], arr[3]);
		}
		
		public function dispose():void
		{
			_bitmapConfig = null;
			_matrix = null;
			_extraDic = null;
			_sourceBitmap.dispose();
			_sourceBitmap = null;
		}
	}
}