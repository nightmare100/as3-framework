package com.aspectgaming.ui.iface
{
	import flash.display.DisplayObject;

	public interface IView
	{
		function addByCenter(o:DisplayObject):void;
		function dispose():void;
		function set enabled(value:Boolean):void
		function get enabled():Boolean;
	}
}