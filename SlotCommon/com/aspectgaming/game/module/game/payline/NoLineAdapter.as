package com.aspectgaming.game.module.game.payline
{
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.module.game.iface.IPayLine;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class NoLineAdapter implements IPayLine
	{
		public function NoLineAdapter()
		{
		}
		
		public function updateButton(isInit:Boolean=false):void
		{
		}
		
		public function stopLineApi():void
		{
		}
		
		public function showAutoLine(lines:Vector.<LineInfo>):void
		{
		}
		
		public function processReelStop():void
		{
		}
		
		public function addBtnEvent():void
		{
		}
		
		public function set enabled(value:Boolean):void
		{
		}
		
		public function dispose():void
		{
		}
		
		public function show(par:DisplayObjectContainer, x:Number=0, y:Number=0):void
		{
		}
		
		public function getLineObj(idx:uint):DisplayObject
		{
			return null;
		}
		
		public function hideAllLine():void
		{
		}
	}
}