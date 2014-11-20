package com.aspectgaming.game.animation
{
	import com.aspectgaming.animation.event.AnimationEvent;
	import com.aspectgaming.game.core.IGameAnimation;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.GameAnimaEvent;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="animationComplete", type="com.aspectgaming.game.event.GameAnimaEvent")]
	[Event(name="animationHalf", type="com.aspectgaming.game.event.GameAnimaEvent")]
	public class BaseGameAnimation extends EventDispatcher implements IGameAnimation
	{
		protected var _mc:MovieClip;
		protected var _data:*;
		protected var _isPlaying:Boolean;
		private var _content:String;
		
		public function set content(value:String):void
		{
			_content = value;
			
		}
		
		public function get content():String
		{
			return _content;
		}
		
		
		
		public function BaseGameAnimation()
		{
			init();
		}
		
		protected function init():void
		{
			
			_mc.gotoAndStop(1);
			_mc.width = GameLayerManager.GAME_WIDTH;
			_mc.height = GameLayerManager.GAME_HEIGHT;
		}
		
		public function restart():void
		{
			
		}
		
		public function start():void
		{
			_mc.gotoAndStop(1);
			onBeforeStart();
			GameGlobalRef.gameManager.frameRender.addRender(onAnimaing);
			_mc.gotoAndPlay(1);
			_isPlaying = true;
		}
		
		protected function onBeforeStart():void
		{
			
		}
		
		protected function onAnimaing():void
		{
			if (_mc.currentFrame == uint(_mc.totalFrames / 2))
			{
				dispatchEvent(new GameAnimaEvent(GameAnimaEvent.ANIMATION_HALF, null, _content));
			}
			
			if (_mc.currentFrame == _mc.totalFrames)
			{
				dispatchEvent(new GameAnimaEvent(GameAnimaEvent.ANIMATION_COMPLETE, null, _content));
				hide();
			}
		}
		
		public function set data(value:*):void
		{
			_data = value;
		}
		
		public function show(par:DisplayObjectContainer, x:Number=0, y:Number=0):void
		{
			_mc.x = x;
			_mc.y = y;
			par.addChild(_mc);
		}
		
		public function get isPlaying():Boolean
		{
			
			return _isPlaying;
		}
		
		
		
		public function dispose():void
		{
			hide();
			_data = null;
		}
		
		public function hide():void
		{
			_isPlaying = false;
			_mc.gotoAndStop(1);
			DisplayUtil.removeFromParent(_mc);
			GameGlobalRef.gameManager.frameRender.removeRender(onAnimaing);
		}
	}
}