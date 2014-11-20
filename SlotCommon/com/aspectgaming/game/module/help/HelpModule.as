package com.aspectgaming.game.module.help
{
	import com.aspectgaming.game.constant.asset.AssetDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.component.BaseControlModule;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class HelpModule extends BaseControlModule
	{
		private var _btnPre:SimpleButton;
		private var _btnNext:SimpleButton;
		
		public function HelpModule()
		{
			var mc:MovieClip = GameAssetLibrary.getGameAssets(AssetDefined.INSTRUC);
			super(mc["help"]);
		}
		
		override protected function init():void
		{
			_mc.gotoAndStop(1);
			_btnPre = _mc["btn_prev"];
			_btnNext = _mc["btn_next"];
			super.init();
		}
		
		override protected function addEvent():void
		{
			_btnPre.addEventListener(MouseEvent.CLICK, onPreNextHandler);
			_btnNext.addEventListener(MouseEvent.CLICK, onPreNextHandler);
		}
		
		override protected function removeEvent():void
		{
			_btnPre.removeEventListener(MouseEvent.CLICK, onPreNextHandler);
			_btnNext.removeEventListener(MouseEvent.CLICK, onPreNextHandler);
		}
		
		override public function show(par:DisplayObjectContainer, x:Number=0, y:Number=0):void
		{
			super.show(par, x, y);
			_mc.gotoAndStop(1);
		}
		
		protected function onPreNextHandler(e:MouseEvent):void
		{
			var page:Number;
			if (e.currentTarget == _btnPre)
			{
				page = _mc.currentFrame - 1 < 1? _mc.totalFrames: ( _mc.currentFrame - 1);
			}
			else
			{
				page = _mc.currentFrame + 1 > _mc.totalFrames ? 1: ( _mc.currentFrame + 1);
			}
			_mc.gotoAndStop(page);
		}
		
	}
}