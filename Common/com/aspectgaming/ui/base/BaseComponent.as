package com.aspectgaming.ui.base
{
	import com.aspectgaming.ui.iface.IView;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 基本UI组件 组件装饰
	 * 存在于BaseView内部 用于装饰结构复杂  并且在组件中已存在的元件
	 * 组件事件必须由baseView接受
	 * @author mason.li
	 * 
	 */	
	[Event(name="click",type="flash.events.MouseEvent")]
	[Event(name="mouseOver",type="flash.events.MouseEvent")]
	[Event(name="mouseOut",type="flash.events.MouseEvent")]
	[Event(name="mouseDown",type="flash.events.MouseEvent")]
	[Event(name="mouseUp",type="flash.events.MouseEvent")]
	[Event(name="mouseMove",type="flash.events.MouseEvent")]
	[Event(name="rollOut",type="flash.events.MouseEvent")]
	[Event(name="rollOver",type="flash.events.MouseEvent")]
	public class BaseComponent implements IView,IEventDispatcher
	{
		protected var _interactiveObject:InteractiveObject;
		
		protected var _viewComponent:MovieClip;
		protected var _data:*;
		protected var _isInView:Boolean;
		
		public function BaseComponent(mc:InteractiveObject)
		{
			if (mc is MovieClip)
			{
				_viewComponent = mc as MovieClip;	
			}

			
			_interactiveObject = mc;
			
			_isInView = interactiveObject.parent != null;
			init();
		}
		
		public function get viewComponent():MovieClip
		{
			return _viewComponent;
		}
		
		public function get interactiveObject():InteractiveObject
		{
			if (_viewComponent)
			{
				return _viewComponent;
			}
			else
			{
			  	return _interactiveObject;
			}
		}

		public function get data():*
		{
			return _data;
		}

		public function addByCenter(o:DisplayObject):void
		{
			if (_viewComponent)
			{
				_viewComponent.addChild(o);
				DisplayUtil.align(o);
			}
		}
		
		/**
		 * 控制器 
		 * @param value
		 * 
		 */		
		public function set data(value:*):void
		{
			_data = value;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (interactiveObject)
			{
				interactiveObject.mouseEnabled = value;
				if (_viewComponent)
				{
					_viewComponent.mouseChildren = value;
				}
			}
		}
		
		public function applyFilter(array:Array):void
		{
			if (_viewComponent)
			{
				_viewComponent.filters = array;
			}
		}
		
		public function get enabled():Boolean
		{
			if (interactiveObject)
			{
				return interactiveObject.mouseEnabled;
			}
			return false;
		}
		
		public function set visible(value:Boolean):void
		{
			if (interactiveObject)
			{
				interactiveObject.visible = value;
			}
		}
		
		public function get visible():Boolean
		{
			if (interactiveObject)
			{
				return interactiveObject.visible;
			}
			
			return false;
		}

		protected function init():void
		{
			addEvent();
		}
		
		/**
		 * 添加 viewComponent UI事件
		 * 
		 */		
		protected function addEvent():void
		{
			
		}
		
		protected function removeEvent():void
		{
			
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			interactiveObject.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return interactiveObject.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return interactiveObject.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			interactiveObject.removeEventListener(type, listener, useCapture);
			
		}
		
		public function willTrigger(type:String):Boolean
		{
			return interactiveObject.willTrigger(type);
		}
		
		
		
		public function dispose():void
		{
			removeEvent();
			if (!_isInView)
			{
				DisplayUtil.removeFromParent(interactiveObject);
			}
			if (_viewComponent)
			{
				_viewComponent.stop();
				_viewComponent = null;
			}
			
			_interactiveObject = null;
			_data = null;
		}
		
	}
}