package com.aspectgaming.game.component.reels
{
	import com.aspectgaming.game.config.reel.ReelInfo;
	import com.aspectgaming.game.config.reel.SpeedInfo;
	import com.aspectgaming.game.constant.ReelStopType;
	import com.aspectgaming.game.constant.RollDirectionDefined;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.ui.iface.IAssetLibrary;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * 纵向滚动轮子 
	 * 再次扩展 请不要使用继承 改用 组合方式 - 装饰器
	 * @author mason.li
	 * 
	 */	
	public class VerticalReel extends AbstractReel
	{
		/**
		 * 滚动方向  是否从上往下(默认) 或者 从下往上 
		 */		
		private var _isRollTopBottom:Boolean;
		
		public function VerticalReel(symbloLibs:IAssetLibrary)
		{
			super(symbloLibs);
		}
		
		override public function set rollDirection(value:String):void
		{
			super.rollDirection = value;
			_isRollTopBottom = value == RollDirectionDefined.ROLL_TOP_TO_BOTTOM;
		}
		
		override public function setup(reelInfo:ReelInfo, spdInfo:SpeedInfo):void
		{
			super.setup(reelInfo, spdInfo);
			_roundPix = totalHeight;
		}
		
		/**
		 * 默认执行一次 
		 * 
		 */		
		override protected function onDefaultSetting():void
		{
			super.onDefaultSetting();
			var startY:Number = reelInfo.reelStopType == ReelStopType.HALF ? -reelInfo.symbolHeight / 2 : 0;
			
			for (var i:uint = 0; i < _showListIds.length; i++)
			{
				var symblo:DisplayObject = _assetsLibs.getDisplayObject(_showListIds[i]);
				symblo.name = _showListIds[i];
				
				symblo.x = _reelInfo.symbolMarginLR;
				symblo.y = startY + i * (_reelInfo.symbolHeight + _reelInfo.symbolMarginTB * 2);
				symblo.y = Math.abs(symblo.y) < _reelInfo.symbolMarginTB ? (symblo.y > 0 ? _reelInfo.symbolMarginTB : -_reelInfo.symbolMarginTB) : symblo.y;
				
				_symbolContainter.addChild(symblo);
			}
			
			fullSymbol(_maxChildren - _showListIds.length);
			addSymblo(_rollingList[_rollIndex], true);
			_rollIndex = _rollIndex + 1 >= _rollingList.length ? 0 : (_rollIndex + 1); 
		}
		
		/**
		 * 添加元件 
		 * @param name
		 * @param isReper 是否为反向添加
		 * 
		 */		
		override protected function addSymblo(name:String, isReper:Boolean = false):void
		{
			var symblo:DisplayObject = _assetsLibs.getDisplayObject(name);
			symblo.name = name;
			symblo.x = _reelInfo.symbolMarginLR;
			if (_isRollTopBottom && !isReper || (!_isRollTopBottom && isReper))
			{
				symblo.y = _symbolContainter.getRect(_symbolContainter).y - _reelInfo.symbolMarginTB - _reelInfo.symbolHeight;
			}
			else
			{
				symblo.y = _symbolContainter.getRect(_symbolContainter).y + _symbolContainter.getRect(_symbolContainter).height + _reelInfo.symbolMarginTB;
			}
			
			_symbolContainter.addChild(symblo);
		}
		
		/**
		 * 滚 
		 * 
		 */		
		override protected function onStartRolling():void
		{
			_symbolContainter.y += _rollSpeed;
			checkRound(_symbolContainter.y);
			
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
			_symbolContainter.y += _rollSpeed;
			
			var stopRule:Boolean = _isRollTopBottom ? _symbolContainter.y > _stopPos : _symbolContainter.y < _stopPos
			if (stopRule)
			{
				if (!_isRollTopBottom)
				{
					checkRound(_symbolContainter.y);
				}
				processStopEffect();
			}
			else
			{
				checkRound(_symbolContainter.y);
			}
		}
		
		/**
		 * 自定义停止效果 
		 * 
		 */		
		override protected function processStopEffect():void
		{
			super.processStopEffect();
			var stopSpeed:Number = _isRollTopBottom ? accInfo.stopDistance : -accInfo.stopDistance;
			var stopDur:Number = accInfo.stopDur;
			
			TweenLite.to(_symbolContainter, stopDur / 2, {y:_stopPos + stopSpeed, onComplete:rollUp, ease:Quad.easeOut});
			//停止
			function rollUp():void
			{
				TweenLite.to(_symbolContainter, stopDur / 2, {y:_stopPos, onComplete:onRealStop, ease:Quad.easeIn });
			}
		}
		
		override protected function resetPos():void
		{
			var offset:Number = _isRollTopBottom ? _stopPos : -_stopPos;
			for (var i:uint = 0; i < _symbolContainter.numChildren; i++)
			{
				var o:DisplayObject = _symbolContainter.getChildAt(i);
				o.y += _stopPos;
			}
			super.resetPos();
		}
		
		override protected function getExistObject(idx:uint):DisplayObject
		{
			var st:Number = _reelInfo.symbolMarginTB + idx * (_reelInfo.symbolHeight + _reelInfo.symbolMarginTB * 2); 
			var ed:Number = st + _reelInfo.symbolHeight + _reelInfo.symbolMarginTB * 2;
			var i:uint = 0;
			while (i < _symbolContainter.numChildren)
			{
				var o:DisplayObject = _symbolContainter.getChildAt(i);
				if (o.y >= st && o.y < ed)
				{
					return o;
				}
				i++;	
			}
			return null;
		}
		
		override protected function onStartUpEffect():void
		{
			if (accInfo.upDistance > 0)
			{
				var upDis:Number = _isRollTopBottom ? -accInfo.upDistance : accInfo.upDistance;
				TweenLite.to(_symbolContainter, accInfo.upDurtion, {y:upDis, onComplete:onStartUpEffectEnd});
			}
			else
			{
				onStartUpEffectEnd();
			}
		}
		
		/**
		 * 手动停止之前调用 
		 * 
		 */		
		override protected function onBeforeStop():void
		{
			_rollSpeed = _isRollTopBottom ? speedStop : (0 - speedStop);
			
			removeOverSymblo();
			var tempShowIds:Array = _isRollTopBottom ? _showListIds.concat().reverse() : _showListIds;
			
			for (var i:uint = 0; i < tempShowIds.length; i++)
			{
				addSymblo(tempShowIds[i]);
			}
			var rect:Rectangle = _symbolContainter.getRect(_symbolContainter);
			_stopPos = _isRollTopBottom ? Math.abs(rect.y) : -(rect.y + rect.height - totalHeight);

			if (reelInfo.reelStopType == ReelStopType.HALF)
			{
				_stopPos += _isRollTopBottom ? -(reelInfo.symbolHeight / 2) : reelInfo.symbolHeight / 2;
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
				var needRemove:Boolean = _isRollTopBottom ? (0 - (child.y + _reelInfo.symbolHeight + _reelInfo.symbolMarginTB) > _symbolContainter.y) : (child.y - totalHeight > Math.abs(_symbolContainter.y));
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
			speed = _isRollTopBottom ? speed : (0 - speed);
			return speed;
		}
		
		override protected function get speedVel():Number
		{
			var speedV:Number = _speedInfo.getVelocityMax(reelName);
			speedV = _isRollTopBottom ? speedV : (0 - speedV);
			return speedV;
		}
		
		/*override protected function onSpeedChanged():void
		{
			
		}*/
	}
}