package com.aspectgaming.ui
{
	import com.aspectgaming.ui.event.RadioEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * 单选按钮组 
	 * @author mason.li
	 * 
	 */	
	[Event(name="radioChanged", type="com.aspectgaming.ui.event.RadioEvent")]
	public class RadioGroup extends EventDispatcher
	{
		protected var _radionButtons:Vector.<RadioButton>;
		protected var _selectedIndex:uint;
		protected var _defaultIndex:uint;
		
		public function RadioGroup(vec:Vector.<RadioButton>, defaultIndex:uint = 1)
		{
			_radionButtons = vec;
			_selectedIndex = defaultIndex;
			_defaultIndex = defaultIndex;
			addEvent();
			doSelect(_defaultIndex);
		}
		
		/**
		 * 切换按钮选项 
		 * @param vec
		 * 
		 */		
		public function changeButtonList(vec:Vector.<RadioButton>):void
		{
			_radionButtons = vec;
			addEvent();
			_selectedIndex = _defaultIndex;
			doSelect(_defaultIndex);
		}
		
		/**
		 * 默认选中索引 
		 * @param value
		 * 
		 */		
		public function set defaultIndex(value:uint):void
		{
			_defaultIndex = value;
		}

		/**
		 * 当前选中索引 
		 * @return 
		 * 
		 */		
		public function get selectedIndex():uint
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:uint):void
		{
			_selectedIndex = value;
			doSelect(_selectedIndex);
		}
		
		public function get selectedValue():*
		{
			return _radionButtons[_selectedIndex - 1].data;
		}

		protected function addEvent():void
		{
			for (var i:uint = 0; i < _radionButtons.length ; i++)
			{
				_radionButtons[i].index = i + 1;
				_radionButtons[i].addEventListener(RadioEvent.RADIO_SELECTED, onRadioSelected);
			}
		}
		
		protected function doSelect(id:uint):void
		{
			for each (var btn:RadioButton in _radionButtons)
			{
				if (btn.index == id)
				{
					btn.selected = true;
				}
				else
				{
					btn.selected = false;
				}
			}
		}
		
		
		public function unSelectAll():void
		{
			for each (var btn:RadioButton in _radionButtons)
			{
				btn.selected = false;
			}
			_selectedIndex = 0;
		}
		
		public function disableButton(idx:uint):void
		{
			for each (var btn:RadioButton in _radionButtons)
			{
				if (btn.index == idx)
				{
					btn.enabled = false;
					btn.viewComponent.buttonMode = false;
					return;
				}
			}
		}
		
		public function enableAll():void
		{
			for each (var btn:RadioButton in _radionButtons)
			{
				btn.enabled = true;
				btn.viewComponent.buttonMode = true;
			}
		}
		
		protected function onRadioSelected(e:RadioEvent):void
		{
			for each (var btn:RadioButton in _radionButtons)
			{
				if (btn.index != e.index)
				{
					btn.selected = false;
				}
			}
			
			_selectedIndex = e.index;
			dispatchEvent(new RadioEvent(RadioEvent.RADIO_GROUP_CHANGED, e.index));
		}
		
		public function dispose():void
		{
			for each (var btn:RadioButton in _radionButtons)
			{
				btn.removeEventListener(RadioEvent.RADIO_SELECTED, onRadioSelected);
				btn.dispose();
			}
			
			_radionButtons = null;
		}
		
		
	}
}