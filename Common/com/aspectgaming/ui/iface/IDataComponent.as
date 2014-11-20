package com.aspectgaming.ui.iface
{
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;

	/**
	 * 可设置数据的 组件接口 
	 * @author mason.li
	 * 
	 */	
	public interface IDataComponent extends IEventDispatcher
	{
		function get data():*;
		function set data(value:*):void;
		function dispose():void;
		function get viewComponent():MovieClip;
	}
}