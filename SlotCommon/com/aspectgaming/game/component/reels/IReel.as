package com.aspectgaming.game.component.reels
{
	import com.aspectgaming.game.config.reel.ReelInfo;
	import com.aspectgaming.game.config.reel.SpeedInfo;
	import com.aspectgaming.game.data.reel.ReelAction;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	/**
	 * 轮子接口 
	 * @author mason.li
	 * 
	 */	
	public interface IReel extends IEventDispatcher
	{
		function show(par:DisplayObjectContainer):void;
		function setup(reelInfo:ReelInfo, spdInfo:SpeedInfo):void;
		function start(reelIndex:uint):void;
		function stop(isAutoStop:Boolean = false):void;
		function setRules(rules:Vector.<ReelAction>):void;
		function set defaultSymbol(list:Array):void;
		
		function set speedInfo(info:SpeedInfo):void;
		function changeSpeedInfoForever(info:SpeedInfo):void
		
		function set rollDirection(value:String):void;
		function set showListIds(value:Array):void;
		
		function get showListIds():Array;
		function get reelName():String;
		function get reelIndex():uint;
		function get reelInfo():ReelInfo;
		function get isRolling():Boolean;
		function getCurrentDisplayObject(idx:uint):DisplayObject;
		function onGameModeChanged():void;
		function dispose():void;
	}
}