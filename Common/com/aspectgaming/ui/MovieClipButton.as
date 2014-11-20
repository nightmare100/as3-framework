package com.aspectgaming.ui
{
	import com.aspectgaming.constant.global.SoundDefine;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.ui.base.BaseComponent;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	public class MovieClipButton extends SoundPlayDispatcher
	{
		public function MovieClipButton(mc:MovieClip, useSound:Boolean = true) 
		{
			super(mc, useSound);
		}
		
		override protected function init():void
		{
			_viewComponent.buttonMode = true;
			_viewComponent.mouseChildren = false;
			_viewComponent.tabEnabled = false;
			_viewComponent.gotoAndStop("up");
			super.init();
		}
		
		override protected function addEvent():void
		{
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			super.addEvent();
		}
		
		override protected function removeEvent():void
		{
			
			removeEventListener(MouseEvent.ROLL_OVER, onOver);
			removeEventListener(MouseEvent.ROLL_OUT, onOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			super.removeEvent();
		}
		
		/**
		 * 重置状态 
		 * 
		 */		
		public function resetStatue():void
		{
			if (_viewComponent)
			{
				_viewComponent.gotoAndStop("up");
			}
		}
		
		
		private function onOver(event:MouseEvent):void 
		{
			if (!enabled) 
			{	
				return;
			}
			
			_viewComponent.gotoAndPlay("over");
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if (value)
			{
				_viewComponent.gotoAndStop("up");
				DisplayUtil.enableSprite(_viewComponent);
			}
			else
			{
				try
				{
					_viewComponent.gotoAndStop("disable");
					DisplayUtil.disableSprite(_viewComponent, false);
				}
				catch (e:Error)
				{
					_viewComponent.gotoAndStop("up");
					DisplayUtil.disableSprite(_viewComponent);
				}
			}
		}
		
		
		private function onOut(event:MouseEvent):void 
		{
			if(!enabled)
			{
				return
			}
			try
			{
				_viewComponent.gotoAndPlay("out");
			}
			catch (e:Error)
			{
				_viewComponent.gotoAndStop("up");
			}
		}
		private function onDown(event:MouseEvent):void 
		{
			if (!enabled) 
			{
				return;
			}
			try 
			{
				_viewComponent.gotoAndStop("down");
			}
			catch (e:Error)
			{
				_viewComponent.gotoAndStop("up");
			}
		}
	}
	
}