package com.aspectgaming.cache.containter
{
	import com.aspectgaming.cache.LoaderCache;
	import com.aspectgaming.cache.constant.LoadType;
	import com.aspectgaming.utils.LoggerUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * 位图对象加载器 
	 * 使用多个Loader 解决非同域图片加载
	 * @author mason.li
	 * 
	 */	
	[Event(name="complete", type="flash.events.Event")]
	public class BitmapDispatch extends AbstractDispatch
	{
		public function BitmapDispatch(x:Number = 0, y:Number = 0, useCache:Boolean = true)
		{
			this.x = x;
			this.y = y;
			_userCache = useCache;
		}
		
		override protected function startLoad():void
		{
			LoggerUtil.traceNormal("[PicLoader]" + _url);
			removeDisplay();
//			removeLoaderEvent();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			_loader.load(new URLRequest(_url));
		}
		
		private function onLoaderComplete(e:Event):void
		{
			var ldInfo:LoaderInfo = (e.currentTarget as LoaderInfo);
			removeLoaderInfoEvent(ldInfo);
			if (ldInfo.loader != _loader)
			{
				return;
			}
			
			var content:* = ldInfo.loader;
			if (_userCache)
			{
				LoaderCache.saveCache(_url, ldInfo.loader, LoadType.CONTENT);
			}
			
			if (ldInfo.url == _loader.contentLoaderInfo.url)
			{
				addDisplayObject(content);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onError(e:*):void
		{
			var ldInfo:LoaderInfo = (e.currentTarget as LoaderInfo);
			removeLoaderInfoEvent(ldInfo);
		}
		
		private function removeLoaderEvent():void
		{
			if (_loader)
			{
				removeLoaderInfoEvent(_loader.contentLoaderInfo);
			}
		}
		
		private function removeLoaderInfoEvent(info:LoaderInfo):void
		{
			if (info)
			{
				info.removeEventListener(Event.COMPLETE, onLoaderComplete);
				info.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				info.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			}
		}
		
		override public function setUrl(uri:String):void
		{
			if (!uri)
			{
				return;
			}
			
			super.setUrl(uri);
			if (_userCache)
			{
				var cache:* = LoaderCache.getCache(_url);
				if (cache != null)
				{
					addDisplayObject(cache);
					
					dispatchEvent(new Event(Event.COMPLETE));
				}
				else
				{
					startLoad();
				}
			}
			else
			{
				startLoad();
			}
		}
		
		
		
		override protected function addDisplayObject(content:*):void
		{
			removeDisplay();
			
			_displayObject = content;
			if (_displayObject is DisplayObjectContainer)
			{
				(_displayObject as DisplayObjectContainer).mouseEnabled = false;
			}
			addChild(_displayObject);
		}
		
		public function removeDisplay():void
		{
			if (_displayObject && _displayObject.parent)
			{
				_displayObject.parent.removeChild(_displayObject);
			}
		}
		
		override public function set height(value:Number):void
		{
			if (_loader)
			{
				_loader.height = value;
			}
			super.height = value;
		}
		
		override public function set width(value:Number):void
		{
			if (_loader)
			{
				_loader.width = value;
			}
			super.width = value;
		}
		
		

		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		
		override public function dispose():void
		{
			removeDisplay();
			_displayObject = null;
			if (_loader)
			{
				try 
				{
					_loader.close();
					removeLoaderEvent();
					_loader = null;
				}
				catch (e:*)
				{
					
				}
			}
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}

	}
}