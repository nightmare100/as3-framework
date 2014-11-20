package com.aspectgaming.core 
{
	import flash.events.IEventDispatcher;

	/**
	 * ...
	 * @author Evan.Chen
	 */
	public interface IServer extends IEventDispatcher
	{
		function sendRequest(req:String, parm:Object = null):void;
		function init(appurl:String, isEncode:Boolean, parse:IParse = null, logFunc:Function = null, type:String = "AMF"):void;
		
		function connect():void;
		
		/**
		 * 锁住所有消息
		 * 
		 */		
		function blockCommand(req:String):void;
		
		/**
		 * 释放所有消息 
		 * 
		 */		
		function releaseCommand(req:String):void;
		function close():void;
		function dispose():void;
	}
	
}