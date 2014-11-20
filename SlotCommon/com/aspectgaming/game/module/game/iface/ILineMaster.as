package com.aspectgaming.game.module.game.iface
{
	import flash.display.DisplayObject;

	public interface ILineMaster
	{
		/**
		 * 取线元件 
		 * @param idx
		 * @return 
		 * 
		 */		
		function getLineObj(idx:uint):DisplayObject;
		
		function hideAllLine():void;
	}
}