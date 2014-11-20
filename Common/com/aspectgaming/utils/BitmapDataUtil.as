package com.aspectgaming.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Bitmapdata相关辅助 
	 * @author mason.li
	 * 
	 */	
	public class BitmapDataUtil
	{
		private static const DEFAULT_RED:uint = 0XFF0000;
		private static var _lineMatrix:Matrix = new Matrix();
		/**
		 * 取线的颜色 
		 * @param o
		 * @return 
		 * 
		 */		
		public static function getLineColor(o:DisplayObject):uint
		{
			if (!o)
			{
				return DEFAULT_RED;
			}
			
			var offsetRect:Rectangle = o.getBounds(o);
			_lineMatrix.tx = 0 - offsetRect.x;
			_lineMatrix.ty = 0 - offsetRect.y;
			
			var bd:BitmapData = new BitmapData(offsetRect.width, offsetRect.height, true, 0);
			bd.draw(o, _lineMatrix);
			var rect:Rectangle = new Rectangle();
			
			
			rect.x = offsetRect.width / 2;
			rect.y = offsetRect.y;
			rect.width = 1;
			rect.height = offsetRect.height;
			var vecColor:Vector.<uint> = bd.getVector(rect);
			for each (var color:uint in vecColor)
			{
				if (color != 0)
				{
					bd.dispose();
					return color;
				}
			}
			
			rect.x = offsetRect.x;
			rect.y = offsetRect.height / 2;
			rect.width = offsetRect.width;
			rect.height = 1;
			
			vecColor = bd.getVector(rect);
			for each (color in vecColor)
			{
				if (color != 0)
				{
					bd.dispose();
					return color;
				}
			}
			
			
			
			bd.dispose();
			return 0;
		}
		
		/**
		 * 根据显示矩形 定位 获取指定 显示对象 位图对象 
		 * @param display
		 * @param rect
		 * @return 
		 * 
		 */		
		public static function getBitmapDataFromDisplay(display:DisplayObject, rect:Rectangle):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			var matrix:Matrix = new Matrix();
			matrix.tx = -rect.x;
			matrix.ty = -rect.y;
			bitmapData.draw(display, matrix);
			
			return bitmapData;
		}
	}
}