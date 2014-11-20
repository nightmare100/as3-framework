package com.aspectgaming.ui
{
	import com.aspectgaming.ui.event.CheckBoxEvent;
	import com.aspectgaming.ui.event.RadioEvent;
	
	/**
	 * 使用CheckButton的 radioGroup(可选中 和 不选 但只能选一项) 
	 * @author mason.li
	 * 
	 */	
	public class RadioCheckBoxGroup extends RadioGroup
	{
		private var _checkButtonList:Vector.<CheckBoxButton>;
		
		public function RadioCheckBoxGroup(vec:Vector.<CheckBoxButton>, dIndex:uint = 1)
		{
			_checkButtonList = vec;
			super(new Vector.<RadioButton>(), dIndex);
		}
		
		override protected function doSelect(index:uint):void
		{
			for each (var btn:CheckBoxButton in _checkButtonList)
			{
				if (btn.index == index)
				{
					btn.selected = true;
					break;
				}
				else
				{
					btn.selected = false;
				}
			}
		}
		
		
		override public function unSelectAll():void
		{
			for each (var btn:CheckBoxButton in _checkButtonList)
			{
				btn.selected = false;
			}
			_selectedIndex = 0;
		}
		
		private function onCheckBoxSelected(e:CheckBoxEvent):void
		{
			for each (var btn:CheckBoxButton in _checkButtonList)
			{
				if (btn.index != e.checkGroupList[0])
				{
					btn.selected = false;
				}
			}
			
			if (e.type == CheckBoxEvent.CHECK_BOX_SELECTED)
			{
				_selectedIndex = e.checkGroupList[0];
			}
			else
			{
				_selectedIndex = 0;
			}
			
			dispatchEvent(new RadioEvent(RadioEvent.RADIO_GROUP_CHANGED, _selectedIndex));
		}
		
		override protected function addEvent():void
		{
			for (var i:uint = 0; i < _checkButtonList.length ; i++)
			{
				_checkButtonList[i].index = i + 1;
				_checkButtonList[i].addEventListener(CheckBoxEvent.CHECK_BOX_SELECTED, onCheckBoxSelected);
				_checkButtonList[i].addEventListener(CheckBoxEvent.CHECK_BOX_UNSELECTED, onCheckBoxSelected);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			for each (var btn:RadioButton in _checkButtonList)
			{
				btn.removeEventListener(CheckBoxEvent.CHECK_BOX_SELECTED, onCheckBoxSelected);
				btn.removeEventListener(CheckBoxEvent.CHECK_BOX_UNSELECTED, onCheckBoxSelected);
				btn.dispose();
			}
			
			_checkButtonList = null;
		}
		public function hide(idx:uint):void
		{
			_checkButtonList[idx].visible = false;
		}
		public function showAll():void
		{
			for (var i:uint = 0; i < _checkButtonList.length ; i++)
			{
				_checkButtonList[i].visible = true;
			}
		}
	}
}