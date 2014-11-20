package com.aspectgaming.utils
{
	import com.aspectgaming.utils.geom.ColorMatrix;
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;

	/**
	 * 滤镜 
	 * @author mason.li
	 * 
	 */	
	public class FiltersUtil
	{
		public static const BLUR_FILTER:BlurFilter = new BlurFilter(4, 4, BitmapFilterQuality.HIGH);
		public static const BLUR_FILTER_HIGH:BlurFilter = new BlurFilter(10, 10, BitmapFilterQuality.HIGH);
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter(
			[0.3086, 0.6094, 0.0820, 0, 0,
				0.3086, 0.6094, 0.0820, 0, 0,
				0.3086, 0.6094, 0.0820, 0, 0,
				0,      0,      0,      1, 0]
		);
		
		public static const NORMAL_GLOWFILTER:GlowFilter = new GlowFilter(0x000000, 1, 8, 8, 1.5);
		
		public static const BRIGHT_FILTER:ColorMatrixFilter = getBrightFilter();
		
		public static const DARK_FILTER:ColorMatrixFilter = getDarkFilter();
		
		public static const EQUIP_BRIGHT_FILTER:ColorMatrixFilter = getEquipFilter();
		
		public static const EQUIP_SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(2, 90, 0x737373, 0.5, 2, 2, 2);
		
		private static function getBrightFilter():ColorMatrixFilter
		{
			var cm:ColorMatrix = new ColorMatrix();
			cm.adjustColor( -25, 8, -70, 180);
			return new ColorMatrixFilter(cm);
		}
		
		private static function getEquipFilter():ColorMatrixFilter
		{
			var cm:ColorMatrix = new ColorMatrix();
			cm.adjustColor( 20, 10,0, 0);
			return new ColorMatrixFilter(cm);
		}
		
		private static function getDarkFilter():ColorMatrixFilter
		{
			var cm:ColorMatrix = new ColorMatrix();
			cm.adjustBrightness(-75);
			return new ColorMatrixFilter(cm);
		}
			
		public static function colorTransform(component:DisplayObject, color:int):void
		{
			if (color < 16777216) 
			{
				component.transform.colorTransform = new ColorTransform(0, 0, 0, 1, color >>> 16 & 0xFF, color >>> 8 & 0xFF, color & 0xFF);
			} 
			else 
			{
				//alpha通道
				component.transform.colorTransform = new ColorTransform(0, 0, 0, 0, color >>> 16 & 0xFF, color >>> 8 & 0xFF, color & 0xFF, color >>> 24);
			}
		}
	}
}