package com.aspectgaming.globalization.module
{
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.ui.event.ModuleEvent;
	import com.aspectgaming.ui.iface.IModule;
	import com.aspectgaming.ui.loading.CommonLoadingBar;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.DomainUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * 界面代理 适配器
	 * 代理自身不销毁
	 * @author mason.li
	 * 
	 */	
	public class ModuleProxy
	{
		private var _loader:Loader;
		private var _proxyInfo:Object;
		
		private var _key:String;
		private var _module:IModule;
		private var _statue:String;
		private var _moduleClass:Class;
		
		private var _moduleUrl:String;
		
		public var sourceX:Number;
		public var sourceY:Number;
		
		public function ModuleProxy(module:*, key:String)
		{
			if (module is IModule)
			{
				_module = module;
			}
			else if (module is Class)
			{
				_moduleClass = module as Class;
			}
			else
			{
				//为SWF路径
				_moduleUrl = String(module);
			}
			_key = key;
		}
		
		public function get lifeCycle():String
		{
			if (_module)
			{
				return _module.lifeCycle;
			}
			else
			{
				return "";
			}
		}

		public function get module():IModule
		{
			return _module;
		}

		public function get statue():String
		{
			return _statue;
		}

		public function set enabled(value:Boolean):void
		{
			_module.enabled = value;
		}
		
		public function get enabled():Boolean
		{
			return _module.enabled;
		}
		
		public function dispose():void
		{
			if (_module)
			{
				_module.dispose();
				_module = null;
				_statue = ModuleStatue.DISPOSE;
			}
			_proxyInfo = null;
			clearLoader(true);
		}
		
		private function clearLoader(needDispose:Boolean = false):void
		{
			if (_loader)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				
				if (needDispose)
				{
					try
					{
						_loader.close();
						_loader.unloadAndStop(true);
						_loader = null;
					}
					catch (e:Error)
					{
						
					}
				}
			}
			
		}
		
		public function preLoad():void
		{
			if (!_loader)
			{
				startLoad();
			}
		}
		
		public function startLoad(needShowLoadingBar:Boolean = false):void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.load(new URLRequest(_moduleUrl), new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain), DomainUtil.getSecurityDomain(ClientManager.useFaceBookConnect)));
			
			if (needShowLoadingBar)
			{
				CommonLoadingBar.show(_loader);
			}
		}
		
		private function onLoadComplete(e:Event):void
		{
			clearLoader();
			if (_proxyInfo && _loader)
			{
				_module = _loader.content as IModule;
				_module.init(_proxyInfo["info"]);

				_module.show(_proxyInfo["parent"], sourceX, sourceY);
				DisplayUtil.align(_module as DisplayObject, _proxyInfo["align"]);
				_statue = ModuleStatue.SHOW;
				if (!_moduleClass && _module.selfClass)
				{
					_moduleClass = _module.selfClass;
				}
			}
			else
			{
				if (_loader)
				{
					_module = _loader.content as IModule;
					if (!_moduleClass && _module.selfClass)
					{
						_moduleClass = _module.selfClass;
					}
				}
			}
			
			if (CommonLoadingBar.isUsedBy(_loader))
			{
				//使用进度条时 才抛事件
				ModuleManager.dispatchEvent(new ModuleEvent(ModuleEvent.MODULE_END_LOAD, _key));
			}
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			dispose();
		}
		
		public function show(parent:DisplayObjectContainer, x:Number = 0, y:Number = 0, align:int = -1, data:* = null):void
		{
			if (_module)
			{
				if (_statue == ModuleStatue.SHOW)
				{
					_module.show(parent, x, y);
					return;
				}
			}
			else
			{
				if (!_moduleClass)
				{
					_proxyInfo = {parent : parent, align: align, info : data}
					sourceX = x;
					sourceY = y;
					if (_loader)
					{
						CommonLoadingBar.show(_loader);
					}
					else
					{
						startLoad(true);
					}
					return;
				}
					
				_module = new _moduleClass();
				_module.moduleName = _key;
			}
			_module.init(data);
			sourceX = x;
			sourceY = y;
			_module.show(parent, x, y);
			DisplayUtil.align(_module as DisplayObject, align);
			_statue = ModuleStatue.SHOW;
			if (!_moduleClass && _module.selfClass)
			{
				_moduleClass = _module.selfClass;
			}
		}
		
		public function hide():void
		{
			_module.hide();
			_statue = ModuleStatue.HIDE;
		}
	}
}