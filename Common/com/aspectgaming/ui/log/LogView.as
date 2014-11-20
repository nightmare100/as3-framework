package com.aspectgaming.ui.log
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.ui.ScrollBar;
	import com.aspectgaming.ui.base.BaseView;
	import com.aspectgaming.ui.event.ComponentEvent;
	import com.aspectgaming.ui.event.ScrollEvent;
	import com.aspectgaming.ui.iface.ILogView;
	import com.aspectgaming.utils.LoggerUtil;
	import com.aspectgaming.utils.StringUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	/**
	 * 简单日志面板 
	 * @author mason.li
	 * 
	 */	
	public class LogView extends BaseView implements ILogView
	{
		private const DEFAULT_SEARCH_WORD:String = "Search When you Need";
		protected var _logText:TextField;
		protected var _scrollBar:ScrollBar;
		
		protected var _isErrorOnly:Boolean;
		protected var _isScrollToBottom:Boolean = true;
		protected var _searchTxt:TextField;
		protected var _keyWord:String;
		
		public function LogView()
		{
			super();
		}
		
		override protected function initView():void
		{
			_mc = new MovieClip();
			_mc.graphics.lineStyle(2, 0xFF0000, 0.9);
			_mc.graphics.beginFill(0xFFFFFF, 0.9);
			_mc.graphics.drawRect(2, 2, LayerManager.stageWidth - 4, LayerManager.stageHeight - 4);
			_mc.graphics.endFill();
			
			_logText = new TextField();
			_logText.width = LayerManager.stageWidth - 50;
			_logText.height = LayerManager.stageHeight - 20;
			
			_logText.multiline = true;
			_logText.wordWrap = true;
			_logText.x = _logText.y = 10
			_logText.defaultTextFormat = new TextFormat(null, 12, 0, false, false, null, null, null, TextFormatAlign.LEFT);
			_mc.addChild(_logText);
			
			_scrollBar = new ScrollBar(LayerManager.stageHeight - 20);
			_scrollBar.x = _logText.x + _logText.width;
			_scrollBar.y = _logText.y;
			_mc.addChild(_scrollBar);
			_scrollBar.wheelObject = _logText;
			
			addSearchText();
			
			super.initView();
		}
		
		private function addSearchText():void
		{
			_searchTxt = new TextField();
			_searchTxt.type = TextFieldType.INPUT;
			_searchTxt.width = 130;
			_searchTxt.height = 20;
			_searchTxt.background = true;
			_searchTxt.backgroundColor = 0x000000;
			_searchTxt.border = true;
			_searchTxt.borderColor = 0xff0000;
			_searchTxt.textColor = 0xFFFFFF;
			_searchTxt.multiline = false;
			_searchTxt.x = _scrollBar.x - _searchTxt.width;
			_searchTxt.y = _scrollBar.y;
			_searchTxt.text = DEFAULT_SEARCH_WORD;
			_mc.addChild(_searchTxt);
		}
		
		override public function show(layer:DisplayObjectContainer=null, alignType:int=4):void
		{
			if (this.parent)
			{
				hide();
				LayerManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyHandler);
			}
			else
			{
				super.show(layer, alignType);
				LayerManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyHandler);
			}
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			if (_searchTxt.text == DEFAULT_SEARCH_WORD)
			{
				_searchTxt.text = "";
			}
		}
		
		override protected function addEvent():void
		{
			_scrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			addEventListener(ComponentEvent.SHOW, onShow);
			_searchTxt.addEventListener(Event.CHANGE, onChanged);
			_searchTxt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			super.addEvent();
		}
		
		override protected function removeEvent():void
		{
			_scrollBar.removeEventListener(ScrollEvent.SCROLL, onScroll);
			removeEventListener(ComponentEvent.SHOW, onShow);
			_searchTxt.removeEventListener(Event.CHANGE, onChanged);
			_searchTxt.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			super.removeEvent();
		}
		
		private function onChanged(e:Event):void
		{
			_keyWord = _searchTxt.text;
			onShow(null);
		}
		
		protected function onShow(e:ComponentEvent):void
		{
			update(LoggerUtil.logCache);
		}
		
		private function onScroll(e:ScrollEvent):void
		{
			_logText.scrollV = e.position;
		}
		
		
		public function update(arr:Array):void
		{
			if (_isErrorOnly)
			{
				arr = processErrorOnly(arr);
			}
			else if (!StringUtil.isEmptyString(_keyWord))
			{
				arr = processSearchWord(arr);
			}
			
			if (_isInit && this.parent)
			{
				var backArr:Array = checkTag(arr);
				_logText.htmlText = backArr.join("<br />");
				
				var pos:uint = _scrollBar.scrollPosition;
				_scrollBar.setScrollProperties(1, _logText.maxScrollV);
				if (_isScrollToBottom)
				{
					_scrollBar.scrollToBotton();
				}
				else
				{
					_scrollBar.scrollPosition = pos;
				}
			}
		}
		
		private function processSearchWord(arr:Array):Array
		{
			var result:Array = [];
			var inContent:Boolean;
			for (var i:uint = 0; i < arr.length; i++)
			{
				if (isInSearch(arr[i]))
				{
					inContent = !inContent;
					result.push(arr[i]);
				}
				else if (inContent)
				{
					result.push(arr[i]);
				}
			}
			return result;
		}
		
		private function isInSearch(str:String):Boolean
		{
			var result:Array = str.match(/^\[-----(.*)-----\]$/);
			if (result && result.length >= 2 && result[1].toLocaleLowerCase().indexOf(_keyWord.toLocaleLowerCase()) != -1)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function processErrorOnly(arr:Array):Array
		{
			var result:Array = [];
			var onError:Boolean;
			for (var i:uint = 0; i < arr.length; i++)
			{
				if (String(arr[i]).toLocaleLowerCase().indexOf("error") != -1)
				{
					onError = !onError;
					result.push(arr[i]);
				}
				else if (onError)
				{
					result.push(arr[i]);
				}
			}
			return result;
		}
		
		protected function checkTag(arr:Array):Array
		{
			var result:Array = arr.concat();
			for (var i:uint = 0; i < result.length; i++)
			{
				var str:String = result[i];
				if (str.indexOf("[--") == 0 && str.lastIndexOf("--]") == str.length - 3)
				{
					result[i] = "<font color='#" + LoggerUtil.TAG_COLOR_ORANGE.toString(16) + "'><b>" + result[i] + "</b></font>";
				}
				else if (str.indexOf("[") == 0 && str.lastIndexOf("]") == str.length - 1)
				{
					result[i] = "<font color='#" + LoggerUtil.TAG_COLOR_GREEN.toString(16) + "'><b>" + result[i] + "</b></font>";
				}
			}	
			
			return result;
		}
		
		protected function onKeyHandler(e:KeyboardEvent):void
		{
			if (e.ctrlKey)
			{
				switch (e.keyCode)
				{
					case Keyboard.Z:
						LoggerUtil.clear();
						break;
					case Keyboard.M:
						_isScrollToBottom = !_isScrollToBottom;
						break;
					case Keyboard.G:
						//showError
						_isErrorOnly = !_isErrorOnly;
						update(LoggerUtil.logCache);
						break;
				}
			}
		}
	}
}