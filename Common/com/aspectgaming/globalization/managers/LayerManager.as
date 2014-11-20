package com.aspectgaming.globalization.managers 
{
    import com.aspectgaming.core.ILobby;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;

	/**
	 * 显示层管理
	 * @author Mason.Li
	 */
	public class LayerManager 
	{
		public static const ZERO_POINT:Point = new Point(0, 0);
		public static var stageWidth:Number = 954;
		public static var stageHeight:Number = 819;
		
		private static var _root:Sprite;
		private static var _stage:Stage;
		private static var _rootRect:Rectangle;
		private static var _lobby:ILobby;
		
		private static var _uiLayer:LayerSprite;
		private static var _moduleLayer:LayerSprite;
		private static var _lowerLayer:LayerSprite;
		private static var _noticeLayer:LayerSprite;
		private static var _topLayer:LayerSprite;
		
		public static function set stage(value:Stage):void
		{
			_stage = value;
		}

		/**
		 *  层次由上 ->   下 _topLayer  _noticeLayer  _lowerLayer   _moduleLayer  _uiLayer
		 * @param	root
		 */
		public static function setup(root:Sprite):void
		{
			_lobby = root as ILobby;
			_root = root;
			_stage = _root.stage;
			_rootRect = new Rectangle(0, 0, _stage.stageWidth, _stage.stageHeight);
			
			
			_uiLayer = new LayerSprite();
			closeTabAndMouse(_uiLayer);
			_root.addChild(_uiLayer);
			
			_moduleLayer = new LayerSprite();
			closeTabAndMouse(_moduleLayer);
			_root.addChild(_moduleLayer);
			
			_lowerLayer = new LayerSprite();
			closeTabAndMouse(_lowerLayer);
			_root.addChild(_lowerLayer);
			
			_noticeLayer = new LayerSprite();
			closeTabAndMouse(_noticeLayer);
			_root.addChild(_noticeLayer);
			
			_noticeLayer.addEventListener(Event.ADDED,onAddedRemoved);
			_noticeLayer.addEventListener(Event.REMOVED,onAddedRemoved);
			
			_topLayer = new LayerSprite();
			closeTabAndMouse(_topLayer);
			_root.addChild(_topLayer);
		}
		
		public static function get stage():Stage
		{
			return _stage;
		}
		public static function get root():Sprite
		{
			return _root;
		}
		public static function get rootRect():Rectangle
		{
			return _rootRect;
		}
		
		public static function get uiLayer():Sprite
		{
			return _uiLayer;
		}
		
		public static function get moduleLayer():Sprite
		{
			return _moduleLayer;
		}
		
		public static function get lowerLayer():Sprite
		{
			return _lowerLayer;
		}
		
		public static function get noticeLayer():Sprite
		{
			return _noticeLayer;
		}
		
		public static function get topLayer():Sprite
		{
			return _topLayer;
		}
		
		static public function get lobby():ILobby 
		{
			return _lobby;
		}
		
		public static function closeTabAndMouse(sprite:Sprite):void
		{
			sprite.tabChildren = false;
			sprite.tabEnabled = false;
			sprite.mouseEnabled = false;
		}
		
		private static var _noticeChildren:int = 0;
		
		/**
		 * 消息层消息 自动锁定其它层
		 * @param	event
		 */
		private static function onAddedRemoved(event:Event):void
		{
			if((event.target as DisplayObject).parent == _noticeLayer)
			{
				if(event.type == Event.ADDED)
				{
					_noticeChildren++;
				}
				else if(event.type == Event.REMOVED)
				{
					_noticeChildren--;
				}
				//
				if(_noticeChildren > 0)
				{
				    _lowerLayer.stairLock = true;
					_uiLayer.stairLock = true;
					_moduleLayer.stairLock = true;
				}
				else
				{
				    _lowerLayer.stairLock = false;
					_uiLayer.stairLock = false;
					_moduleLayer.stairLock = false;
				}
			}
		}
		
	}

}

import flash.display.Sprite;

class LayerSprite extends Sprite
{
	private var _stairLock:Boolean;
	private var _secondaryLock:int;
	
	public function resetSecondaryLock():void
	{
		_secondaryLock = 0;
		if(_stairLock == false)
		{
			mouseChildren = true;
		}
	}
	/**
	 * 设置一级锁定
	 * @param value
	 * 
	 */	
	public function set stairLock(value:Boolean):void
	{
		_stairLock = value;
		if(_stairLock)
		{
			mouseChildren = false;
		}
		else
		{
			if(_secondaryLock == 0)
			{
				mouseChildren = true;
			}
		}
	}
	
	/**
	 * 设置二级锁定
	 * @param value
	 * 
	 */	
	public function set secondaryLock(value:Boolean):void
	{
		if(value)
		{
			_secondaryLock++;
		}
		else
		{
			_secondaryLock--;
			if(_secondaryLock < 0)
			{
				_secondaryLock = 0;
			}
		}
		if(_secondaryLock > 0)
		{
			mouseChildren = false;
		}
		else
		{
			if(_stairLock == false)
			{
				mouseChildren = true;
			}
		}
	}
}