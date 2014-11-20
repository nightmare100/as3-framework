package com.aspectgaming.tooltip.tipskin
{
	
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.MovieClip;

	public class ExternalTipSkin extends BaseTipSkin
	{
		
		public function ExternalTipSkin()
		{
			super();
		}
		
		override public function setSkin(mc:MovieClip):void
		{
			super.setSkin(mc);
			_tipSkin.y = 5;
			_tipTxt = _tipSkin["tipTxt"];
		}
		
		override public function show(tip:String = null, obj:*=null):void
		{
			if (_tipTxt)
			{
				_tipTxt.text = tip + "";
			}
			LayerManager.topLayer.addChild(this);
		}
	}
}