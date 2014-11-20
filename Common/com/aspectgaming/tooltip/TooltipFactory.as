package com.aspectgaming.tooltip
{
	import com.aspectgaming.tooltip.constant.ToolTipDefined;
	import com.aspectgaming.tooltip.tipskin.BaseTipSkin;
	import com.aspectgaming.tooltip.tipskin.ExternalTipSkin;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	

	/**
	 * 提示UI工厂
	 * @author masonli
	 * 
	 */	
	public class TooltipFactory
	{
		private static var _tooltipDic:Dictionary = new Dictionary();
		private static var _toolCache:Dictionary = new Dictionary();
		
		public function TooltipFactory()
		{
			
		}
		
		public static function addToolTips(key:String, cls:Class):void
		{
			_tooltipDic[key] = cls;
		}
		
		public static function getTipsSkin(type:String,externalMc:MovieClip = null, isSingle:Boolean = false):BaseTipSkin
		{
			var skin:BaseTipSkin;
			switch (type)
			{
				case ToolTipDefined.Tips_External:
					skin = new ExternalTipSkin();
					break;
				default:
					if (isSingle)
					{
						skin = _toolCache[type];
					}
					if (!skin)
					{
						var cls:Class = _tooltipDic[type];
						if (cls)
						{
							skin = new cls();
						}
					}
					
					if (isSingle)
					{
						_toolCache[type] = skin;
					}
					break;
			}
			if (skin)
			{
				skin.setSkin(externalMc);
			}
			
			return skin;
		}

	}
}