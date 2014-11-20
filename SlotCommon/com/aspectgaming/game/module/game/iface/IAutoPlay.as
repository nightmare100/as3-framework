package com.aspectgaming.game.module.game.iface
{
	import flash.events.IEventDispatcher;

	public interface IAutoPlay extends IEventDispatcher
	{
		
		/**
		 *自动游戏
		 * @param idx
		 * @return 
		 * 
		 */		
		function reset():void;
		
		function dispose():void;
		
		function updateTimes(n:uint):void;
		
		function set enabled(value:Boolean):void;
	}
}