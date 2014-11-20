package com.aspectgaming.ui
{
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.ui.event.CheckBoxEvent;
	import com.aspectgaming.ui.event.RadioEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	[Event(name="checkBoxSelected", type="com.aspectgaming.ui.event.CheckBoxEvent")]
	[Event(name = "checkBoxUnSelected", type = "com.aspectgaming.ui.event.CheckBoxEvent")]
	[Event(name = "checkBoxUpdated", type = "com.aspectgaming.ui.event.CheckBoxEvent")]
	
	
	/**
	 * 复选框按钮 
	 * @author mason.li
	 * 
	 */	
	public class CheckBoxButton extends RadioButton
	{
		public function CheckBoxButton(mc:*, isSoundPlay:Boolean = false)
		{
			super(mc, isSoundPlay);
		}
		
		override protected function onClick(e:MouseEvent):void
		{
			selected =  !selected;
			if (selected)
			{
				dispatchEvent(new CheckBoxEvent(CheckBoxEvent.CHECK_BOX_SELECTED, [index]));
			}
			else
			{
				dispatchEvent(new CheckBoxEvent(CheckBoxEvent.CHECK_BOX_UNSELECTED, [index]));
			}
			dispatchEvent(new CheckBoxEvent(CheckBoxEvent.CHECK_BOX_UPDATED, [index]));
		}
	}
}