package com.aspectgaming.ui.iface
{
	import flash.display.DisplayObjectContainer;

	/**
	 * 日志面板接口
	 * @author mason.li
	 * 
	 */	
	public interface ILogView
	{
		function update(arr:Array):void;
		function show(layer:DisplayObjectContainer = null, alignType:int = 4):void
	}
}