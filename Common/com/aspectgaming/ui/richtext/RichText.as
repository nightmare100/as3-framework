package com.aspectgaming.ui.richtext
{
	
	import com.aspectgaming.ui.event.RichTextEvent;
	import com.aspectgaming.ui.iface.IAssetLibrary;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.StringUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	
	[Event(name="enterInput", type="com.aspectgaming.ui.event.RichTextEvent")]
	[Event(name="textChanged", type="com.aspectgaming.ui.event.RichTextEvent")]
	/**
	 * 图文混排 
	 * @author mason.li
	 * 
	 */	
	public class RichText extends Sprite
	{
		private const DEFAULT_LEADING:uint = 5;
		
		/**
		 * 表情空格符 补差间距 （一个空格的距离）
		 */		
		private const SPACE_FIX:int = -2;
		private var _textParse:TextParse;
		private var _sourceText:TextField;
		private var _size:Number;
		private var _isBold:Boolean;
		private var _fontName:String;
		private var _color:uint;
		private var _align:String;
		
		private var _scrollH:int;
		
		private var _selStartIndex:uint;
		private var _selEndIndex:uint;
		
		/**
		 * 是否为多字输入 
		 */		
		private var _isContinueInput:Boolean;
		
		/**
		 * 是否为多行 
		 */		
		private var _multiline:Boolean;
		
		/**
		 * 多行文本中 允许的最大行数 
		 */		
		private var _maxLine:uint;
		
		private var _isScrollAuto:Boolean;
		
		protected var _width:Number;
		protected var _height:Number;
		protected var _scrollRect:Rectangle;
		
		protected var _leading:Number;
		
		public function RichText(width:Number, height:Number, assetLibrary:IAssetLibrary, type:String = "dynamic", size:Number = 14, isBold:Boolean = true, color:uint = 0xFFFFFF, align:String = "center", isMutip:Boolean = false,font:String = "Arial", maxLine:uint = uint.MAX_VALUE, leading:Number = -99)
		{
			_size = size;
			_isBold = isBold;
			_color = color;
			_align = align;
			_multiline = isMutip;
			_maxLine = maxLine;
			_fontName = font;
			_width = width;
			_height = height;
			
			_leading = leading == -99 ? DEFAULT_LEADING : _leading;
			
			init(width, height, type);
			_textParse = new TextParse(assetLibrary, this);
		}
		
		public function get defaultWidth():Number
		{
			return _width;
		}
		
		public function get defaultHeight():Number
		{
			return _height;
		}
		
		/**
		 * 自动滚动 
		 */
		public function set isScrollAuto(value:Boolean):void
		{
			_isScrollAuto = value;
		}

		public function get sourceText():TextField
		{
			return _sourceText;
		}
		
		public function get sourceTextVec():Vector.<String>
		{
			return _textParse.sourceTextVec;
		}

		public function get scrollH():int
		{
			return _sourceText.scrollH;
		}
		
		public function focus():void
		{
			stage.focus = _sourceText;
		}

		/**
		 * 设置图文文本 
		 * @param value
		 * 
		 */		
		public function set text(value:String):void
		{
			clear();
			_textParse.parseText(value);
			renderText();
			renderEmu();
		}
		
		
		/**
		 * 添加数组文本 
		 * @param vec
		 * 
		 */		
		public function appendVec(vec:Vector.<String>):void
		{
			for (var i:uint = 0 ; i < vec.length; i++)
			{
				appendText(vec[i], false);
			}
			
			dispatchEvent(new RichTextEvent(RichTextEvent.TEXT_CHANGED));
		}
		
		/**
		 * 添加文本 带表情解析
		 * @param str
		 * 
		 */		
		public function appendText(str:String, needDispatch:Boolean = true):void
		{
			if (_multiline && _textParse.sourceTextVec.length >= _maxLine)
			{
				reRenderAll(_textParse.shiftText());
			}
			
			_textParse.appendText(str);
			renderAddedText();
			renderAddedEmu();
			if (_isScrollAuto)
			{
				_sourceText.scrollV = _sourceText.maxScrollV;
			}
			
			if (needDispatch)
			{
				dispatchEvent(new RichTextEvent(RichTextEvent.TEXT_CHANGED));
			}
		}
		
		/**
		 * 添加纯文本(性能高) 
		 * @param str
		 * 
		 */		
		public function appendTextOnly(str:String, needDispatch:Boolean = true):void
		{
			_textParse.appendTextOnly(str);
			renderAddedText();
			if (_isScrollAuto)
			{
				_sourceText.scrollV = _sourceText.maxScrollV;
			}
			
			if (needDispatch)
			{
				dispatchEvent(new RichTextEvent(RichTextEvent.TEXT_CHANGED));
			}
		}
		

		/**
		 * 文本框禁止输入
		 */
		override public function set mouseEnabled(enabled:Boolean):void{
			super.mouseEnabled=enabled;
			_sourceText.selectable=enabled;
			if(enabled){
				_sourceText.type=TextFieldType.INPUT;
			}else{
				_sourceText.type=TextFieldType.DYNAMIC;
			}
		}
		
		
		
		/**
		 * 重新渲染所有文本 和 表情 
		 * 
		 */		
		private function reRenderAll(deleteVec:Vector.<EmoInfo>):void
		{
			for each (var info:EmoInfo in deleteVec)
			{
				DisplayUtil.removeFromParent(info.displayObject);
			}
			
			clearAllFormat();
			_sourceText.htmlText = _textParse.textList.join("\n");
			_sourceText.scrollV = _sourceText.maxScrollV;
			var emVec:Vector.<EmoInfo> = _textParse.emoVec;
			
			for (var i:uint = 0 ; i < emVec.length; i++)
			{
				processFormat(emVec[i]);
				processEmo(emVec[i]);
			}
		}
		
		/**
		 * 插入表情 
		 * 
		 */		
		public function insertEmo(em:String):void
		{
			_textParse.insertEmo(em, _sourceText.selectionBeginIndex);
			renderText();
			renderEmu();
		}
		
		private function clearAllFormat():void
		{
			var format:TextFormat;
			for (var i:uint = 0; i < _sourceText.text.length; i++)
			{
				format = _sourceText.getTextFormat(i, i + 1);
				format.letterSpacing = 0;
				_sourceText.setTextFormat(format, i, i + 1);
			}
		}
		
		// =================== ADD =====================
		
		/**
		 * 渲染新加的文本 
		 * 
		 */		
		private function renderAddedText():void
		{
			_sourceText.htmlText += _textParse.currentProcessText + "\n";
			var emVec:Vector.<EmoInfo> = _textParse.currentLineEmu;
			for (var i:uint = 0 ; i < emVec.length; i++)
			{
				processFormat(emVec[i]);
			}
		}
		
		private function renderAddedEmu():void
		{
			var emVec:Vector.<EmoInfo> = _textParse.currentLineEmu;
			
			for (var i:uint = 0 ; i < emVec.length; i++)
			{
				processEmo(emVec[i]);
			}
		}
		
		// ====================== override ==============================
		/**
		 * 重新渲染文本 
		 * 
		 */		
		private function renderText():void
		{
			_sourceText.htmlText = _textParse.currentProcessText;
			clearAllFormat();
			var emVec:Vector.<EmoInfo> = _textParse.emoVec;
			for (var i:uint = 0 ; i < emVec.length; i++)
			{
				processFormat(emVec[i]);
			}
		}
		
		private function renderEmu():void
		{
			var emVec:Vector.<EmoInfo> = _textParse.emoVec;
			
			for (var i:uint = 0 ; i < emVec.length; i++)
			{
				processEmo(emVec[i]);
			}
		}
		
		public function processFormat(info:EmoInfo):void
		{
			var format:TextFormat = _sourceText.getTextFormat(info.hindex, info.hindex + 1);
			
			format.letterSpacing  = info.displayObject.width + SPACE_FIX;
			
			_sourceText.setTextFormat(format, info.hindex, info.hindex + 1);
		}
		
		public function clearFormat(st:uint, ed:uint):void
		{
			var format:TextFormat = _sourceText.getTextFormat(st, ed);
			format.letterSpacing = 0;
			_sourceText.setTextFormat(format, st, ed);
		}
		
		private function processEmo(info:EmoInfo):void
		{
			var rect:Rectangle = _sourceText.getCharBoundaries(info.hindex);
			if (rect)
			{
				info.displayObject.x = rect.x - _sourceText.scrollH;
				info.displayObject.visible = true;
			}
			else
			{
				info.displayObject.visible = false;
				return;
			}
			
			if (_multiline)
			{
				info.displayObject.y = rect.y;
			}
			else
			{
				info.displayObject.y = (_sourceText.height - _sourceText.textHeight) / 2 - (info.displayObject.height - _sourceText.textHeight) / 2;
			}
			
			addChild(info.displayObject);
		}
		
		protected function init(mwidth:Number, mheight:Number, type:String):void
		{
			_sourceText = new TextField();
			_sourceText.type = type;
			_sourceText.selectable = false;
			_sourceText.multiline = _multiline;
			if (_multiline)
			{
				_sourceText.wordWrap = true;
			}
			_sourceText.width = mwidth;
			_sourceText.height = mheight;
			_sourceText.defaultTextFormat = getTextFormat();

			
			addChild(_sourceText);
			if (type == TextFieldType.INPUT)
			{
				_sourceText.selectable = true;
				_sourceText.addEventListener(KeyboardEvent.KEY_DOWN, onTextInput);
				_sourceText.addEventListener(Event.SCROLL, onTextScroll);
				_sourceText.addEventListener(Event.CHANGE, onTextChanged);
			}
			else
			{
				if (_multiline)
				{
					_sourceText.addEventListener(Event.SCROLL, onVerScrolling);
				}
			}
			
			_sourceText.htmlText = " ";
			if (!_multiline)
			{
				_sourceText.y = ( mheight - _sourceText.textHeight ) / 2;
			}
			
			_sourceText.htmlText = "";
			
			
			_scrollRect = new Rectangle(0, 0, this.width + 2, this.height + 2);
			this.scrollRect = _scrollRect;
		}
		
		/**
		 * 记录选区索引 
		 * @param e
		 * 
		 */		
		private function onTextInput(e:KeyboardEvent):void
		{
			_isContinueInput = false;
			_selStartIndex = _sourceText.selectionBeginIndex;
			_selEndIndex   = _sourceText.selectionEndIndex;
			
			if (e.keyCode == Keyboard.ENTER)
			{
				dispatchEvent(new RichTextEvent(RichTextEvent.ENTER_INPUT, null, _textParse.sourceTextVec));
			}
		}
		
		/**
		 * 文本改变 
		 * @param e
		 * 
		 */		
		private function onTextChanged(e:Event):void
		{
			if (_isContinueInput)
			{
				_selStartIndex += 1;
				_selEndIndex = _selStartIndex;
			}
			_textParse.updateSource(_sourceText.text, _selStartIndex, _selEndIndex);
			renderEmu();
			_isContinueInput = true;
			
			dispatchEvent(new RichTextEvent(RichTextEvent.TEXT_CHANGED));
		}
		
		private function onVerScrolling(e:Event):void
		{
			renderEmu();
		}
		
		private function onTextScroll(e:Event):void
		{
			if (_scrollH != _sourceText.scrollH)
			{
				_scrollH = _sourceText.scrollH;
				renderEmu();
			}
			
		}
		
		private function getTextFormat():TextFormat
		{
			var tformat:TextFormat = new TextFormat();
			tformat.font = _fontName;
			tformat.bold = _isBold;
			tformat.size = _size;
			tformat.color = _color;
			tformat.align = _align;
			tformat.leading = _leading;
			
			return tformat;
		}
		
		public function get hasText():Boolean
		{
			return (_sourceText.htmlText != "" || _textParse.emoVec.length > 0 ) && StringUtil.trim( _sourceText.text).length>0 ;
		}
		
		public function clear():void
		{
			_textParse.clear();
			_sourceText.htmlText = "";
		}
		
		public function dispose():void
		{
			_sourceText.removeEventListener(KeyboardEvent.KEY_DOWN, onTextInput);
			_sourceText.removeEventListener(Event.CHANGE, onTextChanged);
			_sourceText.removeEventListener(Event.SCROLL, onTextScroll);
			_sourceText.removeEventListener(Event.SCROLL, onVerScrolling);
			DisplayUtil.removeFromParent(this);
			DisplayUtil.removeFromParent(_sourceText);
			_sourceText = null;
			_textParse.clear();
			_textParse = null;
		}
	}
}