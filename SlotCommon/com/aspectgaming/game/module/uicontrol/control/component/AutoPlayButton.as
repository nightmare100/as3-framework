package com.aspectgaming.game.module.uicontrol.control.component
{
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.module.game.iface.IAutoPlay;
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	[Event(name="autoPlayChanged",type="com.aspectgaming.game.event.SlotUIEvent")]
	[Event(name="autoInChoose",type="com.aspectgaming.game.event.SlotUIEvent")]
	public class AutoPlayButton extends BaseComponent implements IAutoPlay
	{
		private const BTN_X:String = "btnX";
		private var _inStatueView:MovieClip;
		private var _chooseView:MovieClip;
		
		public function AutoPlayButton(mc:InteractiveObject, inStatueView:MovieClip, chooseView:MovieClip)
		{
			_inStatueView = inStatueView;
			_chooseView = chooseView;
			super(mc);
		}
		
		override protected function init():void
		{
			_inStatueView.visible = false;
			_chooseView.visible = false;
			super.init();
		}
		
		override protected function addEvent():void
		{
			addEventListener(MouseEvent.CLICK, onClick);
			_chooseView.addEventListener(MouseEvent.CLICK, onChooseClick);
		}
		
		override protected function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK, onClick);
			_chooseView.removeEventListener(MouseEvent.CLICK, onChooseClick);
		}
		
		public function reset():void
		{
			visible = true;
			_inStatueView.visible = false;
			_chooseView.visible = false;
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (_chooseView.visible)
			{
				_chooseView.visible = false;
				dispatchEvent(new SlotUIEvent(SlotUIEvent.AUTO_IN_CHOOSE, false));
			}
			else
			{
				_chooseView.visible = true;
				dispatchEvent(new SlotUIEvent(SlotUIEvent.AUTO_IN_CHOOSE, true));
			}
		}
		
		public function get isInChoose():Boolean
		{
			return _chooseView.visible;
		}
		
		private function onChooseClick(e:MouseEvent):void
		{
			var target:DisplayObject = e.target as DisplayObject;
			if (target.name && target.name.indexOf(BTN_X) != -1)
			{
				var clickNum:uint = uint(target.name.substr(BTN_X.length));
				_chooseView.visible = false;
				visible = false;
				
				_inStatueView["_txt"].text = (clickNum - 1).toString();
				_inStatueView.visible = true;
				dispatchEvent(new SlotUIEvent(SlotUIEvent.AUTO_PLAY_CHANGED, clickNum));
			}
		}
		
		public function updateTimes(n:uint):void
		{
			if (n - 1 <= 0)
			{
				reset();
			}
			else
			{
				_inStatueView["_txt"].text = (n - 1).toString();
			}
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if (enabled)
			{
				DisplayUtil.enableButton(interactiveObject as SimpleButton);
			}
			else
			{
				DisplayUtil.disableInterObjectWithDark(interactiveObject);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		
	}
}