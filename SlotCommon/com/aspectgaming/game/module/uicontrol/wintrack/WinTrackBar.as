package com.aspectgaming.game.module.uicontrol.wintrack
{
	import com.aspectgaming.game.constant.asset.AssetDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.utils.DisplayUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class WinTrackBar extends BaseControlModule
	{
		protected const MAX_BALL_NUM:uint = 30;
		protected const BIG_BALL_MARGIN:Number = 2;
		protected const OFFSET_X:Number = 35;
		protected const OFFSET_Y:Number = 11;
		
		private var _ballContainter:Sprite;
		private var _currentList:Array;
		public function WinTrackBar(mc:MovieClip)
		{
			super(mc);
		}
		
		override public function show(par:DisplayObjectContainer, x:Number=0, y:Number=0):void
		{
			par.addChild(this);
		}
		
		override protected function init():void
		{
			this.x = _mc.x;
			this.y = _mc.y;
			_mc.x = 0;
			_mc.y = 0;
//			this.scrollRect = new Rectangle(0, 0, _mc.width, _mc.height);
			_ballContainter = new Sprite();
			_ballContainter.y = OFFSET_Y;
			_ballContainter.mask = _mc["mask"];
			addChildAt(_ballContainter, 0);
		}
		
		public function setList(list:Array):void
		{
			if (list)
			{
				if (_currentList)
				{
					pushBall(list[list.length - 1]);
					_currentList = list;
				}
				else
				{
					_currentList = list;
					fullBall();
				}
			}
		}
		
		/**
		 * 新增球 
		 * @param ballType
		 * 
		 */		
		public function pushBall(ballType:String):void
		{
			var currentBigBall:DisplayObject = _ballContainter.numChildren > 0 ? _ballContainter.getChildAt(_ballContainter.numChildren - 1) : null;
			
			
			if (currentBigBall)
			{
				DisplayUtil.removeFromParent(currentBigBall);
				var smallBall:DisplayObject = GameAssetLibrary.getWinShowBall(currentBigBall.name);
				smallBall.x = getOffsetPostion(currentBigBall);
				_ballContainter.addChild(smallBall);
			}
			var ball:DisplayObject = GameAssetLibrary.getWinShowBall(ballType, AssetDefined.BALL_BIG);
			_ballContainter.addChild(ball);
			var targetX:Number = _ballContainter.getRect(_ballContainter).x - ball.width - BIG_BALL_MARGIN;
			ball.x = targetX;
			ball.name = ballType;

			TweenLite.to(_ballContainter, 0.2, {x:OFFSET_X - _ballContainter.getRect(_ballContainter).x});
			
			ball.width = GameAssetLibrary.smallBallInfo.width;
			ball.height = GameAssetLibrary.smallBallInfo.height;
			ball.x = getOffsetPostion(ball);
			ball.y = 0;
			TweenLite.to(ball, 0.3, {width:GameAssetLibrary.bigBallInfo.width , height:GameAssetLibrary.bigBallInfo.height,
									 x:targetX, y:(GameAssetLibrary.smallBallInfo.height - GameAssetLibrary.bigBallInfo.height) /  2, ease:Linear.easeNone});
			
			
			clearExtraBall();
		}
		
		private function getOffsetPostion(o:DisplayObject):Number
		{
			return o.x + o.width - GameAssetLibrary.smallBallInfo.width + BIG_BALL_MARGIN;
		}
		
		private function clearExtraBall():void
		{
			while (_ballContainter.numChildren > MAX_BALL_NUM)
			{
				_ballContainter.removeChildAt(0);
			}
		}
		
		private function fullBall():void
		{
			for (var i:uint = 0; i < _currentList.length; i++)
			{
				var ball:DisplayObject;
				
				if (i == _currentList.length - 1)
				{
					ball = GameAssetLibrary.getWinShowBall(_currentList[i], AssetDefined.BALL_BIG)
					ball.y = (GameAssetLibrary.smallBallInfo.height - GameAssetLibrary.bigBallInfo.height) /  2;
					ball.x = _ballContainter.getRect(_ballContainter).x - ball.width - BIG_BALL_MARGIN;
					ball.name = _currentList[i];
				}
				else
				{
					ball = GameAssetLibrary.getWinShowBall(_currentList[i]);
					ball.x = _ballContainter.getRect(_ballContainter).x - ball.width;
				}
				_ballContainter.addChild(ball);
			}
			_ballContainter.x = OFFSET_X - _ballContainter.getRect(_ballContainter).x
		}
		
		override public function dispose():void
		{
			DisplayUtil.removeFromParent(_ballContainter);
			_ballContainter = null;
			super.dispose();
		}
		
		
	}
}