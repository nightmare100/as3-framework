package com.aspectgaming.game.module.game.payline
{
	import com.aspectgaming.ui.base.BaseComponent;
	import com.greensock.TweenLite;
	
	import flash.display.InteractiveObject;
	
	public class SimpleLine extends BaseComponent
	{
		private var _callBack:Function;
		
		public function SimpleLine(mc:InteractiveObject)
		{
			super(mc);
		}
		
		override protected function init():void
		{
			_viewComponent.visible = false
			super.init();
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			_viewComponent.alpha = 1;
			TweenLite.killTweensOf(_viewComponent);
		}
		
		public function fadeOut(delay:Number, cb:Function = null):void
		{
			_callBack = cb;
			TweenLite.to(_viewComponent, 0.3, {alpha:0, onComplete:fadeOutComplete, delay:delay});
		}
		
		private function fadeOutComplete():void
		{
			visible = false;
			if (_callBack != null)
			{
				_callBack();
				_callBack = null;
			}
		}
		
		override public function dispose():void
		{
			TweenLite.killTweensOf(_viewComponent);
			super.dispose();
		}
		
	}
}