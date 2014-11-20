package com.aspectgaming.ui
{
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.ui.event.ScrollEvent;
	import com.aspectgaming.ui.iface.IDataCell;
	import com.aspectgaming.ui.iface.IDataComponent;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	[Event(name="scrollDataSelected", type = "com.aspectgaming.ui.event.ScrollEvent")]
	[Event(name="scrollDataChanged", type = "com.aspectgaming.ui.event.ScrollEvent")]
	/**
	 * 带有滚动条的界面 
	 * @author mason.li
	 * 
	 */	
	public class ScrollBox extends BaseComponent implements IDataComponent
	{
		protected var _useScollBar:Boolean;
		
		protected var _magrinX:Number = 4;
		protected var _magrinY:Number = 0;
		protected var _hSpace:int = 10;
		
		protected var _scrollBar:ScrollBar;
		protected var _cellClass:Class;
		protected var _pageSize:int;
		protected var _cellFrame:uint;
		protected var _scrollBarSkin:MovieClip;
		
		protected var _cellVec:Vector.<IDataCell>;
		
		public function ScrollBox(mc:MovieClip, cellClass:Class = null, pageSize:int = 8, frame:uint = 1, scrollBarSkin:MovieClip = null, useScrollBar:Boolean = true)
		{
			_cellClass = cellClass;
			_pageSize = pageSize;
			_cellFrame = frame;
			_scrollBarSkin = scrollBarSkin;
			_useScollBar = useScrollBar;
			super(mc);
		}
		
		/**
		 * 设置边距及间隔 
		 * @param marginX
		 * @param marginY
		 * @param _hSpace
		 * 
		 */		
		public function setMarginSpace(marginX:Number, marginY:Number, hSpace:Number):void
		{
			_magrinX = marginX;
			_magrinY = marginY;
			_hSpace = hSpace;
		}
		
		override protected function init():void
		{
			if (_useScollBar)
			{
				_scrollBar = new ScrollBar(_viewComponent.height, _scrollBarSkin);
				_scrollBar.x = _viewComponent.width - _scrollBar.width;
				_viewComponent.addChild(_scrollBar);
				_scrollBar.pageSize = _pageSize;
				_scrollBar.wheelObject = _viewComponent;
			}
			
			inputCell();
			
			super.init();
		}
		
		protected function inputCell():void
		{
			if (!_cellClass)
			{
				return;
			}
			
			_cellVec = new Vector.<IDataCell>(_pageSize);
			for (var i:uint = 0 ; i < _pageSize; i++)
			{
				_cellVec[i] = new _cellClass();
				_cellVec[i].addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		override protected function removeEvent():void
		{
			if (_useScollBar)
			{
				_scrollBar.removeEventListener(ScrollEvent.SCROLL, onScroll);
			}
			super.removeEvent();
		}
		
		override protected function addEvent():void
		{
			if (_useScollBar)
			{
				_scrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			}
			super.addEvent();
		}
		
		protected function onClick(e:MouseEvent):void
		{
			var target:IDataCell = e.currentTarget as IDataCell;
			var clickTarget:String = e.target.name;
			var evt:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL_DATA_SELECTED, false, false, 0, target);
			evt.data = target.data;
			evt.targetName = clickTarget;
			dispatchEvent(evt);
		}
		
		protected function onScroll(e:ScrollEvent):void
		{
			setData(false);
		}
		
		override public function get data():*
		{
			return super.data;
		}
		
		override public function set data(value:*):void
		{
			super.data = value == null ? [] : value;
			setData();
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_DATA_CHANGED));
		}
		
		public function get selectedData():*
		{
			return null;
		}
		
		protected function setData(updateScrollBar:Boolean = true):void
		{
			var array:Array = _data as Array;
			if (updateScrollBar && _useScollBar)
			{
				_scrollBar.maxScrollPosition = array.length;
			}
			
			var dataIdx:uint = _useScollBar ? _scrollBar.scrollPosition : 0;
			var maxPosition:uint = _useScollBar ? _scrollBar.maxScrollPosition : array.length;
			for (var i:uint = 0; i < _cellVec.length; i++)
			{
				if (dataIdx < maxPosition && maxPosition != 0)
				{
					_cellVec[i].data = array[dataIdx];
					_cellVec[i].index = dataIdx;
					_cellVec[i].setFrame(_cellFrame);
					_cellVec[i].show(_viewComponent, _magrinX , _magrinY + i * (_cellVec[i].height + _hSpace));
					dataIdx++;
				}
				else
				{
					_cellVec[i].remove();
				}
			}
			DisplayUtil.bringToTop(_scrollBar);
		}
		
		/**
		 * 重置CELL 默认帧 
		 * 
		 */		
		public function resetCellFrame():void
		{
			for each (var cell:IDataCell in _cellVec)
			{
				cell.setFrame(_cellFrame);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if (_useScollBar)
			{
				_scrollBar.dispose();
				_scrollBar = null;
			}
			for each (var cell:IDataCell in _cellVec)
			{
				cell.removeEventListener(MouseEvent.CLICK, onClick);
				cell.dispose();
			}
			_cellVec = null;
		}
		
	}
}