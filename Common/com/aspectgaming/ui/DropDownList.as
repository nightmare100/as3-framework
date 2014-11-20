package com.aspectgaming.ui
{
	
	import com.aspectgaming.ui.base.BaseView;
	import com.aspectgaming.ui.event.DropDownListEvent;
	import com.aspectgaming.ui.event.ScrollEvent;
	import com.aspectgaming.ui.iface.IDropDownCell;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.DomainUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * 下拉列表 
	 * @author mason.li
	 * 
	 */	
	public class DropDownList extends BaseView
	{
		public static const DROP_DOWN_SCROLL_DEFAULT:String = "Scroll_dropDownDefault";
		public static const DROP_DOWN_BG_DEFAULT:String = "Scroll_BgDefault";
		
		private var _bg:Sprite;
		private var _contentWidth:Number;
		private var _contentHeight:Number;
		private var _contentLayer:Sprite;
		
		protected var _pageSize:int;
		protected var _scrollBar:ScrollBar;
		protected var _scrollBarSkin:MovieClip;
		
		
		
		protected var _useScollBar:Boolean;
		
		protected var _magrinH:Number = 5;
		protected var _magrinV:Number = 3;
		protected var _hSpace:int = 0;
		
		private var _cellData:Array;
		protected var _cellVec:Vector.<IDropDownCell>;
		protected var _cellCls:Class;
		
		protected var _hasTrack:Boolean;
		
		/**
		 *  
		 * @param width 宽
		 * @param height 高
		 * @param cellClass 元件类型
		 * @param pageSize 每页显示数量
		 * @param scrollBarSkin 滚动条皮肤
		 * @param bg 背景皮肤
		 * 
		 */		
		public function DropDownList(width:Number, height:Number, cellClass:Class, pageSize:int = 8, scrollBarSkin:String = null, bg:String = null, hasTrack:Boolean = true)
		{
			_hasTrack = hasTrack;
			_bg = bg ? DomainUtil.getMovieClip(bg) : DomainUtil.getMovieClip(DROP_DOWN_BG_DEFAULT);
			_contentWidth = width;
			_contentHeight = height;
			
			_pageSize = pageSize;
			_scrollBarSkin = scrollBarSkin ? DomainUtil.getMovieClip(scrollBarSkin) : DomainUtil.getMovieClip(DROP_DOWN_SCROLL_DEFAULT);	
			_cellCls = cellClass;
		}
		
		override protected function initView():void
		{
			_bg.width = _contentWidth;
			_bg.height = _contentHeight;
			
			addChild(_bg);
			_contentLayer = new Sprite();
			_contentLayer.x = _magrinH;
			_contentLayer.y = _magrinV;
			
			addChild(_contentLayer);
			
			
			_scrollBar = new ScrollBar(_contentHeight - _magrinV * 2, _scrollBarSkin, false, _hasTrack);
			_scrollBar.x = _contentWidth - _scrollBar.width;
			addChild(_scrollBar);
			_scrollBar.pageSize = _pageSize;
			_scrollBar.wheelObject = _contentLayer;
			_cellVec = new Vector.<IDropDownCell>();
			pageSize = _pageSize;
			super.initView();
		}

		
		/**
		 * 设置边距及间隔 
		 * @param marginH
		 * @param marginV
		 * @param _hSpace
		 * 
		 */		
		public function setMarginSpace(marginH:Number, marginV:Number, hSpace:Number):void
		{
			_magrinH = marginH;
			_magrinV = marginV;
			_hSpace = hSpace;
		}

		/**
		 * 改变组件大小 
		 * @param width
		 * @param height
		 * 
		 */		
		public function setContentSize(width:Number, height:Number, size:int):void
		{
			_contentWidth = width;
			_contentHeight = height;
			_bg.width = _contentWidth;
			_bg.height = _contentHeight;
			pageSize = size;
			renderItem(true);
		}
		
		public function set pageSize(value:int):void
		{
			_pageSize = value;
			if (_cellVec.length < _pageSize)
			{
				var addNum:Number = _pageSize - _cellVec.length;
				for (var i:uint = 0; i < addNum; i++)
				{
					var cell:IDropDownCell = new _cellCls();
					cell.addEventListener(DropDownListEvent.DROP_DOWN_CELL_CLICK, onMouseEvent);
					cell.addEventListener(DropDownListEvent.DROP_DOWN_CELL_OUT, onMouseEvent);
					cell.addEventListener(DropDownListEvent.DROP_DOWN_CELL_OVER, onMouseEvent);
					_cellVec.push(cell);
				}
			}
			_scrollBar.pageSize = _pageSize;
			
		}
		
		override protected function addEvent():void
		{
			_scrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			super.addEvent();
		}
		
		
		override protected function removeEvent():void
		{
			_scrollBar.removeEventListener(ScrollEvent.SCROLL, onScroll);
			
			for each (var cell:IDropDownCell in _cellVec)
			{
				cell.removeEventListener(DropDownListEvent.DROP_DOWN_CELL_CLICK, onMouseEvent);
				cell.removeEventListener(DropDownListEvent.DROP_DOWN_CELL_OUT, onMouseEvent);
				cell.removeEventListener(DropDownListEvent.DROP_DOWN_CELL_OVER, onMouseEvent);
			}
			super.removeEvent();
		}
		
		private function onMouseEvent(e:DropDownListEvent):void
		{
			var cell:IDropDownCell = e.currentTarget as IDropDownCell;
			if (e.type == DropDownListEvent.DROP_DOWN_CELL_OVER)
			{
				cell.onOver();
			}
			else if (e.type == DropDownListEvent.DROP_DOWN_CELL_OUT)
			{
				cell.onOut();
			}
			else
			{
				cell.onClick();
				dispatchEvent(new DropDownListEvent(DropDownListEvent.SCROLL_MENU_DATA_SELECTED, false, false, cell.index, cell.data));
			}
		}
		
		/**
		 *滚动 
		 * @param e
		 * 
		 */		
		protected function onScroll(e:ScrollEvent):void
		{
			renderItem(false);
		}
		
		public function set data(value:Array):void
		{
			_cellData = value == null ? [] : value;
			renderItem(true);
		}
		
		/**
		 *  填充滚动 cell 数据
		 * @param updateScrollBar
		 * 
		 */		
		protected function renderItem(updateScrollBar:Boolean = true):void
		{
			if (updateScrollBar)
			{
				_scrollBar.maxScrollPosition = _cellData.length;
			}
			
			var _dataIdx:uint = _scrollBar.scrollPosition;
			
			var _maxPosition:uint = (_dataIdx + _pageSize > _scrollBar.maxScrollPosition) ? _scrollBar.maxScrollPosition : (_dataIdx + _pageSize) ;
			
			for (var i:uint = 0; i < _cellVec.length; i++)
			{
				if (_dataIdx < _maxPosition && _maxPosition != 0)
				{
					_cellVec[i].data = _cellData[_dataIdx];
					_cellVec[i].index = _dataIdx;
					_cellVec[i].show(_contentLayer, 0 , i * (_cellVec[i].height + _hSpace));
					
					
					_dataIdx++;
				}
				else
				{
					_cellVec[i].remove();
				}
			}
			DisplayUtil.bringToTop(_scrollBar);
		}
		
		
		
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
			for (var i:uint = 0 ; i < _cellVec.length; i++)
			{
				_cellVec[i].dispose();
			}
			_cellVec = null;
			_scrollBar.dispose(); 
			_scrollBar = null;
			_scrollBarSkin = null;
			_cellCls = null;
			_contentLayer = null;
			_bg = null;
		}
	}
}