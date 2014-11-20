package com.aspectgaming.ui
{
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 修复SimpleButton 移除时 按钮状态不更新的问题 
	 * @author mason.li
	 * 
	 */	
	public class FxSimpleButton extends BaseComponent
	{
		private var _sourceButton:SimpleButton;
		private var _sourceUpStatue:DisplayObject;
		private var _sourceHoverStatue:DisplayObject;
		
		public function FxSimpleButton(button:SimpleButton)
		{
			_sourceButton = button;
			super(button);
		}
		
		override protected function init():void
		{
			_sourceUpStatue = _sourceButton.upState;
			_sourceHoverStatue = _sourceButton.overState;
			super.init();
		}
		
		override protected function addEvent():void
		{
			_sourceButton.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_sourceButton.addEventListener(MouseEvent.ROLL_OVER, onOver);
			_sourceButton.addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		override protected function removeEvent():void
		{
			_sourceButton.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_sourceButton.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			_sourceButton.removeEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(e:Event):void
		{
			_sourceButton.overState = _sourceUpStatue;
		}
		
		private function onOver(e:MouseEvent):void
		{
			_sourceButton.overState = _sourceHoverStatue;
		}
		
		public function show(par:DisplayObjectContainer):void
		{
			par.addChild(_sourceButton);
		}
		
		public function hide():void
		{
			DisplayUtil.removeFromParent(_sourceButton);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_sourceButton = null;
		}
		
	}
}