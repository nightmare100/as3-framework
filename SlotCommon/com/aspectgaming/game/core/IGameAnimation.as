package com.aspectgaming.game.core
{
	import flash.events.IEventDispatcher;
	import com.aspectgaming.game.iface.IGameModule;

	/**
	 * 游戏动画 
	 * @author Nightmare
	 * 
	 */	
	public interface IGameAnimation extends IGameModule,IEventDispatcher
	{
		function start():void;
		function get isPlaying():Boolean;
		function set data(value:*):void;
		function set content(value:String):void;
		function get content():String;
			
	}
}