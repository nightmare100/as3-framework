package com.aspectgaming.popup.alert
{
	import com.aspectgaming.popup.data.AlertInfo;
	
	import flash.events.IEventDispatcher;

	public interface IAlert extends IEventDispatcher
	{
		function show(info:AlertInfo):void;
		function dispose():void;

		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;

		function get width():Number;
		function get height():Number;

	}
}
