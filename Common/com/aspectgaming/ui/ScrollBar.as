package com.aspectgaming.ui
{
	
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	import com.aspectgaming.ui.event.ScrollEvent;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.DomainUtil;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	[Event(name="scroll", type = "com.aspectgaming.ui.event.ScrollEvent")]
	
	/**
	 * 滚动条 
	 * @author mason.li
	 * 
	 */	
	public class ScrollBar extends Sprite
	{
		protected var _thumb:Sprite;
		protected var _track:Sprite;
		protected var _upBtn:InteractiveObject;
		protected var _downBtn:InteractiveObject;
		protected var _downBtnHeight:Number = 0;
		protected var _scrollRect:Rectangle = new Rectangle();
		//
		private var _wheelObject:InteractiveObject;
		
		private var _pageSize:int;
		private var _percent:Number = 0;//滚动比例
		private var _scrollPosition:int = 0;
		private var _maxScrollPosition:int = 0;
		private var _pageScrollSize:uint = 1;
		
		private var _visibleThumb:Boolean = true;
		private var _isScroll:Boolean;
		private var _hasTrack:Boolean;
		
		private var _innerHeight:Number;
		
		private var _clickDistant:Number = 3;
		
		private var _buttonJam:Boolean=false
		public function ScrollBar(mheight:Number = 100, skin:MovieClip = null,buttonJam:Boolean = false, hasTrack:Boolean = true)
		{
			mouseEnabled = false;
			_buttonJam = buttonJam;
			_hasTrack = hasTrack;
			
			if (_hasTrack)
			{
				_track = skin ? skin["ScrollBar_Track"] : DomainUtil.getSprite("ScrollBar_Track");
				_track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackDown);
				addChild(_track);
			}
			
			_thumb = new ScrollThumb(skin);
			_thumb.mouseEnabled = false;
			_thumb.visible = false;
			if (_hasTrack)
			{
				_thumb.x = (_track.width - _thumb.width) /2;
			}
			
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			addChild(_thumb);
			
			_upBtn = skin ? skin["ScrollBar_UpBtn"]  : DomainUtil.getSimpleButton("ScrollBar_UpBtn");
			if (_upBtn)
			{
				_scrollRect.y = _upBtn.height;
				if (_hasTrack)
				{
					_upBtn.x = (_track.width-_upBtn.width)/2;
				}
				_upBtn.mouseEnabled = false;
				_upBtn.addEventListener(MouseEvent.MOUSE_DOWN, onUpDown);
				addChild(_upBtn);
			}
			
			_downBtn = skin ? skin["ScrollBar_DownBtn"]  :DomainUtil.getSimpleButton("ScrollBar_DownBtn");
			if (_downBtn)
			{
				_downBtnHeight = _downBtn.height;
				if (_hasTrack)
				{
					_downBtn.x = (_track.width-_downBtn.width)/2;
				}
				_downBtn.mouseEnabled = false;
				_downBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDownDown);
				addChild(_downBtn);
			}
			//
			_scrollRect.x = _hasTrack?(_track.x + (_track.width - _thumb.width) / 2):0;
			if (hasTrack)
			{
				this.height = mheight;
			}
			else
			{
				_innerHeight = mheight;
			}
		}
		
		public function dispose():void
		{
			_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			if (_track)
			{
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackDown);
			}
			
			if (_wheelObject)
			{
				_wheelObject.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
				_wheelObject = null;
			}
			if (_upBtn)
			{
				if (_upBtn.hasEventListener(Event.ENTER_FRAME)) { _upBtn.removeEventListener(Event.ENTER_FRAME, onUpEnter)};
				_upBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onUpDown);
				if(_upBtn.stage)
				{
					_upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, onUpUp)
				};
				_upBtn = null;
			}
			if (_downBtn)
			{

				if (_downBtn.hasEventListener(Event.ENTER_FRAME)) { _downBtn.removeEventListener(Event.ENTER_FRAME, onDownEnter)};
				_downBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onDownDown);
				if(_downBtn.stage)
				{
					_downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, onDownUp)
				};
				_downBtn = null;
			}
			_thumb = null;
			_track = null;
			_scrollRect = null;
		}
		
		override public function set height(value:Number):void
		{
			if (_hasTrack)
			{
				_track.height = value;
				if (_downBtn)
				{
					_downBtn.y = _track.height - _downBtn.height;
				}
			}
			_thumb.y = _scrollRect.y;
			updateScroll();
		}
		
		override public function get height():Number
		{
			return _hasTrack?_track.height:_innerHeight;
		}
		
		public function set visibleThumb(value:Boolean):void
		{
			_visibleThumb = value;
			if(_visibleThumb)
			{
				_thumb.visible = true;
			}
			else
			{
				_thumb.visible = false;
			}
		}
		public function get visibleThumb():Boolean
		{
			return _visibleThumb;
		}
		
		//--------------------------------------------------------------
		// get set
		//--------------------------------------------------------------
		
		/**
		 * 等效于一页的行数。
		 * @return 
		 * 
		 */		
		public function get pageSize():int
		{
			return _pageSize;
		}
		public function set pageSize(value:int):void
		{
			_pageSize = value;
			updateScroll();
		}
		
		/**
		 * 按下滚动条轨道时滚动滑块的移动量（以行为单位）。 
		 * @return 
		 * 
		 */		
		public function get pageScrollSize():int
		{
			return _pageScrollSize;
		}
		public function set pageScrollSize(value:int):void
		{
			_pageScrollSize = value;
		}
		
		/**
		 * 表示当前滚动位置的数值。
		 * @return 
		 * 
		 */		
		public function get scrollPosition():int
		{
			return _scrollPosition;
		}
		public function set scrollPosition(value:int):void
		{
			if (value < 0 || value > _maxScrollPosition)
			{
				return;
			}
			_scrollPosition = value;
			_thumb.y = _scrollPosition * _percent + _scrollRect.y;
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,false,false,_scrollPosition));
		}
		
		/**
		 * 滚动至最下面
		 * 
		 */		
		public function scrollToBotton():void
		{
			scrollPosition = maxScrollPosition;
		}
		
		/**
		 * 表示最大滚动位置的数值。
		 * @return 
		 * 
		 */		
		public function get maxScrollPosition():int
		{
			return _maxScrollPosition;
		}
		public function set maxScrollPosition(value:int):void
		{
			_maxScrollPosition = value;
			_thumb.y = _scrollRect.y;
			var scrollVal:int = Math.max(value - _pageSize, 0);
			scrollPosition = _scrollPosition <= scrollVal ? _scrollPosition : scrollVal;
			updateScroll();
		}
		
		public function set wheelObject(o:InteractiveObject):void
		{
			_wheelObject = o;
			if (_isScroll && !NewPlayerGuidManager.isInNewPlayerGuide)
			{
				_wheelObject.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			}
		}
		
		public function get wheelObject():InteractiveObject
		{
			return _wheelObject;
		}
		
		//--------------------------------------------------------------
		// public
		//--------------------------------------------------------------
		
		/**
		 * 设置初始属性
		 * @param pageSize
		 * @param maxScrollPosition
		 * @param pageScrollSize
		 * 
		 */		
		public function setScrollProperties(pageSize:int, maxScrollPosition:int, pageScrollSize:int = 1):void
		{
			_pageSize = pageSize;
			this.maxScrollPosition = maxScrollPosition;
			scrollPosition = 0;
			_pageScrollSize = pageScrollSize;
		}
		
		public function setScrollVisible(isShow:Boolean):void
		{
			if (isShow)
			{
				updateScroll();
			}
			else
			{
				visible  = false;
			}
		}
		
		//--------------------------------------------------------
		// private
		//--------------------------------------------------------
		
		private function updateScroll():void
		{
			_isScroll = _maxScrollPosition > _pageSize;
			if (_isScroll)
			{
				visible = true;
				var scrollArea:Number = height - _scrollRect.y - _downBtnHeight;
				_thumb.height = scrollArea * _pageSize / _maxScrollPosition;
				_scrollRect.height = height - _thumb.height - _scrollRect.y - _downBtnHeight;
				_clickDistant = _scrollRect.height / (_maxScrollPosition - _pageSize);
				_percent = _scrollRect.height / (_wheelObject is TextField ? _maxScrollPosition : (_maxScrollPosition - _pageSize));
				
				
				if(_visibleThumb)
				{
					if(_scrollRect.height > 0)
					{
						_thumb.mouseEnabled = true;
						_thumb.visible = true;
						_thumb.y = _scrollPosition * _percent + _scrollRect.y;
					}
					else
					{
						_thumb.mouseEnabled = false;
						_thumb.visible = false;
					}
				}
				if (_wheelObject && !NewPlayerGuidManager.isInNewPlayerGuide)
				{
					_wheelObject.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
				}
				if (_upBtn)
				{
					_upBtn.mouseEnabled = true;
				}
				if (_downBtn)
				{
					_downBtn.mouseEnabled = true;
				}
				DisplayUtil.enableSprite(this);
			}
			else
			{
				_thumb.mouseEnabled = false;
				_thumb.visible = false;
				if (_wheelObject)
				{
					_wheelObject.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
				}
				if (_upBtn)
				{
					_upBtn.mouseEnabled = false;
					if(_upBtn.stage)
					{
						_upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, onUpUp)
					};
				}
				if (_downBtn)
				{
					_downBtn.mouseEnabled = false;
					if(_downBtn.stage)
					{
						_downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, onDownUp)
					};
				}
				DisplayUtil.disableSprite(this);
			}
		}
		
		//--------------------------------------------------------
		// event
		//--------------------------------------------------------
		
		protected function onThumbDown(event:MouseEvent):void
		{
			_thumb.startDrag(false, _scrollRect);
			_thumb.stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
			_thumb.stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
		}
		
		private function onThumbUp(event:MouseEvent):void
		{
			if (_thumb)
			{
				_thumb.stopDrag();
				if (_thumb.stage)
				{
					_thumb.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
					_thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
				}
			}
		}
		
		private function onThumbMove(event:MouseEvent):void
		{
			if (_thumb)
			{
				if (_thumb.y < _scrollRect.y)
				{
					_thumb.y = _scrollRect.y;
				}
				if (_thumb.y > _scrollRect.bottom)
				{
					_thumb.y = _scrollRect.bottom;
				}
				
				var index:int = Math.round((_thumb.y - _scrollRect.y) / _percent);
				if (index < 0)
				{
					index = 0;
				}
				if (Math.ceil(index/_pageScrollSize) != _scrollPosition)
				{
					_scrollPosition = Math.ceil(index/_pageScrollSize);
					dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL,false,false,_scrollPosition));
				}
			}
		}
		
		protected function onTrackDown(event:MouseEvent):void
		{
			_thumb.y = (_track.parent.mouseY - _scrollRect.y) / (_scrollRect.height + _thumb.height) * _scrollRect.height + _scrollRect.y;
			onThumbMove(null);
		}
		
		private function onWheel(event:MouseEvent):void
		{
			if (_thumb.y >= _scrollRect.y && _thumb.y <= _scrollRect.bottom)
			{
				_thumb.y -= event.delta;
				onThumbMove(null);
			}
		}
		
		protected function onUpDown(event:MouseEvent):void
		{
			if (this._buttonJam) {
				_upBtn.addEventListener(Event.ENTER_FRAME, onUpEnter);
			}else {
				onUpEnter(null)
			}
			if(_upBtn.stage)
			{
				_upBtn.stage.addEventListener(MouseEvent.MOUSE_UP, onUpUp);
			}
		}
		
		private function onUpUp(event:MouseEvent):void
		{
			if (_upBtn)
			{
				if (_upBtn.hasEventListener(Event.ENTER_FRAME)) {
					_upBtn.removeEventListener(Event.ENTER_FRAME, onUpEnter);
				}
				if(_upBtn.stage)
				{
					_upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, onUpUp);
				}
			}
		}
		
		private function onUpEnter(event:Event):void
		{
			if (_thumb.y >= _scrollRect.y)
			{
				_thumb.y -= _clickDistant;
				onThumbMove(null);
			}
			else
			{
				_thumb.y = _scrollRect.y;
				if (_upBtn.hasEventListener(Event.ENTER_FRAME)) {
					_upBtn.removeEventListener(Event.ENTER_FRAME, onUpEnter);
				}
			}
		}
		
		protected function onDownDown(event:MouseEvent):void
		{
			if (this._buttonJam) {
			_downBtn.addEventListener(Event.ENTER_FRAME, onDownEnter);
			}
			else {
				onDownEnter(null)
			}
			if(_downBtn.stage)
			{
				_downBtn.stage.addEventListener(MouseEvent.MOUSE_UP, onDownUp)
			};
		}
		
		private function onDownUp(event:MouseEvent):void
		{
			if (_downBtn)
			{
				if (_downBtn.hasEventListener(Event.ENTER_FRAME)) {
					_downBtn.removeEventListener(Event.ENTER_FRAME, onDownEnter);
				}
				if(_downBtn.stage)
				{
					_downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP, onDownUp)
				};
			}
			
		}
		
		private function onDownEnter(event:Event):void
		{
			if (_thumb.y <= _scrollRect.bottom)
			{
				_thumb.y += _clickDistant;
				onThumbMove(null);
			}
			else
			{
				_thumb.y = _scrollRect.bottom;
				if (_downBtn.hasEventListener(Event.ENTER_FRAME)) {
					_downBtn.removeEventListener(Event.ENTER_FRAME, onDownEnter);
				}
			}
		}
	}
}