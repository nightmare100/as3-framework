package com.aspectgaming.game.module.game.iface
{
	import com.aspectgaming.game.data.winshow.LineInfo;
	
	import flash.display.DisplayObjectContainer;

	public interface IPayLine extends ILineMaster
	{
		function updateButton(isInit:Boolean = false):void;

		function stopLineApi():void;
		
		function showAutoLine(lines:Vector.<LineInfo>):void;
			
		function processReelStop():void;
		
		function addBtnEvent():void;
		
		function set enabled(value:Boolean):void;
		
		function dispose():void;
		function show(par:DisplayObjectContainer, x:Number=0, y:Number=0):void;
	}
}