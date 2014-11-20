package com.aspectgaming.game.module.uicontrol.control
{
	import com.aspectgaming.game.component.event.ReelEvent;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.GameModuleDefined;
	import com.aspectgaming.game.constant.GamePlayType;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.constant.GameTickConstant;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.game.module.uicontrol.control.component.MeterWord;
	import com.aspectgaming.game.module.uicontrol.iface.ISlotControl;
	import com.aspectgaming.game.utils.display.text.TextAutoFix;
	import com.aspectgaming.ui.FrameButton;
	import com.aspectgaming.ui.event.ComponentEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class UiFreeControl extends BaseControlModule implements ISlotControl
	{
		protected var _enable:Boolean;
		protected var _playBtn:FrameButton;
		protected var _totalTimesTxt:TextField;
		protected var _remainTimesTxt:TextField;
		protected var _betText:TextField;
		protected var _winMeter:MeterWord;
		protected var _totalWonText:TextField;
		
		private var _creditsText:TextField;
		private var _txtAutoFix:TextAutoFix;
		
		private var _isPause:Boolean;
		private var _isAutoWaitted:Boolean;
		
		public function UiFreeControl(mc:MovieClip)
		{
			super(mc);
		}
		
		public function get winMeter():MeterWord
		{
			return _winMeter;
		}

		override protected function init():void
		{
			_playBtn = new FrameButton(_mc["btnPlay"]);
			_creditsText = _mc["mCredits"]["_txt"];
			
			_totalTimesTxt = _mc["freeTIdx"]["_txt"];
			
			_remainTimesTxt = _mc["freeIdx"]["_txt"];
			
			_betText = _mc["mTotalbet"]["_txt"];
			
			_winMeter = new MeterWord(_mc["mWin"], "_txt", 0);
			
			_creditsText = _mc["mCredits"]["_txt"];
			_creditsText.wordWrap = false;
			_txtAutoFix = new TextAutoFix(_creditsText);
			_totalWonText = _mc["freeWins"]["_txt"];
			
			updateBetInfo();
			updateTotalWin();
			
			super.init();
		}
		
		override public function show(par:DisplayObjectContainer, x:Number=0, y:Number=0):void
		{
			super.show(par, x, y);
			enable = true;
			_playBtn.setFrame(1);
			
			updateBetInfo();
			updateBalanceInfo();
			updateTotalWin();
			_winMeter.text = GameGlobalRef.freeGameInfo.totalWinAddBase.toString();
			
			dispatchToContext(new SlotEvent(SlotEvent.GAME_AUTO_MODE_CHANGED, true, GameStatue.FREEGAME));
		}
		
		public function enableControlBtn():void
		{
			_playBtn.enabled = true;
		}
		
		public function onAutoPlay(e:SlotUIEvent = null):void
		{
			if (!_isPause)
			{
				if (_winMeter.isRolling)
				{
					_winMeter.addEventListener(Event.COMPLETE, onMeterComplete);
					return;
				}
				_playBtn.setFrame(2);
				onPlayClicked();
			}
			else
			{
				_isAutoWaitted = true;
			}
		}
		
		private function onMeterComplete(e:Event):void
		{
			_winMeter.removeEventListener(Event.COMPLETE, onMeterComplete);
			onAutoPlay();
		}
		
		/**
		 * REEL END 
		 * @param type
		 * 
		 */		
		public function changeButtonStatue(type:String):void
		{
			if (type == ReelEvent.REEL_END)
			{
				//auto play
				_playBtn.setFrame(1);
				enableControlBtn();
				updateWinMeter();
			}
			else
			{
				_playBtn.setFrame(2);
				_playBtn.enabled = false;
			}
		}
		
		public function set pause(value:Boolean):void
		{
			_isPause = value;
			if (!_isPause && _isAutoWaitted)
			{
				_isAutoWaitted = false;
				onAutoPlay();
			}
		}
		
		public function afterPlayClick():void
		{
			enable = false;
			_playBtn.setFrame(2);
			_winMeter.reset();
		}
		
		protected function onPlayClicked(e:ComponentEvent = null):void
		{
			GameGlobalRef.gameManager.gameTick.removeTimeout(GameTickConstant.AUTO_PLAY_DELAY);
			enable = false;
			if (!e || e.data == 2)
			{
				//play
				updateTotalWin();
				trace("CurrentStatue:", GameGlobalRef.gameData.currentStatue);
				if (GameGlobalRef.freeGameInfo.isCurrentWin)
				{
					_winMeter.reset();
					_winMeter.text = GameGlobalRef.freeGameInfo.currentWon.toString();
				}
				
				if (GameGlobalRef.gameData.currentStatue == GameStatue.FREE_GAME_OUTRO)
				{
					_playBtn.setFrame(1);
					updateBetData();
					dispatchToContext(new SlotEvent(SlotEvent.GAME_CHECK_STATUE));
					return;
				}
				
				_winMeter.text = "0";
				_remainTimesTxt.text = Math.max(0, uint(_remainTimesTxt.text) - 1).toString();
				dispatchToContext(new SlotEvent(SlotEvent.GAME_PLAY, null, GameGlobalRef.gameInfo.isFreeSpin ? GamePlayType.FREE_SPIN_PLAY : GamePlayType.FREE_GAME_PLAY));
			}
			else
			{
				dispatchToContext(new SlotEvent(SlotEvent.GAME_STOP));
			}
		}
		
		public function takeWinEnd():void
		{
			
		}
		
		public function updateBalanceInfo():void
		{
			_creditsText.text = GameGlobalRef.gameData.totalDollar.toString();
			_txtAutoFix.fix();
		}
		
		
		public function set enable(value:Boolean):void
		{
			_enable = value;
			_playBtn.enabled = _enable;
			
		}
		
		public function get isAutoPlay():Boolean
		{
			return true;
		}
		
		private function updateWinMeter():void
		{
			if (GameGlobalRef.freeGameInfo.isCurrentWin)
			{
				_winMeter.meterNumber = GameGlobalRef.freeGameInfo.currentWon;
			}
			else
			{
				GameGlobalRef.gameManager.gameTick.addTimeout(onAutoPlay, GameSetting.AUTO_PLAY_LOST_DELAY, GameTickConstant.AUTO_PLAY_DELAY);
			}
		}
		
		public function updateBetInfo(isNormal:Boolean = true):void
		{
			if (!(GameGlobalRef.freeGameInfo.needAniMovie && isNormal))
			{
				_totalTimesTxt.text = GameGlobalRef.freeGameInfo.totalTimes.toString();
				_remainTimesTxt.text = GameGlobalRef.freeGameInfo.remainTimes.toString();
			}
			var bet:Number=GameGlobalRef.gameManager.currentBet;
			_betText.text = GameGlobalRef.gameManager.currentBet.toString();
		}
		
		public function updateTotalWin():void
		{
			_totalWonText.text = GameGlobalRef.freeGameInfo.totalWinAddBase.toString();
		}
		
		override protected function addEvent():void
		{
			_playBtn.addEventListener(ComponentEvent.FRAME_CHANGED, onPlayClicked);
			super.addEvent();
		}
		
		override protected function removeEvent():void
		{
			_playBtn.removeEventListener(ComponentEvent.FRAME_CHANGED, onPlayClicked);
			super.removeEvent();
		}
		
		override public function dispose():void
		{
			super.dispose();
			_winMeter.removeEventListener(Event.COMPLETE, onMeterComplete);
			_winMeter.dispose();
			_winMeter = null;
			_playBtn.dispose();
			_playBtn = null;
		}
		
		/**
		 * 最大化 WIN 显示 
		 * 
		 */		
		public function updateBetData():void
		{
			_winMeter.text = _totalWonText.text;
		}
		
		
	}
}