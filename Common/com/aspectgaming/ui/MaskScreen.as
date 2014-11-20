package com.aspectgaming.ui
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.module.ModuleDefine;
	import com.aspectgaming.ui.event.ComponentEvent;
	import com.aspectgaming.ui.iface.IModule;
	import com.aspectgaming.ui.iface.IView;
	import com.aspectgaming.utils.DisplayUtil;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 * Msg遮罩
	 * @author Mason.Li
	 */
	public class MaskScreen extends Sprite implements IView
	{
		private var _isShow:Boolean;
		private var _selfAlpha:Number;
	    public function MaskScreen(alpha:Number = 0.6) 
		{
			_selfAlpha = alpha;
			init();
		}
		
		public function get selfAlpha():Number
		{
			return _selfAlpha;
		}

		public function addByCenter(o:DisplayObject):void
		{
			this.addChild(o);
			DisplayUtil.align(o);
		}
		
		public function dispose():void
		{
			
		}
		
		public function set enabled(value:Boolean):void
		{
			
		}
		
		public function get enabled():Boolean
		{
			return true;
		}

		private function init():void
		{
			this.graphics.beginFill(0x000000, _selfAlpha);
			this.graphics.drawRect(0, 0, LayerManager.stageWidth, LayerManager.stageHeight);
			this.graphics.endFill();
		}
		
		public function show():void
		{
			var msgModule:IModule = ModuleManager.getModule(ModuleDefine.MessageBoxModule);
			if (msgModule && !_isShow)
			{
				TweenLite.killTweensOf(this);
				this.alpha = 1;
				msgModule.addChildAt(this, 0);
//				TweenLite.to(this,0.3, {alpha:1});
				_isShow = true;
			}
		}
		
		public function  get isShow():Boolean
		{
			return _isShow;
		}
		
		public function hide():void
		{
			TweenLite.killTweensOf(this);
			TweenLite.to(this, 0.05, {alpha:0, onComplete:onHideComplete});
			_isShow = false;
		}
		
		private function onHideComplete():void
		{
			DisplayUtil.removeFromParent(this);
			dispatchEvent(new ComponentEvent(ComponentEvent.HIDE))
			
		}
	}

}