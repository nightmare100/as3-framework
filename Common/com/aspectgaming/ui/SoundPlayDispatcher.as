package com.aspectgaming.ui
{
	import com.aspectgaming.constant.global.SoundDefine;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 播放音效 鼠标对象
	 * @author mason.li
	 * 
	 */	
	public class SoundPlayDispatcher extends BaseComponent
	{
		private var _isSound:Boolean;
		private var _useFilter:Boolean;
		
		public function SoundPlayDispatcher(o:InteractiveObject, isSound:Boolean = true, useGrayFilter:Boolean = false)
		{
			_isSound = isSound;
			_useFilter = useGrayFilter;
			super(o);
		}
		
		public function get x():Number
		{
			return _interactiveObject.x;
		}
		
		public function get y():Number
		{
			return _interactiveObject.y;
		}

		override protected function addEvent():void
		{
			if (_isSound)
			{
				addEventListener(MouseEvent.CLICK, onMosueHandler);
				addEventListener(MouseEvent.ROLL_OVER, onMosueHandler);
			}
		}
		
		override protected function removeEvent():void
		{
			removeEventListener(MouseEvent.CLICK, onMosueHandler);
			removeEventListener(MouseEvent.ROLL_OVER, onMosueHandler);
		}
		
		protected function onMosueHandler(e:MouseEvent):void
		{
			if (e.type == MouseEvent.CLICK)
			{
				SoundManager.playSound(SoundDefine.SOUND_MOUSE_CLICK);
			}	
			else if (e.type == MouseEvent.ROLL_OVER)
			{
				SoundManager.playSound(SoundDefine.SOUND_MOUSE_OVER);
			}
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if (_useFilter)
			{
				if (enabled)
				{
					DisplayUtil.enableButton(interactiveObject);
				}
				else
				{
					DisplayUtil.disableInterObjectWithDark(interactiveObject);
				}
			}
		}
		
		
	}
}