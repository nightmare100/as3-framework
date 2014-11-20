package com.aspectgaming.ui
{
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	[Event(name="change", type="flash.events.Event")]
	/**
	 * 数字控制器 
	 * @author mason.li
	 * 
	 */	
	public class NumericControl extends BaseComponent
	{
		protected var _downTimeout:uint = 300;
		protected var _isInHoverStatue:Boolean;
		
		protected var _timeTick:int;
		private var _isAdd:Boolean;
		private var _btnAdd:InteractiveObject;
		private var _btnSub:InteractiveObject;
		protected var _textControl:TextField;
		
		protected var _defaultNum:Number;
		protected var _currentValue:Number;
		protected var _minNum:Number;
		protected var _maxNum:Number;
		
		protected var _canInput:Boolean;
		
		protected var _filterArr:Array;
		
		public function NumericControl(mc:InteractiveObject, defaultValue:Number, minValue:Number, maxValue:Number, canInput:Boolean = true)
		{
			_defaultNum = defaultValue;
			_currentValue = _defaultNum;
			_minNum = minValue;
			_maxNum = maxValue;
			_canInput = canInput;
			super(mc);
		}
		
		public function reset():void
		{
			_currentValue = _defaultNum;
			checkValue();
		}
		
		public function set filterArr(value:Array):void
		{
			_filterArr = value;
			checkFilter();
		}
		
		private function checkFilter():void
		{
			if (_filterArr && _filterArr.length > 0 && _filterArr.indexOf(_currentValue) != -1)
			{
				_isAdd ? _currentValue++ : _currentValue--;
				_currentValue = _currentValue < _minNum ? _minNum : _currentValue;
				_currentValue = _currentValue > _maxNum ? _maxNum : _currentValue;
				
				if (_filterArr.indexOf(_currentValue) != -1)
				{
					if (_currentValue == _maxNum || _currentValue == _minNum)
					{
						_currentValue = _currentValue == _maxNum ? _minNum : _currentValue;
						return;
					}
					checkFilter();
				}
			}
		}
		
		public function set currentValue(value:Number):void
		{
			_currentValue = value;
			_textControl.text = _currentValue.toString();
		}

		public function get currentValue():Number
		{
			return _currentValue;
		}

		public function set maxNum(value:Number):void
		{
			_maxNum = (value >> 0);
			checkValue(false);
			checkButton();
		}

		public function set minNum(value:Number):void
		{
			_minNum = (value >> 0);
			checkValue(false);
			checkButton();
		}
		
		private function checkButton():void
		{
			if (_minNum == _maxNum)
			{
				enabled = false;
			}
			else
			{
				enabled = true;
			}
		}

		public function set defaultNum(value:Number):void
		{
			_defaultNum = value;
		}

		override protected function init():void
		{
			_btnAdd = _viewComponent["btnAdd"];
			_btnSub = _viewComponent["btnSub"];
			if (!_btnAdd is Sprite)
			{
				Sprite(_btnAdd).buttonMode = true;
			}
			if (!_btnSub is Sprite)
			{
				Sprite(_btnSub).buttonMode = true;
			}
			
			_textControl = _viewComponent["_txt"];
			_textControl.restrict = "0-9";
			_textControl.text = _defaultNum.toString();
			
			_textControl.type = _canInput ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			_textControl.wordWrap = true
			_textControl.selectable = _canInput ? true : false;
			checkButton();
			super.init();
		}
		
		/**
		 * 检测数据 
		 * 
		 */		
		private function checkValue(needDispatch:Boolean = true):void
		{
			_currentValue = _currentValue < _minNum ?  _maxNum  : _currentValue;
			_currentValue = _currentValue > _maxNum ? (_isAdd ? _minNum : _maxNum ) : _currentValue;
			
			checkFilter();
			_textControl.text = _currentValue.toString();
			if (needDispatch)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function checkValueRuleHover():void
		{
			_currentValue = _currentValue < _minNum ? _minNum : _currentValue;
			_currentValue = _currentValue > _maxNum ? _maxNum : _currentValue;
			
			checkFilter();
			_textControl.text = _currentValue.toString();
		}
		
		public function changeInputMethod(type:String):void
		{
			_textControl.type = type;
			if (type == TextFieldType.INPUT )
			{
				_textControl.addEventListener(Event.CHANGE, onInput);
			}
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if (enabled && _minNum < _maxNum)
			{
				DisplayUtil.enableButton(_btnAdd);
				DisplayUtil.enableButton(_btnSub);
				_textControl.mouseEnabled = true;
			}
			else
			{
				DisplayUtil.disableInterObjectWithDark(_btnAdd);
				DisplayUtil.disableInterObjectWithDark(_btnSub);
				_textControl.mouseEnabled = false;
				if (_textControl.stage)
				{
					_textControl.stage.focus = null;
				}
			}
		}
		
		
		
		override protected function addEvent():void
		{
			_btnAdd.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_btnSub.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			if (_textControl.type == TextFieldType.INPUT)
			{
				_textControl.addEventListener(Event.CHANGE, onInput);
			}
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			_viewComponent.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_timeTick = setTimeout(onDownStatue, _downTimeout);
			_isAdd = e.target == _btnAdd;
			function onDownStatue():void
			{
				_viewComponent.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				_isInHoverStatue = true;
				_viewComponent.stage.addEventListener(MouseEvent.MOUSE_UP, onFrameUp);
				
				addEventListener(Event.ENTER_FRAME, onFrame);
			}
		}
		
		private function onFrameUp(e:MouseEvent):void
		{
			_viewComponent.stage.removeEventListener(MouseEvent.MOUSE_UP, onFrameUp);
			clearTimeout(_timeTick);
			removeEventListener(Event.ENTER_FRAME, onFrame);
			_isInHoverStatue = false;
			checkValue();
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			_viewComponent.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			clearTimeout(_timeTick);
			removeEventListener(Event.ENTER_FRAME, onFrame);
			if (_isInHoverStatue)
			{
				_isInHoverStatue = false;
			}
			else
			{
			 	_isAdd ? _currentValue++ : _currentValue--;
				checkValue();
			}
		}
		
		private function onFrame(e:Event):void
		{
			if (_isAdd)
			{
				_currentValue += 1;
			}
			else
			{
				_currentValue -= 1;
			}
			checkValueRuleHover();
		}
		
		override protected function removeEvent():void
		{
			_btnAdd.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_btnSub.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if(_viewComponent.stage){
				_viewComponent.stage.removeEventListener(MouseEvent.MOUSE_UP, onFrameUp);
				_viewComponent.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
			_textControl.removeEventListener(Event.CHANGE, onInput);
			clearTimeout(_timeTick);
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		protected function onInput(e:Event):void
		{
			_currentValue = Number(_textControl.text);
			_currentValue = _currentValue < _minNum ? _minNum : _currentValue;
			_currentValue = _currentValue > _maxNum ? _maxNum : _currentValue;
			
			_textControl.text = _currentValue.toString();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			super.dispose();
		}
		
	}
}