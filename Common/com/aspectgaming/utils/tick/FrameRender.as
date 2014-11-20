package com.aspectgaming.utils.tick
{
	import com.aspectgaming.globalization.managers.LayerManager;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * 帧渲染器 
	 * @author mason.li
	 * 
	 */	
	public class FrameRender
	{
		public static function hasRender(func:Function):Boolean
		{
			return getInstance().hasRender(func);
		}
		
		public static function addRender(func:Function):void
		{
			getInstance().addRender(func);
		}
		
		public static function removeRender(func:Function):void
		{
			getInstance().removeRender(func);
		}
		
		public static function pause():void
		{
			getInstance().pause();
		}
		
		public static function unpause():void
		{
			getInstance().unpause();
		}
		
		public static function dispose():void
		{
			getInstance().dispose();
		}
		
		private static var _instance:FrameRender;
		private static function getInstance():FrameRender
		{
			if (!_instance)
			{
				_instance = new FrameRender();
			}
			return _instance;
		}
		
		public function FrameRender()
		{
			_rendList = new Dictionary();
		}
		
		public function addRender(func:Function, fps:int = 0):void
		{
			_rendList[func] = fps;
			checkEvent();
		}
		
		public function hasRender(func:Function):Boolean
		{
			return _rendList[func];
		}
		
		public function removeRender(func:Function):void
		{
			delete _rendList[func];
		}
		
		public function pause():void
		{
			_isPause = true;
			LayerManager.stage.removeEventListener(Event.ENTER_FRAME, onRender);
		}
		
		public function unpause():void
		{
			_isPause = false;
			LayerManager.stage.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		public function dispose():void
		{
			pause();
			_rendList = null;
		}
		
		public function get renderLength():uint
		{
			var i:uint = 0;
			for (var key:* in _rendList)
			{
				i++;
			}
			return i;
		}
		
		private function checkEvent():void
		{
			if (!_isPause)
			{
				LayerManager.stage.addEventListener(Event.ENTER_FRAME, onRender);
			}
		}
		
		private function onRender(e:Event):void
		{
			if (renderLength == 0)
			{
				LayerManager.stage.removeEventListener(Event.ENTER_FRAME, onRender);
				_currentFrame = 0;
				return;
			}
			
			for (var func:* in _rendList)
			{
				if (func != null && func is Function)
				{
					func();
				}
			}
			_currentFrame++;
		}
		
		private var _rendList:Dictionary;
		
		/**
		 * 当前帧 
		 */		
		private var _currentFrame:Number = 0;
		
		private var _isPause:Boolean;
	}
}