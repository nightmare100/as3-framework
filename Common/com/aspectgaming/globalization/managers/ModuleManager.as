package com.aspectgaming.globalization.managers
{
	import com.aspectgaming.globalization.module.LifeCycle;
	import com.aspectgaming.globalization.module.ModuleProxy;
	import com.aspectgaming.globalization.module.ModuleStatue;
	import com.aspectgaming.ui.event.ModuleEvent;
	import com.aspectgaming.ui.iface.IModule;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.LoggerUtil;
	import com.aspectgaming.utils.constant.LogType;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * 模块管理  
	 * 所有模块都为单列
	 * @author mason.li
	 * 
	 */	
	public class ModuleManager
	{
		private static var _eventDispatcher:EventDispatcher;
		
		private static var _gameModule:IEventDispatcher;
		
		private static var _dic:Dictionary = new Dictionary();
		
		public static function get gameModule():IEventDispatcher
		{
			return _gameModule;
		}

		public static function set gameModule(value:IEventDispatcher):void
		{
			_gameModule = value;
		}
		
		public static function dispatchToGame(event:Event):void
		{
			if (_gameModule)
			{
				_gameModule.dispatchEvent(event);
				LoggerUtil.logServer(event, LogType.LOG_SEND_TO_GAME);
			}
		}
		
		public static function dispatchToLobby(event:Event):void
		{
			if (_gameModule)
			{
				_gameModule.dispatchEvent(event);
				LoggerUtil.logServer(event, LogType.LOG_SEND_TO_LOBBY);
			}
		}

		/**
		 * 显示模块 
		 * @parm key 使用string 作为关键字 调用模块  增强代理性   当CLS 为null 此路径为需要加载的路径
		 * @param par
		 * @param x
		 * @param y
		 * @param align
		 * @param cls 	Class 或 实例 第一次加载的模块必须带此项 
		 */		
		public static function showModule(key:String, par:DisplayObjectContainer, x:Number = 0, y:Number = 0, align:int = -1, cls:* = null, data:* = null):void
		{
			if (!_dic[key])
			{
				if (cls == null)
				{
					//当此实例为空 表示key为Swf
					var tempProxy:ModuleProxy = new ModuleProxy(key, key);
					_dic[key] = tempProxy;
					tempProxy.show(par, x, y, align, data);
					dispatchEvent(new ModuleEvent(ModuleEvent.MODULE_START_LOAD));
					return;
				}
				
				var isClass:Boolean = cls is Class;
				var proxy:ModuleProxy = isClass ? new ModuleProxy(new cls(), key) : (new ModuleProxy(cls, key));
				_dic[key] = proxy;
			}
			ModuleProxy(_dic[key]).show(par, x, y, align, data);
		}
		
		/**
		 * 预加载某个模块资源 
		 * @param key
		 * 
		 */		
		public static function preLoadModule(key:String):void
		{
			if (!_dic[key])
			{
				var tempProxy:ModuleProxy = new ModuleProxy(key, key);
				_dic[key] = tempProxy;
				tempProxy.preLoad();
			}
			ModuleProxy(_dic[key]).preLoad();
		}
		
		/**
		 * 直接注册一个模块代理 
		 * @param key  模块KEY
		 * @param cls  模块CLASS
		 * 
		 */		
		public static function registerModule(key:String, cls:Class):void
		{
			if (!_dic[key])
			{
				var proxy:ModuleProxy = new ModuleProxy(cls, key);
				_dic[key] = proxy;
			}
		}
		
		/**
		 * 模块是否显示  
		 * @param key
		 * @return 
		 * 
		 */		
		public static function isModuleInShow(key:String):Boolean
		{
			if (_dic[key])
			{
				return ModuleProxy(_dic[key]).statue == ModuleStatue.SHOW;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 获取模块单列 
		 * @return 
		 * 
		 */		
		public static function getModule(key:String):IModule
		{
			if (_dic[key])
			{
				return ModuleProxy(_dic[key]).module;
			}
			else
			{
				return null;
			}
		}
		
		public static function getModuleProxy(key:String):ModuleProxy
		{
			return _dic[key];
		}
		
		public static function hideModule(key:String):void
		{
			if (_dic[key])
			{
				ModuleProxy(_dic[key]).hide();
			}
		}
		
		/**
		 * 单独销毁某个模块 
		 * @param cls Class 或 key
		 * 
		 */		
		public static function disposeModule(key:String):void
		{
			if (_dic[key])
			{
				ModuleProxy(_dic[key]).dispose();
			}
		}
		
		/**
		 * 根据生命周期类型 销毁模块 
		 * 
		 */		
		public static function disposeModuleByLifeCycle(type:String):void
		{
			for (var key:String in _dic)
			{
				if (_dic[key])
				{
					if (type == LifeCycle.ALL_CYCLE || ModuleProxy(_dic[key]).lifeCycle == type)
					{
						ModuleProxy(_dic[key]).dispose();
					}
				}
			}
		}
		
		/**
		 * 销毁游戏模块 
		 * 
		 */		
		public static function disposeGameModule():void
		{
			if (_gameModule)
			{
				DisplayUtil.removeFromParent(_gameModule as DisplayObject);
				Object(_gameModule).dispose();
				_gameModule = null;
			}
		}
		
		//*******************************************
		
		
		public static function get eventDispatcher():EventDispatcher
		{
			if (!_eventDispatcher)
			{
				_eventDispatcher = new EventDispatcher();
			}
			return _eventDispatcher;
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:uint = 0, useWeakRef:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakRef);
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			eventDispatcher.removeEventListener(type, listener);
		}
		
		public static function dispatchEvent(evt:Event):void
		{
			if (hasEventListener(evt.type))
			{
				eventDispatcher.dispatchEvent(evt);
			}
		}
		
		private static function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
	}
}