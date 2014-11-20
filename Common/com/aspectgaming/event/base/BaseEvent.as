package com.aspectgaming.event.base
{
	import flash.events.Event;
	
	/**
	 * 基础事件 请继承
	 * @author mason.li
	 * 
	 */	
	public class BaseEvent extends Event
	{
		protected var _data:*;
		protected var _content:String;
		
		public function BaseEvent(type:String, data:* = null,content:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
			_content = content;
		}

		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			_content = value;
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