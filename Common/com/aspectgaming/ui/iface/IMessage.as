package com.aspectgaming.ui.iface
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * 消息弹窗 
	 * @author mason.li
	 * 
	 */	
	public interface IMessage
	{
		function dispose():void;
		function autoShow():void;
		function autoClose():void;
		function set viewName(value:String):void;
		function get viewName():String;
		function set data(value:*):void;
		function get statue():String;
	}
}