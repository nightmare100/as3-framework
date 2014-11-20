package com.aspectgaming.net.mapping
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;

	/**
	 * JAVA数据类映射 
	 * @author mason.li
	 * 
	 */	
	internal class ServerClassRegister
	{
		private static var _map:Dictionary = new Dictionary();
		public static function registerClass(func:String, nameSpaceReq:String, clsRequest:Class = null, nameSpaceRes:String = null, clsResponse:Class = null):void
		{
			if (clsRequest)
			{
				registerClassAlias(nameSpaceReq, clsRequest);
			}
			if (clsResponse)
			{
				registerClassAlias(nameSpaceRes, clsResponse);
			}
			
			var struct:DataStruct = new DataStruct();
			struct.reqName = func;
			struct.reqNameSpace = nameSpaceReq;
			struct.reqClass = clsRequest;
			struct.resNameSpace = nameSpaceRes;
			struct.resClass = clsResponse;
			
			_map[func] = struct;
		}
		
		public static function registerSingle(nameSpace:String, cls:Class):void
		{
			registerClassAlias(nameSpace, cls);
			_map[nameSpace] = cls;
		}
		
		public static function getRequestDataClass(func:String):Class
		{
			if (_map[func])
			{
				return DataStruct(_map[func]).reqClass;
			}
			return null;
		}
		
		
		public static function getResponseDataClass(func:String):Class
		{
			if (_map[func])
			{
				return DataStruct(_map[func]).resClass;
			}
			return null;
		}
		
		/**
		 * 用于LOGGER 清除注册信息 
		 * @param func
		 * 
		 */		
		public static function killDataClassMapping():void
		{
			for (var key:String in _map)
			{
				if (_map[key] is DataStruct)
				{
					var ds:DataStruct = DataStruct(_map[key]);
					
					if (ds.reqClass)
					{
						registerClassAlias(ds.reqNameSpace, Object);
					}
					if (ds.resClass)
					{
						registerClassAlias(ds.resNameSpace, Object);
					}
				}
				else
				{
					registerClassAlias(key, Object);
				}
			}
		}
		
		/**
		 * 用于LOGGER 重置注册信息 
		 * @param func
		 * 
		 */		
		public static function resetDataClassMapping():void
		{
			for (var key:String in _map)
			{
				if (_map[key] is DataStruct)
				{
					var ds:DataStruct = DataStruct(_map[key]);
					
					if (ds.reqClass)
					{
						registerClassAlias(ds.reqNameSpace, ds.reqClass);
					}
					if (ds.resClass)
					{
						registerClassAlias(ds.resNameSpace, ds.resClass);
					}
				}
				else
				{
					registerClassAlias(key, _map[key]);
				}
			}
		}
	}
}