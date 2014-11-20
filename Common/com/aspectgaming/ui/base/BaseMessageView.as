package com.aspectgaming.ui.base
{
	import com.aspectgaming.constant.global.LobbyGameConstant;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.managers.NotifyManager;
	import com.aspectgaming.globalization.module.ModuleDefine;
	import com.aspectgaming.globalization.module.ModuleStatue;
	import com.aspectgaming.ui.iface.IMessage;
	import com.aspectgaming.ui.iface.IModule;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.constant.AlignType;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 消息窗口基类 
	 * @author mason.li
	 * 
	 */	
	public class BaseMessageView extends BaseView implements IMessage
	{
		protected var _data:*;
		protected var _statue:String;
		
		protected var _viewName:String;
		
		public function BaseMessageView()
		{
			
		}
		
		/**
		 * notify Name 
		 */
		public function get viewName():String
		{
			return _viewName;
		}

		/**
		 * 自动显示 
		 * 
		 */		
		public function autoShow():void
		{
			parentModule.addChild(this);
			_statue = ModuleStatue.SHOW;
			if (!_isInit)
			{
				initView();
			}
			
			initData();
			DisplayUtil.align(this, AlignType.MIDDLE_CENTER, (parentModule as DisplayObject).getBounds(LayerManager.stage));
			ModuleManager.dispatchToGame(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.ON_LOBBY_COMMAND, LobbyGameConstant.WIN_POPUP));
		}
		
		public function set viewName(value:String):void
		{
			_viewName = value;
		}
		
		
		
		override protected function removeEvent():void
		{
			if (_mc)
			{
				_mc.removeEventListener(Event.ADDED, onAddRemoved);
				_mc.removeEventListener(Event.REMOVED, onAddRemoved);
			}
			
			super.removeEvent();
		}
		
		/**
		 * 初始化数据 
		 * 
		 */		
		protected function initData():void
		{
			
		}
		
		override protected function initView():void
		{
			if (_mc)
			{
				_mc.addEventListener(Event.ADDED, onAddRemoved);
				_mc.addEventListener(Event.REMOVED, onAddRemoved);
			}
			super.initView();
		}
		
		protected function onAddRemoved(e:Event):void
		{
			e.stopImmediatePropagation();
		}
		
		/**
		 * 使用该模块顶级context 事件发送器发送
		 * @param event
		 * 
		 */	
		override protected function dispatch(event:Event):void
		{
			parentModule.context.eventDispatcher.dispatchEvent(event);
		}
		
		override protected function get parentModule():IModule
		{
			return ModuleManager.getModule(ModuleDefine.MessageBoxModule);
		}
		
		public function set data(value:*):void
		{
			_data = value;
		}
		
		override public function hide():void
		{
			_statue = ModuleStatue.HIDE;
			super.hide();
			NotifyManager.showNext(_viewName);
			ModuleManager.dispatchToGame(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.ON_LOBBY_COMMAND, LobbyGameConstant.WIN_CLOSE));
		}
		
		override public function dispose():void
		{
			super.dispose();
			_data = null;
		}
		
		/**
		 * 自动关闭 且不会调用 队列下一跳消息 
		 * 
		 */		
		public function autoClose():void
		{
			_statue = ModuleStatue.HIDE;
			super.hide();
		}
		
		public function get statue():String
		{
			return _statue;
		}
		
		
		override public function show(layer:DisplayObjectContainer=null, alignType:int = 4):void
		{
			throw new Error("Message类型面板 无法使用该方法 请使用autoShow");
		}
		
	}
}