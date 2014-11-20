package com.aspectgaming.ui.iface
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.core.IModuleContext;

	/**
	 * 模块接口 
	 * @author mason.li
	 * 
	 */	
	public interface IModule extends IEventDispatcher
	{
		function set parentInjector(value:IInjector):void
		function show(par:DisplayObjectContainer, x:Number = 0, y:Number = 0):void;
		function init(data:*):void;
		function addChild(child:DisplayObject):DisplayObject;
		function addChildAt(child:DisplayObject, index:int):DisplayObject;
		function hide():void;
		function dispose():void;
		function get context():IModuleContext;
		function set enabled(value:Boolean):void;
		function get enabled():Boolean;
		function get lifeCycle():String;
		function set moduleName(name:String):void;
		function get moduleName():String;
		function get selfClass():Class;
		function get x():Number;
		function get y():Number;
			
	}
}