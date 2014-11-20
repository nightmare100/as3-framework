package com.aspectgaming.ui
{
	import com.aspectgaming.ui.base.BaseComponent;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	/**
	 * 公用进度条  
	 * @author mason.li
	 * 
	 */	
	public class SimpleProgressBar extends BaseComponent
	{
		protected var _rect:Rectangle;
		protected var _fixWidth:Number;
		protected var _fixHeight:Number;
		
		public function SimpleProgressBar(mc:MovieClip)
		{
			_fixWidth = mc.width;
			_fixHeight = mc.height;
			super(mc);
		}
		
		override protected function init():void
		{
			_rect = new Rectangle(0, 0, 0, _viewComponent.height);
			_viewComponent.scrollRect = _rect;
			
			super.init();
		}
		
		
		
		override public function set data(value:*):void
		{
			// TODO Auto Generated method stub
			super.data = value;
			update();
		}

		public function get progress():int
		{
			return int(data);
		}
		
		protected function update():void
		{
			_rect.width = progress / 100 * _fixWidth;
			_viewComponent.scrollRect = _rect;
		}
		
	}
}