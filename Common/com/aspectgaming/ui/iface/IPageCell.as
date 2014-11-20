package com.aspectgaming.ui.iface
{
	import com.aspectgaming.data.configuration.game.GameCellInfo;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	/**
	 * 页面填充元件 
	 * @author mason.li
	 * 
	 */	
	public interface IPageCell extends IEventDispatcher, IView
	{
		function set data(value:GameCellInfo):void;
		function get data():GameCellInfo;
		function get right():Number;
		function get bottom():Number;
		function set index(value:int):void;
		function unLock():void;
		function show(par:DisplayObjectContainer, x:Number, y:Number):void;
		function remove():void;
	}
}