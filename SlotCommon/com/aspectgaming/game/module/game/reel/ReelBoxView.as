package com.aspectgaming.game.module.game.reel
{
	import com.aspectgaming.animation.iface.IAnimation;
	import com.aspectgaming.animation.phasor.PhasorPlayer;
	import com.aspectgaming.animation.sheet.SheetPlayer;
	import com.aspectgaming.game.component.event.ReelEvent;
	import com.aspectgaming.game.component.reels.IReel;
	import com.aspectgaming.game.component.symblo.BaseSybmloParse;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.reel.ReelInfo;
	import com.aspectgaming.game.config.reel.SpeedInfo;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.reel.ReelAction;
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.data.winshow.SymbloInfo;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.game.module.game.ReelFactory;
	import com.aspectgaming.game.utils.SlotUtil;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.PointUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	public class ReelBoxView extends BaseControlModule
	{
		private var _reels:Vector.<IReel>;
		private var _reelEndCount:uint;
		
		private var _stopAnis:Vector.<IAnimation>;
		private var _overAni:Vector.<IAnimation>;
		
		private var _isManuStop:Boolean;
		
		private var _currentScattorNum:uint;
		
		public function ReelBoxView(mc:MovieClip=null)
		{
			super(mc);
		}
		
		//========================== public =============================
		
		
		private function get stopAnis():Vector.<IAnimation>
		{
			if (!_stopAnis)
			{
				_stopAnis = new Vector.<IAnimation>();
			}
			return _stopAnis;
		}
		
		private function get overAnis():Vector.<IAnimation>
		{
			if (!_overAni)
			{
				_overAni = new Vector.<IAnimation>();
			}
			return _overAni;
		}
		
		/** tournament stopanis 排序
		 * 右下角为显示最低
		 * zy
		 * */
		public function sortStopAnis():void
		{
			stopAnis.sort(sortOnY);
			stopAnis.sort(sortOnX);
			for each (var ani:IAnimation in stopAnis)
			{
				(ani as DisplayObjectContainer).parent.setChildIndex((ani as DisplayObjectContainer), 0);
			}
		}
		
		private function sortOnX(a:SheetPlayer, b:SheetPlayer):Number
		{
			if(a.x > b.x) {
				return 1;
			} else if(a.x < b.x) {
				return -1;
			} else  {
				//aPrice == bPrice
				return 0;
			}
		}
		
		private function sortOnY(a:SheetPlayer, b:SheetPlayer):Number
		{
			if(a.y < b.y) {
				return 1;
			} else if(a.y > b.y) {
				return -1;
			} else  {
				//aPrice == bPrice
				return 0;
			}
		}
		
		public function start():void
		{
			_currentScattorNum = 0;
			_isManuStop = false;
			clearStopAni();
			clearOverStopAni();
			if (!isStart)
			{
				for (var i:uint = 0; i < _reels.length; i++)
				{
					_reels[i].start(i);
				}
			}
		}
		
		public function stop():void
		{
			for (var i:uint = 0; i < _reels.length; i++)
			{
				_reels[i].stop();
			}
			_isManuStop = true;
		}
		
		public function setSpeedInfo(spdInfo:SpeedInfo, isForever:Boolean = true):void
		{
			for each (var reel:IReel in _reels)
			{
				if (isForever)
				{
					reel.changeSpeedInfoForever(spdInfo);
				}
				else
				{
					reel.speedInfo = spdInfo;
				}
			}
		}
		
		public function get isStart():Boolean
		{
			for each (var reel:IReel in _reels)
			{
				if (reel.isRolling)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 二维数组 对应 每列轮子 
		 * @param arr
		 * 
		 */		
		public function setReelInfo(arr:Array):void
		{
			var rules:Vector.<ReelAction> = GameSetting.getRuleAction(arr);
			for (var i:uint = 0; i < arr.length; i++)
			{
				if (rules)
				{
					_reels[i].setRules(rules); 
				}
				if (i < _reels.length)
				{
					_reels[i].showListIds = arr[i];
				}
			}
		}
		
		/**
		 * 重新设置 当前显示元素 
		 * @param arr
		 * 
		 */		
		public function setSymblo(arr:Array):void
		{
			for (var i:uint = 0; i < _reels.length; i++)
			{
				if (!_reels[i].isRolling)
				{
					_reels[i].onGameModeChanged();
					_reels[i].defaultSymbol = arr[i];
				}
			}
		}
		
		//==============================================================
		
		override protected function init():void
		{
			_reels = new Vector.<IReel>();
			var reelInfos:Vector.<ReelInfo> = GameSetting.getReelInfoList();
			for each (var info:ReelInfo in reelInfos)
			{
				_reels.push(ReelFactory.createReel(info));
			}
			
			initReel();
			GameGlobalRef.gameManager.reelInfo = _reels;
			super.init();
		}
		
		private function initReel():void
		{
			_reels.sort(sortByName);	
			
			for each (var reel:IReel in _reels)
			{
				reel.show(this);
				reel.defaultSymbol = GameGlobalRef.gameData.getCurSymbloList(reel.reelName);
				reel.addEventListener(ReelEvent.REEL_END, onReelEnd);
				reel.addEventListener(ReelEvent.REEL_BEFORE_STOP, onReelBeforeStop);
			}
		}
		
		private function onReelEnd(e:ReelEvent):void
		{
			_reelEndCount++;
			checkReelStop(e.currentTarget as IReel);
			if (_reelEndCount >= _reels.length)
			{
				_reelEndCount = 0;
				dispatchToContext(new ReelEvent(ReelEvent.REEL_END));
			}
		}
		
		private function onReelBeforeStop(e:ReelEvent):void
		{
			if (GameGlobalRef.gameData.gameInfo.gameID == 79)
			{
				sortStopAnis();
			}
			if (!_isManuStop)
			{
				SoundManager.playSound(SlotSoundDefined.REEL_SPIN + (_reels.indexOf(e.currentTarget as IReel) + 1));
			}
		}
		
		/**
		 * 检测是否有轮子停止的动画
		 * 
		 */		
		private function checkReelStop(reel:IReel):void
		{			
			if (reel.showListIds)
			{
				for (var i:uint = 0; i < reel.showListIds.length; i++)
				{
					if (GameGlobalRef.gameManager.isScatterSymble(reel.showListIds[i]))
					{
						//该scatter在HITTED范围之内
						if (GameGlobalRef.gameManager.checkScattarHitted(++_currentScattorNum, reel.reelIndex))
						{
							SoundManager.playSound(SlotSoundDefined.REEL_SC_STOP + _currentScattorNum);
							dispatchToContext(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, SlotUtil.getScatterInfoMsg()));
						}
						else
						{
							if (GameSetting.hasWinLine)
							{
								return;
							}
						}
					}
						
					var mc:MovieClip = GameAssetLibrary.symbolLibrary.getAniObject(reel.showListIds[i], true);
					var stopOver:MovieClip = (GameAssetLibrary.symbolLibrary as BaseSybmloParse).getAniOverObject(reel.showListIds[i]);
					if (mc)
					{
						var currentSymblo:DisplayObject = reel.getCurrentDisplayObject(i);
						var sheet:SheetPlayer = new SheetPlayer(mc);
						sheet.x = GameSetting.reelPos.x + reel.reelInfo.x + currentSymblo.x;
						sheet.y = GameSetting.reelPos.y + reel.reelInfo.y + currentSymblo.y;
						GameLayerManager.uilayer.addChild(sheet); 

						stopAnis.push(sheet);
						sheet.start();
						
						if (stopOver)
						{
							var overSheet:SheetPlayer = new SheetPlayer(stopOver);
							overSheet.x = sheet.x;
							overSheet.y = sheet.y;
							GameLayerManager.lowLayer.addChildAt(overSheet, 0);
							overAnis.push(overSheet);
							overSheet.start();
						}
						
					}
				}
			}
		}
		
		public function clearStopAni():void
		{
			for each (var ani:IAnimation in _stopAnis)
			{
				ani.dispose();
			}
			stopAnis.length = 0;
		}
		
		public function clearOverStopAni():void
		{
			for each (var ani:IAnimation in _overAni)
			{
				ani.dispose();
			}
			stopAnis.length = 0;
		}
		
		private function sortByName(a:IReel, b:IReel):int
		{
			var nameA:uint = uint(a.reelName.substr(1));
			var nameB:uint = uint(b.reelName.substr(1));
			if (nameA > nameB)
			{
				return 1;
			}
			else if (nameA == nameB)
			{
				return 0;
			}
			else
			{
				return -1;
			}
		}
		
		override protected function addEvent():void
		{
			
		}
		
		override protected function removeEvent():void
		{
			
		}
		
		
		
		override public function dispose():void
		{
			clearStopAni();
			clearOverStopAni();
			super.dispose();
			for each (var reel:IReel in _reels)
			{
				
				reel.removeEventListener(ReelEvent.REEL_END, onReelEnd);
				reel.removeEventListener(ReelEvent.REEL_BEFORE_STOP, onReelBeforeStop);
				reel.dispose();
			}
			_reels = null;
		}
	}
}