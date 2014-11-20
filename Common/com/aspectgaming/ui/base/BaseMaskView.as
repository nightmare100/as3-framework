package com.aspectgaming.ui.base
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.ui.event.ComponentEvent;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObjectContainer;

	public class BaseMaskView extends BaseView
	{
		public function BaseMaskView()
		{
			super();
		}
		
		override protected function initView():void
		{
			super.initView();
			renderMask();
		}
		
		protected function renderMask():void
		{
			this.graphics.clear();
		}
		
		
		override public function show(layer:DisplayObjectContainer=null, alignType:int = 4):void
		{
			if (layer)
			{
				if (!_isInit)
				{
					initView();
				}
				layer.addChild(this);
				DisplayUtil.align(this, alignType, layer.getBounds(LayerManager.stage));
				DisplayUtil.align(_mc, alignType, this.parent.getBounds(LayerManager.stage));
				initData();
				dispatchEvent(new ComponentEvent(ComponentEvent.SHOW));
			}
		}
		
		protected function initData():void
		{
			
		}
		
		
	}
}