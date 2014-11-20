package com.aspectgaming.game.component
{
	import com.aspectgaming.game.iface.IGameModule;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 游戏基础模块 
	 * @author mason.li
	 * 
	 */	
	public class BaseControlModule extends Sprite implements IGameModule
	{
		protected var _mc:MovieClip;
		
		public function BaseControlModule(mc:MovieClip = null)
		{
			if (mc)
			{
				_mc = mc;
				addChild(_mc);
			}
			init();
			super();
		}
		
		protected function init():void
		{
			
			addEvent();
		}
		
		protected function addEvent():void
		{
			
		}
		
		protected function removeEvent():void
		{
			
		}
		
		/**
		 * 使用robetlegs context 发送事件 
		 * 
		 */		
		protected function dispatchToContext(event:Event):void
		{
			if (GameLayerManager.gameRoot)
			{
				GameLayerManager.gameRoot.dispatch(event);
			}
		}
		
		public function show(par:DisplayObjectContainer, x:Number=0, y:Number=0):void
		{
			this.x = x;
			this.y = y;
			par.addChild(this);
		}
		
		public function dispose():void
		{
			hide();
			removeEvent();
			if (_mc)
			{
				DisplayUtil.removeFromParent(_mc);
			}
		}
		
		public function hide():void
		{
			DisplayUtil.removeFromParent(this);
		}
		
		public function restart():void
		{

		}
	}
}