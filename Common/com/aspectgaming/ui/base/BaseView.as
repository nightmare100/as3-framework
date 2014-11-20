package com.aspectgaming.ui.base 
{
	import com.aspectgaming.animation.LoadingAnimation;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.ui.event.ComponentEvent;
	import com.aspectgaming.ui.iface.IModule;
	import com.aspectgaming.ui.iface.IView;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event(name="show", type="com.aspectgaming.ui.event.ComponentEvent")]
	[Event(name="dispose", type="com.aspectgaming.ui.event.ComponentEvent")]
	[Event(name="hide", type="com.aspectgaming.ui.event.ComponentEvent")]
	/**
	 * 基础弹出面板
	 * @author Mason.Li
	 */
	public class BaseView extends Sprite implements IView
	{
		protected var _mc:MovieClip;
		protected var _isInit:Boolean;
		protected var _clostBtn:SimpleButton;
		protected var _dragBtn:SimpleButton;
		
		
		/**
		 * 移除时是否销毁 
		 */		
		protected var _isDisposeWhenClose:Boolean = true;
		
		public function BaseView() 
		{
			
		}
		
		protected function initView():void
		{
		    if (_mc)
		    {
			    addChild(_mc);
				_clostBtn = _mc["closeBtn"];
				_dragBtn = _mc["dragBtn"];
		    }
		    addEvent();
			_isInit = true;
		}
		
		protected function addEvent():void
		{
			if (_clostBtn)
			{
				_clostBtn.addEventListener(MouseEvent.CLICK, onClose);
			}
			
			if (_dragBtn)
			{
				_dragBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			}
		}
		
		public function set enabled(value:Boolean):void
		{
			this.mouseEnabled = this.mouseChildren = value;
		}
		
		public function get enabled():Boolean
		{
			return this.mouseEnabled;
		}
		
		/**
		 * 显示加载Loading条子 
		 * 
		 */		
		public function showLoading():void
		{
			LoadingAnimation.show(this);
			enabled = false;
		}
		
		public function hideLoading():void
		{
			LoadingAnimation.hide(this);
			enabled = true;
		}
		
		public function addByCenter(o:DisplayObject):void
		{
			if (_mc)
			{
				var bounds:Rectangle = this.getBounds(this);
				o.x = (this.width - o.width) / 2 + bounds.x;
				o.y = (this.height + (bounds.y * 2) - o.height) / 2;
				
				_mc.addChild(o);
			}
			else
			{
				o.x = (LayerManager.stageWidth - o.width) / 2;
				o.y = (LayerManager.stageHeight - o.height) / 2;
				LayerManager.topLayer.addChild(o);
			}
		}
		
		protected function onDrag(e:MouseEvent):void
		{
			DisplayUtil.bringToTop(this);
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stopDrag();
		}
		
		protected function removeEvent():void
		{
			if (_clostBtn)
			{
				_clostBtn.removeEventListener(MouseEvent.CLICK, onClose);
			}
			if (_dragBtn)
			{
				_dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			}
		}
		
		protected function onClose(e:MouseEvent):void
		{
			if (_isDisposeWhenClose)
			{
				this.dispose();
			}
			else
			{
				this.hide();
			}
		}
		
		/**
		 * 使用该模块顶级context 事件发送器发送
		 * 该事件必须由 模块中介器Meditor接受   由中介器 告诉其他模块
		 * @param event
		 * 
		 */	
		protected function dispatch(event:Event):void
		{
			if (parentModule && parentModule.context)
			{
				parentModule.context.eventDispatcher.dispatchEvent(event);
			}
		}
		
		/**
		 * 如需使用该View所属模块  必须覆盖 
		 * @return 
		 * 
		 */		
		protected function get parentModule():IModule
		{
			throw new Error("未定义父级模块");
			return null;
		}
		
		public function show(layer:DisplayObjectContainer = null, alignType:int = 4):void
		{
			if (layer)
			{
				if (!_isInit)
				{
					initView();
				}
				layer.addChild(this);
				DisplayUtil.align(this, alignType);
				dispatchEvent(new ComponentEvent(ComponentEvent.SHOW));
			}
		}
		
		public function hide():void
		{
		    DisplayUtil.removeFromParent(this);
			dispatchEvent(new ComponentEvent(ComponentEvent.HIDE));
		}
		
		public function dispose():void
		{
			removeEvent(); // 新手指引 转轮， 同时移除2个 notifymessage bug。 要先removeEvent
		    hide();
			if (_mc)
			{
				DisplayUtil.removeFromParent(_mc);
				_mc.stop();
			    _mc = null;
			}
			_isInit = false;
			_clostBtn = null;
			_dragBtn = null;
			dispatchEvent(new ComponentEvent(ComponentEvent.DISPOSE));
		}
		
	}

}