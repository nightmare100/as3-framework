package com.aspectgaming.ui
{
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.ui.event.RadioEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 单选按钮 
	 * @author mason.li
	 * 
	 */	
	[Event(name="radioSelected", type="com.aspectgaming.ui.event.RadioEvent")]
	public class RadioButton extends SoundPlayDispatcher
	{
		protected var _checkBox:MovieClip;
		protected var _selected:Boolean;
		protected var _index:uint;
		
		/**
		 * 构造函数 
		 * @param mc 为MovieClip 或 SoundPlayDispatcher
		 * 
		 */		
		public function RadioButton(mc:*, isSoundPlay:Boolean = false)
		{
			super(mc, isSoundPlay);
		}

		public function get index():uint
		{
			return _index;
		}

		public function set index(value:uint):void
		{
			_index = value;
		}

		override protected function init():void
		{
			_checkBox = _viewComponent["checkBox"];
			_checkBox.gotoAndStop(1);
			_viewComponent.buttonMode = true;
			super.init();
		}
		
		override protected function addEvent():void
		{
			_viewComponent.addEventListener(MouseEvent.CLICK, onClick);
			super.addEvent();
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			_checkBox.gotoAndStop(value ? 2 : 1);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		protected function onClick(e:MouseEvent):void
		{
			if (!selected)
			{
				selected =  true;
				dispatchEvent(new RadioEvent(RadioEvent.RADIO_SELECTED, _index));
			}
		}
		
		override public function dispose():void
		{
			_checkBox = null;
			super.dispose();
		}
		
		override protected function removeEvent():void
		{
			_viewComponent.removeEventListener(MouseEvent.CLICK, onClick);
			super.removeEvent();
		}
		
		
	}
}