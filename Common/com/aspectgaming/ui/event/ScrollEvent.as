package com.aspectgaming.ui.event
{
	import flash.events.Event;
	
	public class ScrollEvent extends Event
	{
		public static const SCROLL:String = "scroll";
		public static const SCROLL_DATA_SELECTED:String = "scrollDataSelected";
		public static const SCROLL_DATA_CHANGED:String = "scrollDataChanged";
		
		private var _position:int;
		private var _data:*;
		private var _targetObject:*;
		private var _targetName:String;		
		
		public function ScrollEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,position:int = 0, cellObj:* = null)
		{
			super(type, bubbles, cancelable);
			_position = position;
			_targetObject = cellObj
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

		public function get position():int
		{
			return _position;
		}
	}
}