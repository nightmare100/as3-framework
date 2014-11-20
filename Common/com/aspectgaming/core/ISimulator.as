package com.aspectgaming.core
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author deve.huang
	 */
	public interface ISimulator
	{
		/**
		 * 打开或关闭作弊界面
		 * 
		 */	
		function callme():void 
		/**
		 * 打开或关闭作弊界面
		 * 
		 */
		function loggerAdd(type:String, obj:*):void
		/**
		 * 打开或关闭作弊界面
		 * 
		 */
		function initEmnulation(emnuStops:XML, baseLen:int):void
		/**
		 * 打开或关闭作弊界面
		 * 
		 */
		function emnuAdvAddCallBack(onHandler:Function):void 
		function emnuAdvRef(xml:XML):void;
		/**
		 * 修改显示的Tips，如版本号
		 * 
		 */
		function changeTips(str:String):void;
	}
}