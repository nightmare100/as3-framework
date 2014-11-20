package com.aspectgaming.ui
{
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.ui.event.ComponentEvent;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	[Event(name="frameChanged",type="com.aspectgaming.ui.event.ComponentEvent")]
	/**
	 * 帧按钮 
	 * @author mason.li
	 * 
	 */	
	public class FrameButton extends BaseComponent
	{
		private var _currentFrame:uint;
		private var _defaultFrame:uint;
		public function FrameButton(mc:InteractiveObject, defaultFrame:uint = 1)
		{
			_defaultFrame = defaultFrame;
			super(mc);
		}
		
		public function get currentFrame():uint
		{
			return _currentFrame;
		}

		override protected function init():void
		{
			_viewComponent.buttonMode = true;
			_viewComponent.gotoAndStop(_defaultFrame);
			_currentFrame = _defaultFrame;
			super.init();
		}
		
		override public function set enabled(value:Boolean):void
		{
			// TODO Auto Generated method stub
			super.enabled = value;
			if (viewComponent)
			{
				if (enabled)
				{
					DisplayUtil.enableSprite(viewComponent);
				}
				else
				{
					DisplayUtil.disableInterObjectWithDark(viewComponent);
				}
			}
		}
		
		
		
		public function setFrame(f:Number):void
		{
			_currentFrame = f;
			_viewComponent.gotoAndStop(_currentFrame);
		}
		
		override protected function addEvent():void
		{
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		override protected function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			_currentFrame = _currentFrame + 1 > _viewComponent.totalFrames ? 1 : (_currentFrame + 1);
			_viewComponent.gotoAndStop(_currentFrame);
			dispatchEvent(new ComponentEvent(ComponentEvent.FRAME_CHANGED, _currentFrame));
		}
	}
}