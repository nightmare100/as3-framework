package com.aspectgaming.ui.event
{
	import flash.events.Event;
	
	/**
	 * 模块事件 
	 * @author mason.li
	 * 
	 */	
	public class ModuleEvent extends Event
	{
		public static const MODULE_INIT_START:String = "moduleInitStart";
		public static const MODULE_START_LOAD:String = "moduleStartLoad";
		public static const MODULE_END_LOAD:String = "moduleEndLoad";
		public static const MODULE_ADDED:String = "moduleAdded";
		public static const MODULE_REMOVED:String = "moduleRemoved";
	
		public var data:*;
		public function ModuleEvent(type:String, value:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = value;
		}
	}
}