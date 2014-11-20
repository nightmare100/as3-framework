package com.aspectgaming.ui.iface
{
	import flash.geom.Point;
	
	/**
	 * 运动元件接口 
	 * @author mason.li
	 * 
	 */	
	public interface IMovement
	{
		/**
		 * 直线运动 
		 * 
		 */		
		function moveLine(endPoint:Point, startPoint:Point = null, duration:Number = 0, onComplete:Function = null, onUpdate:Function = null):void;
		
		/**
		 * 曲线运动 
		 * 
		 */		
		function moveParabola(endPoint:Point, isUp:Boolean, startPoint:Point = null, power:uint = 4, duration:Number = 0, autoRotation:Boolean = true, onComplete:Function = null, onUpdate:Function = null):void;
		
		/**
		 * 移动速度 
		 * @param n
		 * 
		 */		
		function set movieSpeed(n:Number):void;
		function get movieSpeed():Number;
	}
}