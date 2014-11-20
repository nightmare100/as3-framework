package com.aspectgaming.ui.event
{
	import flash.events.Event;
	
	public class DropDownListEvent extends Event
	{
		
		public static const SCROLL_MENU_DATA_SELECTED:String = "menuScrollDataSelected";
		
		public static const DROP_DOWN_CELL_OVER:String = "dropDownOver";
		public static const DROP_DOWN_CELL_OUT:String = "dropDownOut";
		public static const DROP_DOWN_CELL_CLICK:String = "dropDownClick";
		
		
		private var _indexNum:int;
		private var _data:*;
		private var _targetObject:*;
		private var _targetName:String;		
			
		public var index:uint;
		
		public function DropDownListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,index:int = 0, cellObj:* = null)
		{
			super(type, bubbles, cancelable);
			_indexNum = index;
			_targetObject = cellObj
		}
		
		
		public function get indexNum():int
		{
			return _indexNum;
		}

		public function get targetObject():*
		{
			return _targetObject;
		}
		
		public function set targetObject(value:*):void
		{
			_targetObject = value;
		}
		
		/**
		 * 内部元素所点击的 名称 
		 */
		public function get targetName():String
		{
			return _targetName;
		}
		
		/**
		 * @private
		 */
		public function set targetName(value:String):void
		{
			_targetName = value;
		}
		
		public function get data():*
		{
			return _data;
		}
		
		public function set data(value:*):void
		{
			_data = value;
		}
		

	}
}