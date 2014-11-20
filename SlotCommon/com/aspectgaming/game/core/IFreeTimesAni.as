package com.aspectgaming.game.core
{
	
	/**
	 * FreeGame 倍率动画接口 
	 * @author mason.li
	 * 
	 */	
	public interface IFreeTimesAni
	{
		/**
		 * 回合更新 
		 * @param round
		 * 
		 */		
		function update(round:uint, playSound:Boolean = true, playAnimation:Boolean = true):void;
		
		function show():void;
		
		function hide():void;
		
		function dispose():void;
		
		function updateAfterReelStop(hasWin:Boolean):void;
	}
}