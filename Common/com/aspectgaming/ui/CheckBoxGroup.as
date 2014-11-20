package com.aspectgaming.ui
{
	import com.aspectgaming.ui.event.CheckBoxEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="checkBoxGroupChanged", type="com.aspectgaming.ui.event.CheckBoxEvent")]
	/**
	 * 复选框按钮组 
	 * @author mason.li
	 * 
	 */	
	public class CheckBoxGroup extends EventDispatcher
	{
		private var _checkBoxButtons:Vector.<CheckBoxButton>;
		private var _selectedIndex:Array;
		private var _defaultIndex:Array;
		
		public function CheckBoxGroup(vec:Vector.<CheckBoxButton>, dIndexArray:Array = null)
		{
			_checkBoxButtons = vec;
			_defaultIndex = dIndexArray ? dIndexArray : [];
			_selectedIndex = _defaultIndex;
			addEvent();
			doSelect(_defaultIndex);
		}
		
		/**
		 * 切换按钮选项 
		 * @param vec
		 * 
		 */		
		public function changeButtonList(vec:Vector.<CheckBoxButton>):void
		{
			_checkBoxButtons = vec;
			addEvent();
			_selectedIndex = _defaultIndex;
			doSelect(_defaultIndex);
		}
		
		/**
		 * 默认选中索引 
		 * @param value
		 * 
		 */		
		public function set defaultIndex(value:Array):void
		{
			_defaultIndex = value;
		}
		
		/**
		 * 当前选中索引 
		 * @return 
		 * 
		 */		
		public function get selectedIndex():Array
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:Array):void
		{
			_selectedIndex = value;
			doSelect(_selectedIndex);
		}
		
		public function set unSelectedIndex(value:Array):void
		{
			_selectedIndex = value;
			doSelect(_selectedIndex, false);
		}
		
		public function get selectedValue():Array
		{
			var result:Array = [];
			for each (var cb:CheckBoxButton in _checkBoxButtons)
			{
				if (cb.selected)
				{
					result.push( cb.data );
				}
			}
			
			return result;
		}
		
		private function addEvent():void
		{
			for (var i:uint = 0; i < _checkBoxButtons.length ; i++)
			{
				_checkBoxButtons[i].index = i + 1;
				_checkBoxButtons[i].addEventListener(CheckBoxEvent.CHECK_BOX_SELECTED, onCheckBoxSelected);
				_checkBoxButtons[i].addEventListener(CheckBoxEvent.CHECK_BOX_UNSELECTED, onCheckBoxSelected);
			}
		}
		
		private function doSelect(arr:Array, isSelected:Boolean = true):void
		{
			for each (var btn:CheckBoxButton in _checkBoxButtons)
			{
				for (var i:uint = 0; i < arr.length; i++)
				{
					if (btn.index == arr[i])
					{
						btn.selected = isSelected;
						processIndex(isSelected, arr[i]);
						break;
					}
				}
			}
		}
		
		/**
		 * 干索引 
		 * @param isAdd
		 * @param idx
		 * 
		 */		
		private function processIndex(isAdd:Boolean, idx:uint):void
		{
			if (_selectedIndex.indexOf(idx) == -1 && isAdd)
			{
				_selectedIndex.push(idx);
			}
			else if (_selectedIndex.indexOf(idx) != -1 && !isAdd)
			{
				_selectedIndex.splice(_selectedIndex.indexOf(idx), 1);
			}
		}
		
		private function onCheckBoxSelected(e:CheckBoxEvent):void
		{
			doSelect(e.checkGroupList, e.type == CheckBoxEvent.CHECK_BOX_SELECTED);
			
			dispatchEvent(new CheckBoxEvent(CheckBoxEvent.CHECK_BOX_GROUP_CHANGED, _selectedIndex));
		}
		
		public function dispose():void
		{
			for each (var btn:CheckBoxButton in _checkBoxButtons)
			{
				btn.removeEventListener(CheckBoxEvent.CHECK_BOX_SELECTED, onCheckBoxSelected);
				btn.removeEventListener(CheckBoxEvent.CHECK_BOX_UNSELECTED, onCheckBoxSelected);
				btn.dispose();
			}
			
			_checkBoxButtons = null;
		}
	}
}