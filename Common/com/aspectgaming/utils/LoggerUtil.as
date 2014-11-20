package com.aspectgaming.utils
{
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.net.mapping.ClassRegister;
	import com.aspectgaming.ui.iface.ILogView;
	
	import flash.events.KeyboardEvent;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	import flash.utils.ByteArray;
	
	/**
	 * 日志辅助 
	 * @author mason.li
	 * 
	 */	
	public class LoggerUtil
	{
		public static var enabled:Boolean = true;
		
		public static const TAG_COLOR_ORANGE:uint = 0xDD3300;
		public static const TAG_COLOR_GREEN:uint = 0x005000;
		
		/**
		 * 日志数量 (行)
		 */		
		private static const MAX_CACHE_LINE:uint = 2000;
		private static var _logCache:Array;
		
		private static var _logView:ILogView;

		public static function setupView(view:ILogView):void
		{
			LayerManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_logView = view;
		}
		
		public static function clear():void
		{
			_logCache.length = 0;
			_logView.update(logCache);
		}
		
		private static function onKeyDown(e:KeyboardEvent):void
		{
			
			if (e.ctrlKey && e.keyCode == Keyboard.Y)
			{
				_logView.show(LayerManager.topLayer);
			}
		}
		
		public static function get logCache():Array
		{
			if (!_logCache)
			{
				_logCache = [];
			}
			return _logCache;
		}

		public static function logServer(o:*, serverType:String, statue:String = ""):void
		{
			logWithTab(getLogTag(serverType, statue));
			if (o)
			{
				logWithTab(o, 0);
				logObject(classToObject(o));
			}
			logWithTab(getLogTag(serverType, statue, true));
		}
		
		public static function logNormal(tagName:String, o:* = null):void
		{
			logWithTab(getLogTag(tagName, ""));
			if (o)
			{
				logObject(o);
			}
		}
		
		private static function getLogTag(sType:String, statue:String, isEnd:Boolean = false):String
		{
			return "[----- " + sType + " " + statue + (isEnd?" End":"") + " -----]";
		}
		
		private static function logObject(o:*, logTimes:uint = 0):void
		{
			if (o is Function)
			{
				return;
			}
			else if (o is String)
			{
				logWithTab(o, logTimes);
			}
			else if (o is Number)
			{
				logWithTab(o.toString(), logTimes);
			}
			else
			{
				for (var key:* in o)
				{
					logWithTab(key + " " + o[key], logTimes + 1);
					if (!(o[key] is String) && !(o[key] is Number))
					{
						logObject(o[key], logTimes + 1);
					}
				}
			}
		}
		
		public static function classToObject(o:*):Object
		{
			ClassRegister.killMapping();
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(o);
			byteArray.position = 0;
			var result:Object = byteArray.readObject();
			
			ClassRegister.resetMapping();
			return result;
		}
		
		private static function logWithTab(s:String, n:uint = 0):void
		{
			var traceArr:Array = [];
			for (var i:uint = 0; i < n; i++)
			{
				traceArr.push("\t");
			}
			traceArr.push(s);
			
			var traceContent:String = traceArr.join("");
			if (enabled)
			{
				trace(traceContent);
				addToCacheList(traceContent);
			}
		}
		
		public static function traceNormal(...arg):void
		{
			if (enabled)
			{
				trace(arg);
			}
		}
		
		/**
		 * 加入日志队列 
		 * 
		 */		
		private static function addToCacheList(item:String):void
		{
			if (ClientManager.isDebug)
			{
				logCache.push(item);
				if (logCache.length > MAX_CACHE_LINE)
				{
					logCache.shift();
				}
				if (_logView)
				{
					_logView.update(logCache);
				}
			}
		}
	}
}