package com.aspectgaming.ui
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.ui.event.SlideBarEvent;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.FormatUtil;
	import com.aspectgaming.utils.NumberUtil;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * 数学拖动条 
	 * @author mason.li
	 * 
	 */	
	[Event(name="barSlide", type="com.aspectgaming.ui.event.SlideBarEvent")]
	public class SlideBar extends BaseComponent
	{
		private var _txtMin:TextField;
		private var _txtMax:TextField;
		
		private var _minVal:Number;
		private var _maxVal:Number;
		
		private var _dragBtn:Sprite;
		
		private var _isHorDrag:Boolean;
		private var _rect:Rectangle;
		private var _tagIcon:String;

		private var _rectBar:MovieClip;
		
		private var _currentValue:Number;
		
		public function SlideBar(mc:InteractiveObject, min:Number, max:Number,tagIcon:String = "$", isHor:Boolean = true)
		{
			_isHorDrag = isHor;
			_tagIcon = tagIcon;
			_minVal = min;
			_maxVal = max;
			_currentValue = _minVal;
			super(mc);
			
		}
		
		public function set currentValue(value:Number):void
		{
			if (value >= _minVal && value <= maxVal)
			{
				_currentValue = value;
				adjustPosition();
				dispatchEvent(new SlideBarEvent(SlideBarEvent.BAR_SLIDE, _currentValue));
			}
		}
		
		private function adjustPosition():void
		{
			var addVal:Number = _currentValue - _minVal;
			var totalVal:Number = _maxVal - _minVal;
			if (_rect)
			{
				if (_isHorDrag)
				{
					_dragBtn.x = addVal / totalVal * _rect.width;
				}
				else
				{
					_dragBtn.x = addVal / totalVal * _rect.height;
				}
			}
		}

		public function get minVal():Number
		{
			return _minVal;
		}

		public function get maxVal():Number
		{
			return _maxVal;
		}

		public function set maxVal(value:Number):void
		{
			_maxVal = value;
			reset();
		}

		public function set minVal(value:Number):void
		{
			_minVal = value;
			reset();
		}
		
		override public function set enabled(value:Boolean):void
		{
			// TODO Auto Generated method stub
			super.enabled = value;
			if (value)
			{
				DisplayUtil.enableSprite(_viewComponent);
			}
			else
			{
				DisplayUtil.disableSprite(_viewComponent);
			}
		}
		
		
		
		public function setCurrentValue():void
		{
			var addVal:Number = _maxVal - _minVal;
			if (_rect)
			{
				if (_isHorDrag)
				{
					_currentValue = _minVal + addVal * (_dragBtn.x - _rect.x) /  _rect.width;
				}
				else
				{
					_currentValue = _minVal + addVal * (_dragBtn.y - _rect.y) /  _rect.height;
				}
			}
			_currentValue = Math.min(_maxVal, _currentValue);
			_currentValue = Math.max(_minVal, _currentValue);
			_currentValue = Math.floor(_currentValue);
		}

		/**
		 * 当前值 
		 */
		public function get currentValue():Number
		{
			return _currentValue;
		}

		public function reset():void
		{
			_currentValue = _minVal;
			if (_isHorDrag)
			{
				_dragBtn.x = _rect.x;
			}
			else
			{
				_dragBtn.y = _rect.y;
			}
		}
		
		override protected function addEvent():void
		{
			_rectBar.addEventListener(MouseEvent.CLICK, onRectClick);
			_dragBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			super.addEvent();
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			LayerManager.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			LayerManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_dragBtn.startDrag(false, _rect);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			LayerManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_dragBtn.stopDrag();
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			setCurrentValue();
			dispatchEvent(new SlideBarEvent(SlideBarEvent.BAR_SLIDE, currentValue));
		}
		
		override protected function removeEvent():void
		{
			_dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_rectBar.removeEventListener(MouseEvent.CLICK, onRectClick);
			LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			LayerManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			super.removeEvent();
		}
		
		private function onRectClick(e:MouseEvent):void
		{
			if (_isHorDrag)
			{
				_dragBtn.x = e.localX;
				_dragBtn.x = _dragBtn.x > (_rect.width + _rect.x ) ? (_rect.width + _rect.x) : _dragBtn.x;
			}
			else
			{
				_dragBtn.y = e.localY;
				_dragBtn.y = _dragBtn.y > (_rect.height + _rect.y ) ? (_rect.height + _rect.y) : _dragBtn.y;
			}
			setCurrentValue();
			dispatchEvent(new SlideBarEvent(SlideBarEvent.BAR_SLIDE, currentValue));
		}
		
		override public function dispose():void
		{
			
			super.dispose();
		}
		
		override protected function init():void
		{
			
			_txtMin = _viewComponent["txtMin"];
			_txtMax = _viewComponent["txtMax"];
			_dragBtn = _viewComponent["drag"];
			_dragBtn.buttonMode = true;
				
			_rectBar = _viewComponent["rect"];
			
			if (_txtMin)
			{
				_txtMin.text = _tagIcon + FormatUtil.accountFormat( _minVal );
			}
			
			if (_txtMax)
			{
				_txtMax.text = _tagIcon + FormatUtil.accountFormat( _maxVal );
			}
			
			_rect = _rectBar.getBounds(_viewComponent);
			if (_isHorDrag)
			{
				_rect.height = 0;
				_rect.width -= _dragBtn["rect"].width;
			}
			else
			{
				_rect.width = 0;
				_rect.height -= _dragBtn["rect"].height;
			}
			super.init();
		}
		
		
	}
}