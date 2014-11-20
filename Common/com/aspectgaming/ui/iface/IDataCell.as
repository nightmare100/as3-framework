package com.aspectgaming.ui.iface
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	/**
	 * 数据元件 接口
	 * @author mason.li
	 * 
	 */	
	public interface IDataCell extends IEventDispatcher
	{
		function set data(value:*):void;
		function get data():*;
		function get width():Number;
		function get height():Number;
		function get index():int;
		function set index(value:int):void;
		function show(par:DisplayObjectContainer, x:Number = -1, y:Number = -1):void;
		function remove():void;
		function setFrame(frame:int):void;
		function dispose():void;
	}
}