package com.aspectgaming.debug
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.tick.FrameRender;
	import com.aspectgaming.utils.tick.Tick;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 系统检测面板 
	 * @author mason.li
	 * 
	 */	
	public class DebugSystemView extends Sprite
	{
		private var _titleText:TextField;
		private var _frameText:TextField;
		private var _memeryText:TextField;
		private var _posText:TextField;
		
		private var _currentCount:Number = 0;
		
		public function DebugSystemView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			createTitle();
			createFrameListener();
			createMomeryListener();
			createPosListener();
			drawBg();
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			FrameRender.addRender(onFrame);
			Tick.addTimeInterval(onSecTimer, 1, getQualifiedClassName(this));
		}
		
		private function createPosListener():void
		{
			_posText = getWhiteText(100);
			LayerManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, movingHandler);
		}
		
		private function movingHandler(e:MouseEvent):void
		{
			_posText.text = "pos = x:" + e.stageX;
			_posText.appendText(",y:" + e.stageY);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			LayerManager.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			startDrag();
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			LayerManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stopDrag();
		}
		
		private function createTitle():void
		{
			_titleText = getWhiteText(10);
			_titleText.text = "AspectGaming Debugger";
		}
		
		private function createFrameListener():void
		{
			_frameText = getWhiteText(40);
		}
		
		private function createMomeryListener():void
		{
			_memeryText = getWhiteText(70);
		}
		
		private function onFrame():void
		{
			_currentCount++;
		}
		
		private function onSecTimer():void
		{
			_frameText.text = "fps: " + _currentCount;
			_memeryText.text = "memoryUsed: " + (System.totalMemory / 1024 /1024).toFixed(2) + "M";
			
			_currentCount = 0;
		}
		
		private function getWhiteText(y:Number):TextField
		{
			var txt:TextField = new TextField();
			txt.textColor = 0xFFFFFF;
			txt.width = 180;
			txt.x = 10;
			txt.selectable = false;
			txt.multiline = false;
			txt.height = 25;
			txt.y = y;
			
			addChild(txt)
			return txt;
		}
		
		private function drawBg():void
		{
			this.graphics.beginFill(0, .5);
			this.graphics.drawRoundRect(0, 0, 200, 130, 5, 5);
			this.graphics.endFill();
		}
		
		public function dispose():void
		{
			DisplayUtil.removeFromParent(this);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			LayerManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, movingHandler);
			FrameRender.removeRender(onFrame);
			Tick.removeTimeInterval(getQualifiedClassName(this));
		}
	}
}