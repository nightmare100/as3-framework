package com.aspectgaming.ui.base
{
	import com.aspectgaming.data.configuration.Configuration;
	import com.aspectgaming.event.LobbyEvent;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.module.ModuleDefine;
	import com.aspectgaming.ui.iface.IModule;
	import com.aspectgaming.utils.DisplayUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * 基础页面 实
	 * @author mason.li
	 * 
	 */	
	public class BasePage extends BaseView
	{
		/**
		 * 默认显示第X页数 
		 */		
		protected var _defaultPageNum:uint;
		
		public function BasePage()
		{
			super();
		}
		
		override protected function get parentModule():IModule
		{
			return ModuleManager.getModule(ModuleDefine.ContentModule);
		}
		
		override public function show(layer:DisplayObjectContainer=null, alignType:int=4):void
		{
			super.show(layer, alignType);
			initData();
		}
		
		protected function initData():void
		{
			clearAll();
			cellRender();
			TweenLite.killTweensOf(this);
			this.alpha = 0;
			TweenLite.to(this, 0.3, {alpha:1});
		}
		
		/**
		 * 填充元件了 
		 * 
		 */		
		protected function cellRender():void
		{
		
		}
		
		protected function clearAll():void
		{
			
		}
		
		/**
		 * 切换页面 
		 * @param name
		 * 
		 */		
		public function changePage(name:String, pageNum:uint = 1):String
		{
			_defaultPageNum = pageNum;
			initData();
			//dispatch(new LobbyEvent(LobbyEvent.CONTENT_PAGE_CHANGED, null, name));
			
			return null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			clearAll();
		}
		
		
	}
}