package com.aspectgaming.game.core
{
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.module.game.iface.ILineMaster;
	import com.aspectgaming.game.iface.IGameModule;

	/**
	 * WinShow模块接口 
	 * @author mason.li
	 * 
	 */	
	public interface IWinShow extends IGameModule
	{
		function showWinLine(lines:Vector.<LineInfo>, totalWin:Number, needAutoShow:Boolean = true):void;
		function set lineMaster(value:ILineMaster):void;
		function stop():void;
	}
}