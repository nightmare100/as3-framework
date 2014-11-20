package com.aspectgaming.game.iface
{
	public interface IErrorParse
	{
		/**
		 * 系统错误 
		 * @param isServerError 是否为服务器错误 或者 加载错误
		 * 
		 */		
		function parseSystemError(isServerError:Boolean):void;
		
		/**
		 * 处理游戏错误 
		 * @param code
		 * 
		 */		
		function parseGameError(code:uint):void;
	}
}