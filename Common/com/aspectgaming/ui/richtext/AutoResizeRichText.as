package com.aspectgaming.ui.richtext
{
	import com.aspectgaming.ui.iface.IAssetLibrary;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * 自动调整大小的 单行RICH 文本 
	 * @author mason.li
	 * 
	 */	
	public class AutoResizeRichText extends Sprite
	{
		private var _bitmap:Bitmap;
		private var _richText:RichText;
		
		private var _matrix:Matrix;
		
		public function AutoResizeRichText(width:Number, height:Number, assetLibrary:IAssetLibrary, type:String="dynamic", size:Number=14, isBold:Boolean=true, color:uint=0xFFFFFF, align:String="center", font:String="Arial", maxLine:uint=uint.MAX_VALUE, leading:Number = - 99)
		{
			_richText = new RichText(width, height, assetLibrary, type, size, isBold, color, align, false, font, maxLine, leading);
			_richText.scrollRect = null;
			_richText.sourceText.width *= 2;
			
			_bitmap = new Bitmap();
			_bitmap.smoothing = true;
			addChild(_bitmap);
		}
		
		public function set text(value:String):void
		{
			_richText.text = value;
			var isOverLap:Boolean = _richText.sourceText.textWidth > _richText.defaultWidth;
//			_richText.sourceText.width = isOverLap ? _richText.sourceText.textWidth + 10 : _richText.defaultWidth;
			
			if (_bitmap.bitmapData)
			{
				_bitmap.bitmapData.dispose();
			}
			
			var scale:Number = isOverLap ? _richText.defaultWidth / _richText.sourceText.textWidth : 1;
			_bitmap.bitmapData = drawBitmapData(scale);
			if (!isOverLap)
			{
				_bitmap.x = (_richText.defaultWidth - _richText.sourceText.textWidth) / 2;
			}
			else
			{
				_bitmap.x = 0;
			}
		}
		
		private function drawBitmapData(scale:Number):BitmapData
		{
			var bd:BitmapData = new BitmapData(_richText.width, _richText.height, true, 0);
			bd.draw(_richText, getMatrix(scale));
			
			return bd;
		}
		
		private function getMatrix(scale:Number):Matrix
		{
			if (!_matrix)
			{
				_matrix = new Matrix();
			}
			
			_matrix.a = scale;
			_matrix.d = scale;
			
			return _matrix;
		}
		
		public function dispose():void
		{
			_richText.dispose();
			_richText = null;
			
			DisplayUtil.removeFromParent(_bitmap);
			_bitmap = null;
			
			_matrix = null;
		}
		
	}
}