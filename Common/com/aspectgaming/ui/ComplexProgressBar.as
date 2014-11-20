package com.aspectgaming.ui
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.module.ModuleDefine;
	import com.aspectgaming.ui.constant.ProgressBarDuration;
	import com.aspectgaming.ui.iface.IModule;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 复合进度条 支持4种方向 
	 * @author mason.li
	 * 
	 */	
	public class ComplexProgressBar extends SimpleProgressBar
	{
		private var _dir:uint;
		private var _maskSpr:Sprite;
		private var _sourceX:Number;
		private var _sourceY:Number;
		
		public function ComplexProgressBar(mc:MovieClip, dir:uint = 0)
		{
			_dir = dir;
			super(mc);
		}
		
		override protected function init():void
		{
			_rect = _viewComponent.getBounds(_viewComponent);
			
			var loadModule:IModule = ModuleManager.getModule(ModuleDefine.GameLoadingModule);
			_sourceX = (loadModule ? loadModule.x : 0) + _viewComponent.x + _rect.x;
			_sourceY = (loadModule ? loadModule.y : 0) + _viewComponent.y + _rect.y;
			_maskSpr = new Sprite();
			drawMask();
			
			_viewComponent.mask = _maskSpr;
			
			addEvent();
		}
		
		private function drawMask():void
		{
			_maskSpr.graphics.clear();
			_maskSpr.graphics.beginFill(0x000000);
			
			
			switch (_dir)
			{
				case ProgressBarDuration.LEFT_TO_RIGHT:
					_maskSpr.graphics.drawRect(_sourceX, _sourceY, progress / 100 * _fixWidth, _fixHeight);
					break;
				case ProgressBarDuration.RIGHT_TO_LEFT:
					_maskSpr.graphics.drawRect(_sourceX + _fixWidth  - progress / 100 * _fixWidth, _sourceY, _fixWidth, _fixHeight);
					break;
				case ProgressBarDuration.TOP_TO_BOTTOM:
					_maskSpr.graphics.drawRect(_sourceX, _sourceY, _fixWidth, progress / 100 * _fixHeight);
					break;
				case ProgressBarDuration.BOTTOM_TO_TOP:
					_maskSpr.graphics.drawRect(_sourceX, _sourceY + _fixHeight - progress / 100 * _fixHeight, _fixWidth, _fixHeight);
					break;
			}
			
			_maskSpr.graphics.endFill();
		}
		
		override protected function update():void
		{
			drawMask();
			
			_viewComponent.mask = _maskSpr;
		}
	}
}