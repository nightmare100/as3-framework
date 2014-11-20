package com.aspectgaming.game.component.reels
{
	import com.aspectgaming.game.component.event.ReelEvent;
	import com.aspectgaming.game.config.reel.ReelAcceleration;
	import com.aspectgaming.game.config.reel.ReelInfo;
	import com.aspectgaming.game.config.reel.SpeedInfo;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.reel.ReelAction;
	import com.aspectgaming.ui.iface.IAssetLibrary;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.FiltersUtil;
	import com.aspectgaming.utils.PointUtil;
	import com.aspectgaming.utils.tick.FrameRender;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	[Event(name="reelStart", type="com.aspectgaming.game.component.event.ReelEvent")]
	[Event(name="reelEnd", type="com.aspectgaming.game.component.event.ReelEvent")]
	[Event(name="reelStop", type="com.aspectgaming.game.component.event.ReelEvent")]
	
	/**
	 * 轮子抽象类 
	 * @author mason.li
	 * 
	 */	
	internal class AbstractReel extends Sprite implements IReel
	{
		protected var _maxChildren:uint;
		
		protected var _isRolling:Boolean; 
		/**
		 * 元件容器 
		 */		
		protected var _symbolContainter:Sprite;
		
		/**
		 * 滚动速度 
		 */		
		protected var _rollSpeed:Number = 0;		
		
		protected var _reelInfo:ReelInfo;
		protected var _speedInfo:SpeedInfo;
		
		protected var _rollDirection:String;
		
		protected var _assetsLibs:IAssetLibrary;
		
		/**
		 * 滚动时间 
		 */		
		protected var _roolingDurtion:Number;
		/**
		 * 滚动顺序 
		 */		
		protected var _rollingList:Array;
		
		/**
		 * 当前滚动位置的索引 （单位 元件）
		 */		
		protected var _rollIndex:uint;
		
		protected var _showListIds:Array;			
		
		protected var _timeTick:uint;
		
		/**
		 * 当前回合数 
		 */		
		protected var _currentRound:uint;
		
		/**
		 * 一回合的 尺度 
		 */		
		protected var _roundPix:Number;
		
		/**
		 * 停止坐标 
		 */		
		protected var _stopPos:Number;
		
		/**
		 * 轮子特殊事件
		 */		
		protected var _reelSpeicalAction:ReelAction;
		
		/**
		 * 默认速度 
		 */		
		private var _defaultSpeedInfo:SpeedInfo;
		
		public function AbstractReel(symbloLibs:IAssetLibrary)
		{
			_assetsLibs = symbloLibs;
			super();
		}
		
		public function get reelInfo():ReelInfo
		{
			return _reelInfo;
		}

		/**
		 * 当前停止的显示列表 索引 
		 */
		public function get showListIds():Array
		{
			return _showListIds;
		}

		public function set showListIds(value:Array):void
		{
			_showListIds = value;
		}
		
		public function get isRolling():Boolean
		{
			return _isRolling;
		}
		
		public function setup(reelInfo:ReelInfo, spdInfo:SpeedInfo):void
		{
			_reelInfo = reelInfo;
			_defaultSpeedInfo = spdInfo;
			_speedInfo = spdInfo;
			_maxChildren = _reelInfo.symbolNum * 3;
			this.scrollRect = new Rectangle(0, 0, totalWidth, totalHeight);
			onGameModeChanged();
			addEventListener(MouseEvent.CLICK, onReelClick);
		}
		
		protected function onReelClick(e:MouseEvent):void
		{
			if (!isRolling)
			{
				var pt:Point = PointUtil.localToGoble(this);
				var vdic:Number = e.stageY - pt.y;
				var idx:uint = uint(vdic / (_reelInfo.symbolHeight + _reelInfo.symbolMarginTB * 2));
				ReelActionCommand.handlerClick(getCurrentDisplayObject(idx));
			}
		}
		
		public function onGameModeChanged():void
		{
			_rollingList = _reelInfo.showSortList;
			_rollIndex = 0;
		}
		
		/**
		 * 设置规则 
		 * @param rules
		 * 
		 */		
		public function setRules(rules:Vector.<ReelAction>):void
		{
			for each (var action:ReelAction in rules)
			{
				if (action.reelIndex == reelIndex)
				{
					_reelSpeicalAction = action;
					_reelSpeicalAction.reel = this;
					return;
				}
			}
		}
		
		public function set rollDirection(value:String):void
		{
			_rollDirection = value;
		}
		
		public function get totalWidth():Number
		{
			return _reelInfo.symbolWidth + _reelInfo.symbolMarginLR * 2;
		}
		
		public function get totalHeight():Number
		{
			return _reelInfo.symbolNum * (_reelInfo.symbolHeight + _reelInfo.symbolMarginTB * 2);
		}
		
		public function show(par:DisplayObjectContainer):void
		{
			this.x = _reelInfo.x;
			this.y = _reelInfo.y;
			par.addChild(this);
		}
		
		public function start(reelIndex:uint):void
		{
			if (!isRolling)
			{
				ReelActionCommand.clearAllClickAnimation();
				
				var delay:uint = _speedInfo.startDelay * reelIndex;
				
				_currentRound = 0;
				_rollSpeed = speedStart;
				
				TweenLite.killTweensOf(_symbolContainter);
				_speedInfo = _defaultSpeedInfo;
				_showListIds = null;
				_reelSpeicalAction = null;
				_isInStop = false;
				_timeTick = setTimeout(startRolling, delay);
			}
		}
		
		protected function clearStopTimeout():void
		{
			clearTimeout(_stopTick);
			_stopTick = -1;
		}
		
		protected function delayStop(isAutoStop:Boolean):void
		{
			TweenLite.killTweensOf(_symbolContainter)
			clearTimeout(_timeTick);
			clearStopTimeout();
			GameGlobalRef.gameManager.frameRender.removeRender(onStartRolling);
			onBeforeStop();
			GameGlobalRef.gameManager.frameRender.addRender(onManalStop);
			dispatchEvent(new ReelEvent(ReelEvent.REEL_STOP, isAutoStop));
		}
		
		/**
		 * 停止轮子转动 
		 * isAutoStop 是否为自动停止 还是 主动停止 
		 */		
		public function stop(isAutoStop:Boolean = false):void
		{
			if (!_isInStop || (_isInStop && !isAutoStop && _stopTick != -1))
			{
				if (isAutoStop && _reelSpeicalAction)
				{
					ReelActionCommand.execute(_reelSpeicalAction)
					return;
				}
				
				if (isStopListGetted)
				{
					_isInStop = true;
					if (isAutoStop)
					{
						if (_stopTick == -1)
						{
							_stopTick = setTimeout(function():void{delayStop(true)} ,_speedInfo.stopDelay * (_reelInfo.reelIndex - 1));
							return;
						}
					}
					else
					{
						clearStopTimeout();
					}
					delayStop(isAutoStop);
				}
			}
		}
		
		/**
		 * 轮子完全停止 
		 * 
		 */		
		protected function onRealStop():void
		{
			_symbolContainter.y = _stopPos;
			GameGlobalRef.gameManager.frameRender.removeRender(onStartRolling);
			GameGlobalRef.gameManager.frameRender.removeRender(onManalStop);
			resetPos();
			_isRolling = false;

			clearTimeout(_timeTick);
			dispatchEvent(new ReelEvent(ReelEvent.REEL_END));
		}
		
		/**
		 * 坐标重置 0,0 
		 * 
		 */		
		protected function resetPos():void
		{
			_symbolContainter.x = _symbolContainter.y = 0;
		}
		
		public function set speedInfo(info:SpeedInfo):void
		{
			_speedInfo = info;
			onSpeedChanged();
		}
		
		public function changeSpeedInfoForever(info:SpeedInfo):void
		{
			_defaultSpeedInfo = info;
			_speedInfo = _defaultSpeedInfo;
			onSpeedChanged();
		}
		
		/**
		 * 放置默认元素 
		 * 
		 */		
		protected function onDefaultSetting():void
		{
			if (!_symbolContainter)
			{
				_symbolContainter = new Sprite();
				addChild(_symbolContainter);
			}
			else
			{
				while (_symbolContainter.numChildren > 0)
				{
					_symbolContainter.removeChildAt(0);
				}
			}
		}
		
		/**
		 * 填充元件  
		 * @param num 数量
		 * 
		 */		
		protected function fullSymbol(num:uint):void
		{
			checkSybmloList();
			while (num-- > 0)
			{
				var name:String = _rollingList[_rollIndex];
				addSymblo(name);
				
				_rollIndex = _rollIndex + 1 >= _rollingList.length ? 0 : (_rollIndex + 1); 
			}
		}
		
		protected function addSymblo(name:String, isReper:Boolean = false):void
		{
			
		}
		
		/**
		 * 检测元件队列 
		 * 
		 */		
		protected function checkSybmloList():void
		{
			while (_symbolContainter.numChildren > _maxChildren)
			{
				var child:DisplayObject = _symbolContainter.removeChildAt(0);
			}
		}
		
		protected function startRolling():void
		{
			_isRolling = true;
			_roolingDurtion = getTimer();
			_isVSpeedEnd = false;
			
			dispatchEvent(new ReelEvent(ReelEvent.REEL_START));
			
			onStartUpEffect();
		}
		
		protected function onStartUpEffect():void
		{
			
		}
		
		protected function onStartUpEffectEnd():void
		{
			GameGlobalRef.gameManager.frameRender.addRender(onStartRolling);
		}
		
		
		/**
		 * 手动停止之前执行 
		 * 
		 */		
		protected function onBeforeStop():void
		{
			
		}
		
		/**
		 * 手动停止 
		 * 
		 */		
		protected function onManalStop():void
		{
			
		}
		
		/**
		 * 开始滚 
		 * 
		 */		
		protected function onStartRolling():void
		{
			
		}
		
		/**
		 * 处理停止效果 
		 * 
		 */		
		protected function processStopEffect():void
		{
			this.filters = [];
			GameGlobalRef.gameManager.frameRender.removeRender(onManalStop);
			dispatchEvent(new ReelEvent(ReelEvent.REEL_BEFORE_STOP));
			
		}
		
		
		
		
		/**
		 * 判断滚动的圈数 
		 * 
		 */		
		protected function checkRound(pos:Number):void
		{
			var roundNum:uint = uint(Math.abs(pos / _roundPix));
			if (roundNum > _currentRound)
			{
				_currentRound = roundNum;
				onRoundChanged();
			}
		}
		
		/**
		 * 圈数更新 
		 * 
		 */		
		protected function onRoundChanged():void
		{
			fullSymbol(_reelInfo.symbolNum);
		}
		
		/**
		 * 速度等级变化 
		 * 
		 */		
		protected function onSpeedChanged():void
		{
			if (isRolling)
			{
				_roolingDurtion = getTimer();
				_isVSpeedEnd = false;
				_reelSpeicalAction = null;
				if (useBlur)
				{
					this.filters = [FiltersUtil.BLUR_FILTER];
				}
			}
		}
		
		public function get reelName():String
		{
			return _reelInfo.name;
		}
		
		public function get reelIndex():uint
		{
			return uint(reelName.substr(reelName.length - 1));
		}
		
		/**
		 * 获取当前停止时的元件 
		 * @param idx
		 * @return 
		 * 
		 */		
		public function getCurrentDisplayObject(idx:uint):DisplayObject
		{
			if (!_showListIds)
			{
				return null;
			}
			else
			{
				return getExistObject(idx);
			}
		}
		
		protected function getExistObject(idx:uint):DisplayObject
		{
			return null;
		}
		
		public function dispose():void
		{
			GameGlobalRef.gameManager.frameRender.removeRender(onManalStop);
			GameGlobalRef.gameManager.frameRender.removeRender(onStartRolling);
			clearStopTimeout();
			
			TweenLite.killTweensOf(_symbolContainter);
			clearTimeout(_timeTick);
			_reelInfo = null;
			_speedInfo = null;
			
			DisplayUtil.removeFromParent(_symbolContainter);
			DisplayUtil.removeFromParent(this);
			_symbolContainter = null;
		}
		
		protected function get speedStart():Number
		{
			return _speedInfo.getVelocityStart(reelName);
		}
		
		protected function get accInfo():ReelAcceleration
		{
			return _speedInfo.getAccInfo(reelName);
		}
		
		protected function get speedVel():Number
		{
			return _speedInfo.getVelocityMax(reelName);
		}
		
		protected function get speedStop():Number
		{
			return _speedInfo.getVelocityStop(reelName);
		}
		
		protected function get useBlur():Boolean
		{
			return _speedInfo.useBlur(reelName);
		}
		
		public function set defaultSymbol(list:Array):void
		{
			if (!list || list.length < _reelInfo.symbolNum)
			{
				fullRandomList();
			}
			else
			{
				_showListIds = list;
			}
			onDefaultSetting();
		}
		
		private function fullRandomList():void
		{
			var defList:Array = _reelInfo.getDefaultSymbol();
			if (defList)
			{
				_showListIds = defList;
			}
			else
			{
				var idx:uint = uint(Math.random() * (_rollingList.length - _reelInfo.symbolNum));
				_showListIds = _rollingList.slice(idx, idx + _reelInfo.symbolNum);
				_rollIndex = idx + _reelInfo.symbolNum;
			}
		}
		
		/**
		 * 是否进入停止
		 */		
		protected var _isInStop:Boolean;
		
		/**
		 * 加速结束 
		 */		
		protected var _isVSpeedEnd:Boolean;
		
		/**
		 * 停止的tick 
		 */		
		protected var _stopTick:int = -1;
		
		/**
		 * 是否已获取停止时的显示列表 
		 * @return 
		 * 
		 */		
		protected function get isStopListGetted():Boolean
		{
			return _showListIds != null;
		}
	}
}