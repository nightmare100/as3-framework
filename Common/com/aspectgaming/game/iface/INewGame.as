package com.aspectgaming.game.iface 
{
	
	import com.aspectgaming.data.game.GameInfo;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * 新游戏接口 
	 * @author mason.li
	 * 
	 */	
	public interface INewGame extends IEventDispatcher
	{
		function init(gameInfo:GameInfo, simulator:*):void;
		function dispose():void;
		
		/**
		 * 游戏重启 
		 * 
		 */		
		function reset():void
		function get gameVersion():String;
		function dispatch(e:Event):void
	}
}