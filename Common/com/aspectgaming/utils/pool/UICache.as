package com.aspectgaming.utils.pool
{
	
	/**
	 * 对象缓存 
	 * @author mason.li
	 * 
	 */	
	public class UICache
	{
		public var maxCount:uint;
		private var _cls:Class;
		private var _arr:Array = [];
		private var _hasDispose:Boolean;
		
		public function UICache(cls:Class, max:uint = 10)
		{
			_cls = cls;
			maxCount = max;
		}
		
		public function getCache(name:String):*
		{
			for (var i:uint = 0 ; i < _arr.length ; i++)
			{
				var cacheInfo:CacheInfo = _arr[i];
				if (cacheInfo.cacheName == name)
				{
					return cacheInfo.cacheInstance;
				}
			}
			
			if (_cls)
			{
				var o:* = new _cls();
				_arr.push(new CacheInfo(o, name));
				
				if (_arr.length > maxCount)
				{
					_arr.shift();
				}
				
				return o;
			}
			return null;
		}
		
		
		public function getCacheByIdx(index:int):*
		{
			
			var cacheInfo:CacheInfo = _arr[index];
			if (cacheInfo != null)
			{
				return cacheInfo.cacheInstance;
			}			

			return null;
		}
		
		
		public function dispose():void
		{
			if (!_hasDispose)
			{
				_cls = null;
				for (var i:uint = 0 ; i < _arr.length ; i++)
				{
					var cacheInfo:CacheInfo = _arr[i];
					cacheInfo.dispose();
				}
				_arr = null;
				_hasDispose = true;
			}
		}

		
	}
}
//import com.aspectgaming.ui.iface.IView;

class CacheInfo
{
	public var cacheName:String;
	public var cacheInstance:*;
	
	public function CacheInfo(o:*, name:String)
	{
		cacheInstance = o;
		cacheName = name;
	}
	
	public function dispose():void
	{
		cacheInstance.dispose();
		cacheInstance = null;
	}
}