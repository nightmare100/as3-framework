package com.aspectgaming.ui.event
{
	public class CheckBoxEvent extends RadioEvent
	{
		public static const CHECK_BOX_SELECTED:String = "checkBoxSelected";
		public static const CHECK_BOX_UNSELECTED:String = "checkBoxUnSelected";
		public static const CHECK_BOX_GROUP_CHANGED:String = "checkBoxGroupChanged";
		public static const CHECK_BOX_UPDATED:String = "checkBoxUpdated";
		
		public var checkGroupList:Array;
		public var data:*;
		
		public function CheckBoxEvent(type:String, arr:Array, info:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, 0, bubbles, cancelable);
			checkGroupList = arr;
			data = data;
		}
	}
}