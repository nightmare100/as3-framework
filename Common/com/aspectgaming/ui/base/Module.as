package com.aspectgaming.ui.base
{
	import avmplus.getQualifiedClassName;
	
	import com.aspectgaming.globalization.module.LifeCycle;
	import com.aspectgaming.ui.event.ModuleEvent;
	import com.aspectgaming.ui.iface.IModule;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.core.IModuleContext;
	
	
	[Event(name="moduleAdded", type="com.aspectgaming.ui.event.ModuleEvent")]
	[Event(name="moduleRemoved", type="com.aspectgaming.ui.event.ModuleEvent")]
	/**
	 * RobotLegs 模块基类 
	 * @author mason.li
	 * 
	 */	
	public class Module extends Sprite implements IModule
	{
		protected var _lifeCycle:String = LifeCycle.GOBLE;
		protected var _context:IModuleContext;
		protected var _data:*;
		protected var _isInit:Boolean;
		
		/**
		 * 模块对应KEY 
		 */		
		protected var _moduleName:String;
		
		public function Module()
		{
			super();
		}

		/**
		 * 初始化数据 
		 * @param data
		 * 
		 */		
		public function init(data:*):void
		{
			_data = data;
		}
		
		/**
		 * 获取模块自身context  
		 * @return 
		 * 
		 */		
		public function get context():IModuleContext
		{
			return _context;
		}

		/**
		 * 生命周期 
		 */
		public function get lifeCycle():String
		{
			return _lifeCycle;
		}

		[Inject]
		public function set parentInjector(value:IInjector):void
		{
			
		}
		
		protected function initliaze():void
		{
			
		}
		
		public function show(par:DisplayObjectContainer, x:Number = 0, y:Number = 0):void
		{
			this.x = x;
			this.y = y;
			
			par.addChild(this);
			if (!_isInit)
			{
				initliaze();
				_isInit = true;
			}
			dispatchEvent(new ModuleEvent(ModuleEvent.MODULE_ADDED));
		}
		
		public function hide():void
		{
			DisplayUtil.removeFromParent(this);
		}
		
		public function set enabled(value:Boolean):void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function get enabled():Boolean
		{
			return this.mouseEnabled && this.mouseChildren;
		}
		
		public function get selfClass():Class
		{
			if (!this.loaderInfo)
			{
				return null;
			}
			
			var appDomain:ApplicationDomain = this.loaderInfo.applicationDomain;
			if (appDomain)
			{
				var className:String = getQualifiedClassName(this);
				return appDomain.getDefinition(className) as Class;
			}
			
			return null;
		}
		
		public function dispose():void
		{
			hide();
			if (_context)
			{
				_context.dispose();
			}
			
			_context = null;
			_isInit = false;
			dispatchEvent(new ModuleEvent(ModuleEvent.MODULE_REMOVED));
		}
		
		public function set moduleName(name:String):void
		{
			_moduleName = name;
			
		}
		
		public function get moduleName():String
		{
			// TODO Auto Generated method stub
			return _moduleName;
		}
		
		
	}
}