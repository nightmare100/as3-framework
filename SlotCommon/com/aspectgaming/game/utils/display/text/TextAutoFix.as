package com.aspectgaming.game.utils.display.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author deve.huang
	 */
	public class TextAutoFix 
	{
		private var _txt:TextField;
		private var _minSize:int;
		private var _maxSize:int;
		private var _autoSetY:Boolean;
		
		private var _txtY:int;
		private var _txtSixeResetNum:int;
		
		private var _oldlen:int;
		private var _fixOn:Boolean;
		private var _txtH:Number;
		
		
		public function TextAutoFix(txt:TextField,minSize:int = 10,maxSize:int = -1, autoSetY:Boolean=true) 
		{
			_maxSize = maxSize;
			_minSize = minSize;
			_autoSetY = autoSetY;
			_txt = txt;
			if (_maxSize < 0) _maxSize = int(txt.getTextFormat().size);
			_txtY = txt.y;
			_txtH = txt.height;
			//_oldlen = txt.text.length;
		}
		/** 自动适应大小与对齐Y轴　*/
		public function fix():void
		{
			if (_oldlen ==  _txt.text.length) return;
			
			//trace(_oldlen , _txt.text.length);
			_txtSixeResetNum = 0;
			resetFontSize(_txt);
		}
		
		private function resetFontSize(txt:TextField):void
		{
			_txtSixeResetNum++;
			
			var str:String = txt.text;
			var font:String = txt.getTextFormat().font;
			var size:Number = Number(txt.getTextFormat().size);
			
			var tW:int 	= txt.textWidth;
			var W:int 	= txt.width;
			var len:int = txt.text.length;
			
			//var sfpx:int = txt.textWidth/len;
			//trace(_txtSixeResetNum , " >> ", size, "#", sfpx, len, "=", len * sfpx, "#", 
					//txt.textWidth,(txt.textWidth>W-10? ">" :"<") ,W)	//, txt.height,txt.textHeight);
			
			if (tW > W - 10 && _oldlen < len)
			{
				_fixOn = true;
				
				if (size <= _minSize)	size = _minSize + 1;
				txt.defaultTextFormat = new TextFormat(font,size - 1);
				txt.text = str;
				
				if (tW > W - 10 && _txtSixeResetNum < 30) resetFontSize(txt);
				else _oldlen = len;
				
				//if (_autoSetY) txt.y = _txtY + (txt.height - txt.textHeight) / 2;
			}
			else if (_fixOn && tW < W - 20  && _oldlen > len)
			{
				if (size >= _maxSize) size = _maxSize-1;
				txt.defaultTextFormat = new TextFormat(font,size + 1);
				txt.text = str;
				
				if (tW < W - 20 && _txtSixeResetNum < 20) resetFontSize(txt);
				else _oldlen = len;
				
				//if (_autoSetY) txt.y = _txtY + (txt.height - txt.textHeight) / 2;
			}
			else {
				_oldlen = len;
			}
			
			if (_autoSetY) txt.y = int(_txtY + (txt.height - txt.textHeight) / 2);
		}
		
		
	}
}