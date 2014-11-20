package com.aspectgaming.game.component.reels
{
	import com.aspectgaming.game.config.reel.ReelInfo;
	import com.aspectgaming.game.config.reel.SpeedInfo;
	import com.aspectgaming.game.constant.ReelStopType;
	import com.aspectgaming.game.constant.RollDirectionDefined;
	import com.aspectgaming.ui.iface.IAssetLibrary;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * 横向滚动轮子 
	 * 再次扩展 请不要使用继承 改用 组合方式 - 装饰器
	 * @author mason.li
	 * 
	 */	
	public class HorizontalReel extends AbstractReel
	{
		/**
		 * 是否从左到右滚（默认） 或者 从右到左滚 
		 */		
		private var _isRollLeftRight:Boolean;
		
		public function HorizontalReel(symbloLibs:IAssetLibrary)
		{
			super(symbloLibs);
		}
		override public function set rollDirection(value:String):void
		{
			super.rollDirection = value;
			_isRollLeftRight = value == RollDirectionDefined.ROLL_LEFT_TO_RIGHT;
		}
		
		override public function setup(reelInfo:ReelInfo, spdInfo:SpeedInfo):void
		{
			super.setup(reelInfo, spdInfo);
			_roundPix = totalWidth;
		}
		
		override public function get totalWidth():Number
		{
			return _reelInfo.symbolNum * (_reelInfo.symbolWidth + _reelInfo.symbolMarginLR * 2);
		}
		
		override public function get totalHeight():Number
		{
			return _reelInfo.symbolHeight + _reelInfo.symbolMarginTB * 2;
		}
		
		/**
		 * 默认执行一次 
		 * 
		 */		
		override protected function onDefaultSetting():void
		{
			super.onDefaultSetting();
			
			var startX:Number = reelInfo.reelStopType == ReelStopType.HALF ? -reelInfo.symbolWidth / 2 : 0;
			for (var i:uint = 0; i < _showListIds.length; i++)
			{
				var symblo:DisplayObject = _assetsLibs.getDisplayObject(_showListIds[i]);
				symblo.name = _showListIds[i];
				symblo.x = startX + i * (_reelInfo.symbolWidth + _reelInfo.symbolMarginLR * 2);
				symblo.x = Math.abs(symblo.x) < _reelInfo.symbolMarginLR ? (symblo.x > 0 ? _reelInfo.symbolMarginLR : -_reelInfo.symbolMarginLR) : symblo.x;
				
				symblo.y = _reelInfo.symbolMarginTB;
				
				_symbolContainter.addChild(symblo);
			}
			
			fullSymbol(_maxChildren - _showListIds.length);
			addSymblo(_rollingList[_rollIndex], true);
			_rollIndex = _rollIndex + 1 >= _rollingList.length ? 0 : (_rollIndex + 1); 
		}
		
		/**
		 * 添加元件 
		 * @param name
		 * 
		 */		
		override protected function addSymblo(name:String, isReper:Boolean = false):void
		{
			var symblo:DisplayObject = _assetsLibs.getDisplayObject(name);
			symblo.name = name;
			symblo.y = _reelInfo.symbolMarginTB;
			if (_isRollLeftRight && !isReper || (!_isRollLeftRight && isReper))
			{
				symblo.x = _symbolContainter.getRect(_symbolContainter).x - _reelInfo.symbolMarginLR - _reelInfo.symbolWidth;
			}
			else
			{
				symblo.x = _symbolContainter.getRect(_symbolContainter).x + _symbolContainter.getRect(_symbolContainter).width + _reelInfo.symbolMarginLR;
			}
			
			_symbolContainter.addChild(symblo);
		}
		
		/**
		 * 滚 
		 * 
		 */		
		override protected function onStartRolling():void
		{
			_symbolContainter.x += _rollSpeed;
			checkRound(_symbolContainter.x);
			
			var timeTick:int = getTimer();
			if (!_isVSpeedEnd)
			{
				//加速过程
				if (timeTick - _roolingDurtion > _speedInfo.spinDelay)
				{
					_isVSpeedEnd = true;
				}
				else
				{
					_rollSpeed += speedVel;
				}
			}
			else
			{
				//计时 => 停止
				if (timeTick - _roolingDurtion > _speedInfo.totalRunTime)
				{
					stop(true);
				}
			}
		}
		
		/**
		 * 手动停止轮子 
		 * 
		 */		
		override protected function onManalStop():void
		{
			_symbolContainter.x += _rollSpeed;
			
			var stopRule:Boolean = _isRollLeftRight ? _symbolContainter.x > _stopPos : _symbolContainter.x < _stopPos
			if (stopRule)
			{
				if (!_isRollLeftRight)
				{
					checkRound(_symbolContainter.x);
				}
				processStopEffect();
			}
			else
			{
				checkRound(_symbolContainter.x);
			}
		}
		
		/**
		 * 自定义停止效果 
		 * 
		 */		
		override protected function processStopEffect():void
		{
			super.processStopEffect();
			TweenLite.to(_symbolContainter, 0.2, {x:_stopPos + _rollSpeed, onComplete:rollUp, ease:Quad.easeOut});
			//停止
			function rollUp():void
			{
				TweenLite.to(_symbolContainter, 0.15, {x:_stopPos, onComplete:onRealStop, ease:Quad.easeIn });
			}
		}
		
		override protected function resetPos():void
		{
			var offset:Number = _isRollLeftRight ? _stopPos : -_stopPos;
			for (var i:uint = 0; i < _symbolContainter.numChildren; i++)
			{
				var o:DisplayObject = _symbolContainter.getChildAt(i);
				o.x += _stopPos;
			}
			super.resetPos();
		}
		
		override protected function onStartUpEffect():void
		{
			if (accInfo.upDistance > 0)
			{
				var upDis:Number = _isRollLeftRight ? accInfo.upDistance : -accInfo.upDistance;
				TweenLite.to(_symbolContainter, 0.5, {x:upDis, onComplete:onStartUpEffectEnd});
			}
			else
			{
				onStartUpEffectEnd();
			}
		}
		
		override protected function getExistObject(idx:uint):DisplayObject
		{
			var st:Number = _reelInfo.symbolMarginLR + idx * (_reelInfo.symbolWidth + _reelInfo.symbolMarginLR * 2); 
			var ed:Number = st + _reelInfo.symbolWidth + _reelInfo.symbolMarginLR * 2;
			var i:uint = 0;
			while (i > _symbolContainter.numChildren)
			{
				var o:DisplayObject = _symbolContainter.getChildAt(i);
				if (o.x >= st && o.x < ed)
				{
					return o;
				}
				i++;	
			}
			return null;
		}
		
		/**
		 * 手动停止之前调用 
		 * 
		 */		
		override protected function onBeforeStop():void
		{
			_rollSpeed = _isRollLeftRight ? speedStop : (0 - speedStop);
			removeOverSymblo();
			
			var tempShowIds:Array = _isRollLeftRight ? _showListIds.concat().reverse() : _showListIds;
			
			for (var i:uint = 0; i < tempShowIds.length; i++)
			{
				addSymblo(tempShowIds[i]);
			}
			var rect:Rectangle = _symbolContainter.getRect(_symbolContainter);
			_stopPos = _isRollLeftRight ? Math.abs(rect.x) : -(rect.x + rect.width - totalWidth);
			if (reelInfo.reelStopType == ReelStopType.HALF)
			{
				_stopPos += _isRollLeftRight ? -(reelInfo.symbolWidth / 2) : reelInfo.symbolWidth / 2;
			}
			onRoundChanged();
		}
		
		/**
		 * 删除多余的symblo 
		 * 
		 */		
		protected function removeOverSymblo():void
		{
			for (var i:uint = 0;i < _symbolContainter.numChildren; i++)
			{
				var child:DisplayObject = _symbolContainter.getChildAt(i);
				var needRemove:Boolean = _isRollLeftRight ? (0 - (child.x + _reelInfo.symbolWidth + _reelInfo.symbolMarginLR) > _symbolContainter.x) : (child.x - totalWidth > Math.abs(_symbolContainter.x));
				if (needRemove)
				{
					_symbolContainter.removeChild(child);
					i--;
				}
			}
		}
		
		override protected function get speedStart():Number
		{
			var speed:Number = _speedInfo.getVelocityStart(reelName);
			speed = _isRollLeftRight ? speed : (0 - speed);
			return speed;
		}
		
		override protected function get speedVel():Number
		{
			var speedV:Number = _speedInfo.getVelocityMax(reelName);
			speedV = _isRollLeftRight ? speedV : (0 - speedV);
			return speedV;
		}
		
		/*override protected function onSpeedChanged():void
		{
			
		}*/
	}
}