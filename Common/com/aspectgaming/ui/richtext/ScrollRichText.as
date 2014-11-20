package com.aspectgaming.ui.richtext
{
	import com.aspectgaming.ui.ScrollBar;
	import com.aspectgaming.ui.event.RichTextEvent;
	import com.aspectgaming.ui.event.ScrollEvent;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 带滚动条的 RICHTEXT 
	 * @author mason.li
	 * 
	 */	
	public class ScrollRichText extends Sprite
	{
		private var _scrollBar:ScrollBar;
		private var _richText:RichText;
		
		private var _pageSize:uint;
		
		public function ScrollRichText(richText:RichText, pageSize:Number, isAutoScroll:Boolean = true, skin:MovieClip = null)
		{
			_pageSize = pageSize;
			_richText = richText;
			_scrollBar = new ScrollBar(_richText.height, skin);
			_scrollBar.x = _richText.x + _richText.width;
			_richText.isScrollAuto = isAutoScroll;
			
			_scrollBar.pageSize = pageSize;
			_scrollBar.wheelObject = _richText.sourceText;
			addChild(_scrollBar);
			addChild(_richText);
			
			addEvent();
		}
		
		public function set autoScroll(value:Boolean):void
		{
			_richText.isScrollAuto = value;
		}
		
		public function get richText():RichText
		{
			return _richText;
		}

		private function addEvent():void
		{
			_scrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			_richText.addEventListener(RichTextEvent.TEXT_CHANGED, onTextChanged);
		}
		
		private function onTextChanged(e:RichTextEvent):void
		{
			_scrollBar.maxScrollPosition = _pageSize + _richText.sourceText.maxScrollV - 1;
			_scrollBar.scrollPosition = _pageSize + _richText.sourceText.maxScrollV - 1;
		}
		
		private function onScroll(e:ScrollEvent):void
		{
			_richText.sourceText.scrollV = e.position;
		}
		
		private function removeEvent():void
		{
			_scrollBar.removeEventListener(ScrollEvent.SCROLL, onScroll);
			_richText.removeEventListener(RichTextEvent.TEXT_CHANGED, onTextChanged);
		}
		
		public function dispose():void
		{
			removeEvent();
			DisplayUtil.removeFromParent(this);
			_scrollBar.dispose();
			_richText.dispose();
			_scrollBar = null;
			_richText = null;
		}
	}
}