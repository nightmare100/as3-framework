package com.aspectgaming.ui.event
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	/**
	 * BaseComponent 组件事件 
	 * @author mason.li
	 * 
	 */	
	public class ComponentEvent extends Event
	{
		public static const DISPOSE:String  = "dispose";
		public static const SHOW:String = "show";
		public static const HIDE:String = "hide";
		
		public static const FRAME_CHANGED:String = "frameChanged";
		
		public var data:*;
		public var callTarget:InteractiveObject;
		
		public function ComponentEvent(type:String, info:* = null, target:InteractiveObject = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = info;
			callTarget = target;
		}
		
		
	}
}