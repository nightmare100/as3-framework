package com.aspectgaming.tooltip
{
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * 提示管理 
	 * @author mason.li
	 * 
	 */	
	public class TooltipManager
	{		
		public static const FIX_LAYER_NAME:String = "FixLay";
		private static var _toolTip:BaseTooltip = new BaseTooltip();
		
		/**
		 * 显示一个固定提示 直接显示 
		 * @param target    鼠标对象
		 * @param type      提示定义
		 * @param tip		
		 * @param offset	坐标浮动 默认为居中对齐
		 * @param data
		 * 
		 */			
		public static function showFixToolTip(target:InteractiveObject, type:String, tip:String = "", externalMc:MovieClip = null, data:* = null, offset:Point = null):void
		{
			if (!_toolTip.hasToolTip(target, true))
			{
				_toolTip.addFixTip(target, tip, TooltipFactory.getTipsSkin(type, externalMc), data, offset);
			}
			else
			{
				_toolTip.showFixTip(target);
			}
		}
		
		/**
		 * 添加一个浮动提示  鼠标滑过显示 
		 * @param target
		 * @param type
		 * @param tip
		 * @param offset
		 * @param data
		 * @param useMouseScroll  是否跟随鼠标移动
		 * 
		 */			
		public static function addFloatToolTip(target:InteractiveObject, type:String, tip:String = "", useMouseScroll:Boolean = false, externalMc:MovieClip = null, data:* = null, offset:Point = null):void
		{
			if (!_toolTip.hasToolTip(target))
			{
				_toolTip.add(target, tip, TooltipFactory.getTipsSkin(type, externalMc), data, useMouseScroll, offset);
			}
		}
		
		/**
		 * 移除所有提示和事件 
		 * @param target
		 * 
		 */		
		public static function remove(target:InteractiveObject):void
		{
			_toolTip.remove(target);
		}
		public static function removeFixToolTip(target:InteractiveObject):void
		{
			_toolTip.removefixMap(target);
		}
		
	}
}