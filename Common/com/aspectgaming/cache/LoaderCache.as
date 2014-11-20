package com.aspectgaming.cache
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.utils.Dictionary;
	
	import org.assetloader.core.ILoader;

	/**
	 * 加载缓存 
	 * @author mason.li
	 * 
	 */	
	public class LoaderCache
	{
		private static var _dic:Dictionary = new Dictionary();
		
		public static function getCache(id:String):*
		{
			if (_dic[id])
			{
				var info:AssetInfo = _dic[id] as AssetInfo;
				return info.getContent();
			}
			
			return null;
		}
		
		public static function saveCache(id:String, content:*, type:String):void
		{
			_dic[id] = new AssetInfo(type, content);
		}
		
		public static function clearCache(id:String):void
		{
			delete _dic[id];
		}
		
		public static function dispose():void
		{
			for (var key:String in _dic)
			{
				_dic[key] = null;
				delete _dic[key];
			}
			
			_dic = null;
		}
	}
}
import com.aspectgaming.cache.constant.LoadType;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.system.LoaderContext;

import org.assetloader.base.Param;
import org.assetloader.core.ILoader;

class AssetInfo
{
	public function AssetInfo(t:String, c:*)
	{
		type = t;
		data = c;
	}
	public function getContent():*
	{
		if (type == LoadType.DOMAIN)
		{
			if (data is Loader)
			{
				return Loader(data).loaderInfo.applicationDomain;
			}
			else if (data is ILoader)
			{
				var ldContext:LoaderContext = ILoader(data).getParam(Param.LOADER_CONTEXT);
				if (ldContext)
				{
					return ldContext.applicationDomain;
				}
				else
				{
					return null;
				}
			}
		}
		else if (type == LoadType.CONTENT)
		{
			if (data is Loader)
			{
				return checkAccessToObject();
			}
			else if (data is ILoader)
			{
				var o:* = ILoader(data).data;
				if (o is Bitmap)
				{
					return new Bitmap(Bitmap(o).bitmapData.clone());
				}
				else
				{
					return o;
				}
			}
		}
		
		return data;
			
	}
	
	private function checkAccessToObject():DisplayObject
	{
		try
		{
			var o:DisplayObject = Loader(data).content;
			if (o is Bitmap)
			{
				return new Bitmap(Bitmap(o).bitmapData.clone());
			}
			else 
			{
				return o;
			}
		}
		catch (e:Error)
		{
			return null;
		}
		
		return null;
	}
	
	public var data:*;
	public var type:String;
}