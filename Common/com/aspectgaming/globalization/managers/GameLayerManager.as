package com.aspectgaming.globalization.managers
{
	import com.aspectgaming.game.iface.INewGame;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.PointUtil;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 游戏层次管理 
	 * @author mason.li
	 * 
	 */	
	public class GameLayerManager
	{
		public static var GAME_WIDTH:Number = 760;
		public static var GAME_HEIGHT:Number = 528;
		
		private static var _gameRect:Rectangle;
		
		private static var _rootPoint:Point;
		private static var _root:Sprite;
		private static var _gameStage:Stage
		private static var _rootRect:Rectangle;
		
		/**
		 * 层次关系   _bglayer = > _gameLayer = > _uilayer => _lowLayer = > _topLayer
		 */
		private static var _uilayer:Sprite;
		private static var _bglayer:Sprite;
		private static var _lowLayer:Sprite;
		private static var _topLayer:Sprite;
		private static var _gameLayer:Sprite;
		
		private static var _simulator:Sprite;
		
		private static var _topChildren:int;
		private static var _focusRect:Rectangle;
		
		public static function get gameLayerRect():Rectangle
		{
			if (!_gameRect)
			{
				_gameRect = new Rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT)
			}
			
			return _gameRect;
		}
		
		public static function get rootPoint():Point
		{
			if (_root)
			{
				_rootPoint = _root.localToGlobal(PointUtil.ZERO_POINT);
			}
			else
			{
				_rootPoint = null;
			}
			
			return _rootPoint;
		}
		
		public static function get focusRect():Rectangle
		{
			if (!_focusRect)
			{
				_focusRect = new Rectangle(rootPoint.x, rootPoint.y, GAME_WIDTH, GAME_HEIGHT);
			}
			
			return _focusRect;
		}

		public static function get gameRoot():INewGame
		{
			return _root as INewGame;
		}
		
		public static function get rootRect():Rectangle
		{
			return _rootRect;
		}

		public static function get gameStage():Stage
		{
			return _gameStage;
		}

		public static function get root():Sprite
		{
			return _root;
		}

		public static function get uilayer():Sprite
		{
			return _uilayer;
		}	
		
		public static function get lowLayer():Sprite
		{
			return _lowLayer;
		}
		
		public static function get gameLayer():Sprite
		{
			return _gameLayer;
		}
		
		public static function get simulator():Sprite
		{
			return _simulator;
		}
		
		/**
		 * 放动画 & gamble 
		 * @return 
		 * 
		 */		
		public static function get topLayer():Sprite
		{
			return _topLayer;
		}
		
		public static function get bglayer():Sprite
		{
			return _bglayer;
		}

		public static function setup(root:Sprite):void
		{
			_root = root;
			_gameStage = _root.stage;
			
			_rootRect = new Rectangle(0, 0, _gameStage.stageWidth, _gameStage.stageHeight);
			
			_bglayer = new Sprite();
			LayerManager.closeTabAndMouse(_bglayer);
			_root.addChild(_bglayer);
			
			_gameLayer = new Sprite();
			LayerManager.closeTabAndMouse(_gameLayer);
			_root.addChild(_gameLayer);
			
			_uilayer = new Sprite();
			LayerManager.closeTabAndMouse(_uilayer);
			_root.addChild(_uilayer);
			
			
			_lowLayer = new Sprite();
			LayerManager.closeTabAndMouse(_lowLayer);
			_root.addChild(_lowLayer);
			
			
			_simulator = new Sprite();
			_root.addChild(_simulator);
			
			_topLayer = new Sprite();
			LayerManager.closeTabAndMouse(_topLayer);
			_root.addChild(_topLayer);
			
			_topLayer.addEventListener(Event.ADDED,onAddedRemoved);
			_topLayer.addEventListener(Event.REMOVED,onAddedRemoved);
		}
		
		public static function dispose():void
		{
			_focusRect = null;
			_root = null;
			_gameStage = null;
			_rootRect = null;
			_rootPoint = null;
			DisplayUtil.removeFromParent(_bglayer);
			DisplayUtil.removeFromParent(_gameLayer);
			DisplayUtil.removeFromParent(_uilayer);
			DisplayUtil.removeFromParent(_lowLayer);
			_topLayer.removeEventListener(Event.ADDED,onAddedRemoved);
			_topLayer.removeEventListener(Event.REMOVED,onAddedRemoved);
			DisplayUtil.removeFromParent(_topLayer);
			_bglayer = null;
			_gameLayer = null;
			_uilayer = null;
			while (_topLayer.numChildren > 0)
			{
				var o:DisplayObject = _topLayer.removeChildAt(0);
				if (o is MovieClip)
				{
					MovieClip(o).stop();
				}
				DisplayUtil.removeFromParent(o);
			}
			_topLayer = null;
			_topChildren = 0;
			GAME_WIDTH = 760;
			GAME_HEIGHT = 528;
		}
		
		private static function onAddedRemoved(event:Event):void
		{
			if((event.target as DisplayObject).parent == _topLayer)
			{
				if(event.type == Event.ADDED)
				{
					_topChildren++;
				}
				else if(event.type == Event.REMOVED)
				{
					_topChildren--;
				}

				if(_topChildren > 0)
				{
					_bglayer.mouseEnabled = false;
					_bglayer.mouseChildren = false;
					_uilayer.mouseEnabled = false;
					_uilayer.mouseChildren = false;
					
					_gameLayer.mouseEnabled = false;
					_gameLayer.mouseChildren = false;
				}
				else
				{
					_bglayer.mouseEnabled = true;
					_bglayer.mouseChildren = true;
					_uilayer.mouseEnabled = true;
					_uilayer.mouseChildren = true;
					
					_gameLayer.mouseEnabled = true;
					_gameLayer.mouseChildren = true;
				}
			}
		}
	}
}