package com.aspectgaming.game.iface
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 游戏模块 
	 * @author mason.li
	 * 
	 */	
	public interface IGameModule
	{
		function restart():void;
		function show(par:DisplayObjectContainer, x:Number = 0, y:Number = 0):void;
		function dispose():void;
		function hide():void;
	}
}