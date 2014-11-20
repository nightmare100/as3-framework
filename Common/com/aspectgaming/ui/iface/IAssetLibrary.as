package com.aspectgaming.ui.iface
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public interface IAssetLibrary
	{
		function getDisplayObject(name:String):DisplayObject;
		function getAniObject(name:String, isStop:Boolean = false,index:int=0):MovieClip;
		function getMutiObject(nameList:Array, space:Number = 0):DisplayObject;
		function getSymbloAdvName(name:String):String;
		function getSymbloName(name:String):String;
		function set extraDic(dic:Dictionary):void;
		function processStopAnimation(mc:DisplayObject = null, info:* = null):Boolean;// 是否需要 切换帧 显示。 symbol 显示扩展，mc为symbol对象 info 为需要带入的信息如 lineinfo
	}
}