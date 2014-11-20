package com.aspectgaming.ui
{
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.ui.constant.SplitScrollingType;
	import com.aspectgaming.ui.event.SplitPageEvent;
	import com.aspectgaming.utils.FiltersUtil;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 简单分页 
	 * @author mason.li
	 * 
	 */	
	
	[Event(name="onPageChanged", type="com.aspectgaming.ui.event.SplitPageEvent")]
	public class SimpleSplitPage extends BaseComponent
	{
		protected var _currentPage:uint = 1;
		protected var _totalPage:uint = 1;
		protected var _previewPage:uint = 1;
		
		protected var _btnLeft:SimpleButton;
		protected var _btnRight:SimpleButton;
		private var _btnLeftDir:SimpleButton;
		private var _btnRightDir:SimpleButton;
		
		private var _txtSplite:TextField;
		
		public function SimpleSplitPage(view:MovieClip)
		{
			super(view);
		}
		
		public function get previewPage():uint
		{
			return _previewPage;
		}

		public function get totalPage():uint
		{
			return _totalPage;
		}

		public function set totalPage(value:uint):void
		{
			_totalPage = value;
			_currentPage = 1;
			checkButton();
		}
		
		public function setTotalPageWithOutReset(value:uint):void
		{
			_currentPage = _currentPage == totalPage ? value : _currentPage;
			_totalPage = value;
			_currentPage = _currentPage > totalPage ? totalPage : _currentPage;
			checkButton();
		}

		public function get currentPage():uint
		{
			return _currentPage;
		}

		public function set currentPage(value:uint):void
		{
			_currentPage = value;
			checkButton();
		}
		
		public function get scrollType():String
		{
			if (_currentPage > _previewPage)
			{
				return SplitScrollingType.SCROLL_RIGHT;
			}
			else if (_currentPage < _previewPage)
			{
				return SplitScrollingType.SCROLL_LEFT;
			}
			else
			{
				return SplitScrollingType.SCROLL_INIT;
			}
		}

		override protected function init():void
		{
			_btnLeft = _viewComponent["btn_left"];
			_btnRight = _viewComponent["btn_right"];
			_btnLeftDir = _viewComponent["btn_left_dir"];
			_btnRightDir = _viewComponent["btn_right_dir"];
			
			_txtSplite = _viewComponent["txt_page"];
			
			addEvent();
		}
		
		protected function onPageChangeClick(e:MouseEvent):void
		{
			var tar:SimpleButton = e.currentTarget as SimpleButton;
			var isPageChanged:Boolean = false;
			_previewPage = _currentPage;
			if (tar == _btnLeft || tar == _btnRight)
			{
				if (tar == _btnLeft && _currentPage > 1)
				{
					_currentPage--;
					isPageChanged = true;
				}
				else if (tar == _btnRight && _currentPage < _totalPage)
				{
					_currentPage++;
					isPageChanged = true;
				}
			}
			else
			{
				if (tar == _btnLeftDir && _currentPage > 1)
				{
					_currentPage = 1;
					isPageChanged = true;
				}
				else if (tar == _btnRightDir && _currentPage < _totalPage)
				{
					_currentPage = _totalPage;
					isPageChanged = true;
				}
			}
			
			checkButton();
			if (isPageChanged)
			{
				dispatchEvent(new SplitPageEvent(SplitPageEvent.ON_PAGE_CHANGED));
			}
			
		}
		
		public function checkButton():void
		{
			if (_currentPage <= 1)
			{
				setButton(_btnLeft);
				setButton(_btnLeftDir);
			}
			else
			{
				setButton(_btnLeft, true);
				setButton(_btnLeftDir, true);
			}
			
			if (_currentPage >= _totalPage)
			{
				setButton(_btnRight);
				setButton(_btnRightDir);
			}
			else
			{
				setButton(_btnRight, true);
				setButton(_btnRightDir, true);
			}
			
			if (_txtSplite)
			{
				_txtSplite.text = _currentPage + "/" + _totalPage;
			}
		}
		
		public function disabledButton():void
		{
			setButton(_btnLeft, false);
			setButton(_btnLeftDir, false);
			setButton(_btnRight, false);
			setButton(_btnRightDir, false);
		}
		
		protected function setButton(btn:SimpleButton, isEnabled:Boolean = false):void
		{
			if (btn)
			{
				btn.enabled = isEnabled;
				btn.mouseEnabled = isEnabled;
				btn.filters = isEnabled?[]:[FiltersUtil.GRAY_FILTER];
				btn.filters = isEnabled?[]:[FiltersUtil.DARK_FILTER];
			}
		}
		
		override protected function addEvent():void
		{
			_btnLeft.addEventListener(MouseEvent.CLICK, onPageChangeClick);
			_btnRight.addEventListener(MouseEvent.CLICK, onPageChangeClick);
			
			if (_btnLeftDir)
			{
				_btnLeftDir.addEventListener(MouseEvent.CLICK, onPageChangeClick);
				_btnRightDir.addEventListener(MouseEvent.CLICK, onPageChangeClick);
			}
		}
		
		override protected function removeEvent():void
		{
			_btnLeft.removeEventListener(MouseEvent.CLICK, onPageChangeClick);
			_btnRight.removeEventListener(MouseEvent.CLICK, onPageChangeClick);
			
			if (_btnLeftDir)
			{
				_btnLeftDir.removeEventListener(MouseEvent.CLICK, onPageChangeClick);
				_btnRightDir.removeEventListener(MouseEvent.CLICK, onPageChangeClick);
			}
		}
	}
}