package com.aspectgaming.animation.iface
{
	import flash.events.IEventDispatcher;

	/**
	 * 动画元件接口 
	 * @author mason.li
	 * 
	 */	
	public interface IAnimation extends IEventDispatcher
	{
		function start():void;
		function restart():void;
		function stop():void;
		function gotoAndStop(frame:uint):void;
		function gotoAndPlay(frame:uint):void;
		function get currentFrame():uint;
		function set playTimes(times:int):void;
		function get currentRound():uint;
		function get isLoop():Boolean;
		
		/**
		 * 动画宏定义 
		 * @return 
		 * 
		 */		
		function get type():String;
		
		/**
		 * 添加帧事件 
		 * @param m
		 * @param callBack
		 * 
		 */		
		function addFrameScript(m:uint, callBack:Function):void;
		
		function clearFrameScript():void;
		
		function dispose():void;
		
		function hide():void;
	}
}