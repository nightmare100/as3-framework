package com.aspectgaming.core 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Mason.Li
	 */
	public interface ILobby
	{
		function get loginOkFunc():Function;
		function init(obj:Object, callBack:Function):void;
		function dispose():void;
		function reset():void;
		function get version():String;
		function dispatch(e:Event):void;
	}

	
}