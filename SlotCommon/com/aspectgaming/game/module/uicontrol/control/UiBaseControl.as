package com.aspectgaming.game.module.uicontrol.control
{
	import com.aspectgaming.constant.CoinType;
	import com.aspectgaming.constant.ComeFromSource;
	import com.aspectgaming.constant.TrackPath;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.game.component.SoundButton;
	import com.aspectgaming.game.component.event.ReelEvent;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GambleType;
	import com.aspectgaming.game.constant.GameModuleDefined;
	import com.aspectgaming.game.constant.GamePlayType;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.constant.GameTickConstant;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.BussinessEvent;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.module.gamble.GambleModule;
	import com.aspectgaming.game.module.game.iface.IAutoPlay;
	import com.aspectgaming.game.module.uicontrol.control.component.AutoPlayButton;
	import com.aspectgaming.game.module.uicontrol.control.component.MeterWord;
	import com.aspectgaming.game.module.uicontrol.iface.ISlotControl;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.SlotServerManager;
	import com.aspectgaming.game.utils.SlotUtil;
	import com.aspectgaming.game.utils.display.text.TextAutoFix;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	import com.aspectgaming.ui.FrameButton;
	import com.aspectgaming.ui.NumericControl;
	import com.aspectgaming.ui.event.ComponentEvent;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.NumberUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class UiBaseControl extends BaseControlModule implements ISlotControl
	{
		protected var _enable:Boolean;
		
		protected var _gambleMsg:MovieClip;
		protected var _helpBtn:FrameButton;
		protected var _creditsTxt:TextField;
		protected var _txtAutoFix:TextAutoFix;
		
		protected var _betText:TextField;
		protected var _gambleBtn:SoundButton;
		
		protected var _betMaxBtn:SoundButton;
		protected var _dragonPlayBtn:SoundButton;
		protected var _playBtn:FrameButton;
		
		protected var _powerTips:MovieClip;
		protected var _wordMeter:MeterWord;
		
		protected var _autoPlayBtn:IAutoPlay;
		
		protected var _lineNumberCon:NumericControl;
		protected var _betLineCashCon:NumericControl;
		
		protected var _autoPlayTimes:uint;
		
		protected var _isPause:Boolean;
		protected var _isAutoWaitted:Boolean;
		
		public function UiBaseControl(mc:MovieClip)
		{
			super(mc);
		}
		
		public function get winMeter():MeterWord
		{
			return _wordMeter;
		}
		
		override protected function init():void
		{
			_helpBtn = new FrameButton(_mc["btnHelp"]);
			_betText = _mc["mTotalbet"]["_txt"];
			_gambleMsg = _mc["mGamble"];
			_gambleBtn = new SoundButton(_gambleMsg["btnGamble"]);
			_wordMeter = new MeterWord(_mc["mWin"], "_txt", 0);
			
			_betMaxBtn = new SoundButton(_mc["btnBetmax"]);	
			if(_mc["btnPowerPlay"])
			{
				_dragonPlayBtn = new SoundButton(_mc["btnPowerPlay"]);
				
				if (GameGlobalRef.gameInfo.clientSource == ComeFromSource.SOURCE_ONLINE)
				{
					_dragonPlayBtn.visible = false;
				}
			}
			
			if(_mc["powerTips"])
			{
				_powerTips = _mc["powerTips"];
			}
			
			if(_powerTips != null)
			{
				_powerTips.mouseEnabled = false;
				_powerTips.mouseChildren = false;
				_powerTips.visible = false;
			}
			_creditsTxt = _mc["mCredits"]["_txt"];
			_creditsTxt.wordWrap = false;
			_txtAutoFix = new TextAutoFix(_creditsTxt);
			
			_playBtn  = new FrameButton(_mc["btnPlay"]);
			_autoPlayBtn = new AutoPlayButton(_mc["btnAuto"], _mc["autoSpins"], _mc["autoSetting"]);
			
			_lineNumberCon = new NumericControl(_mc["cbxLines"], GameGlobalRef.gameManager.betLineMax,  GameGlobalRef.gameManager.betLineMin, GameGlobalRef.gameManager.betLineMax, !NewPlayerGuidManager.isInGuild);
			_betLineCashCon = new NumericControl(_mc["cbxBet"], GameGlobalRef.gameManager.betCashEachLineMax, GameGlobalRef.gameManager.betCashEachLineMin, GameGlobalRef.gameManager.betCashEachLineMax, !NewPlayerGuidManager.isInGuild);
			_betLineCashCon.filterArr = GameSetting.betLineFilter;
			updateBetInfo();
			updateBalanceInfo();
			
			
			
			super.init();
		}
		
		public function updateBetInfo(isNormal:Boolean = true):void
		{
			_betLineCashCon.currentValue = GameGlobalRef.gameManager.currentEachLineCash;
			_lineNumberCon.currentValue = GameGlobalRef.gameManager.currentBetLine;
			_betText.text = GameGlobalRef.gameManager.currentBet.toString();
			_wordMeter.reset();
			updatePowerPlayInfo();
		}
		
		public function get isAutoPlay():Boolean
		{
			return _autoPlayTimes > 0;
		}
		
		public function enableControlBtn():void
		{
			enable = false;
			_playBtn.enabled = true;
		}
		
		public function takeWinEnd():void
		{
			var gamebleModule:GambleModule = GameGlobalRef.gameManager.getModule(GameModuleDefined.GAMBLE) as GambleModule;
			if (!gamebleModule || !gamebleModule.isShow)
			{
				enable = true;
			}
			
			if(GameGlobalRef.gameManager.isMakeliving){
				DisplayUtil.disableInterObjectWithDark(_gambleBtn.interactiveObject);
			}else{
				_gambleMsg.visible = false;
			}
			updateBalanceInfo();
		}
		
		public function set pause(value:Boolean):void
		{
			_isPause = value;
			if (!_isPause && isAutoPlay && _isAutoWaitted)
			{
				_isAutoWaitted = false;
				onPlayClicked();
			}
		}
		
		public function updateBalanceInfo():void
		{
			_creditsTxt.text = GameGlobalRef.gameData.totalDollar.toString();
			trace("updateBalanceInfo _creditsTxt.text",_creditsTxt.text)
			_txtAutoFix.fix();
		}
		
		public function updatePowerPlayInfo():void
		{
			if(_powerTips){
				_powerTips["_txt"].text = GameSetting.dragonPlayNum.toString();
			}
		}
		
		/**
		 * 轮子转动结束 切换按钮状态 
		 * @param statue
		 * 
		 */		
		public function changeButtonStatue(type:String):void
		{
			if (type == ReelEvent.REEL_END)
			{
				updateBalanceInfo();
				checkGamble();
				
				if (isBonusGetted)
				{
					_playBtn.setFrame(1);
					enableControlBtn();
					outorAutoPlay();
					return;
				}
				
				if (!isAutoPlay)
				{
					_playBtn.setFrame(1);
					enable = true;
				}
				else
				{
					//auto play
					_playBtn.setFrame(2);
					enableControlBtn();
					onAutoPlayEnd();
				}
			}
			else
			{
				_playBtn.setFrame(2);
				enable = false;
			}
		}
		
		public function checkGamble():void
		{
			if (GameGlobalRef.gameData.canIntoGamble || GameGlobalRef.gameManager.isInFreeGame)
			{
				if (isAutoPlay)
				{
					_wordMeter.text =  GameGlobalRef.gameData.totalWin.toString();
				}
				else
				{
					if(GameGlobalRef.gameManager.isMakeliving){
						if(GameGlobalRef.gameData.canIntoGamble){
							DisplayUtil.enableButton(_gambleBtn.interactiveObject);
						}else{
							DisplayUtil.disableInterObjectWithDark(_gambleBtn.interactiveObject);
						}
					}else{
						_gambleMsg.visible = GameGlobalRef.gameData.canIntoGamble;
					}
					_wordMeter.meterNumber =  GameGlobalRef.gameData.totalWin;
				}
			}
			else
			{
				_wordMeter.text =  GameGlobalRef.gameData.totalWin.toString();
			}
		}
		
		protected function onAutoPlayEnd():void
		{
			if (--_autoPlayTimes <= 0)
			{
				outorAutoPlay();
				enable = true;
			}
			else
			{
				GameGlobalRef.gameManager.gameTick.addTimeout(onPlayClicked, GameGlobalRef.gameData.isWin ? GameSetting.AUTO_PLAY_WIN_DELAY : GameSetting.AUTO_PLAY_LOST_DELAY, GameTickConstant.AUTO_PLAY_DELAY);
			}
		}
		
		public function set enable(value:Boolean):void
		{
			_enable = value;
			_playBtn.enabled = _enable;
			_autoPlayBtn.enabled = _enable;
			_helpBtn.enabled = _enable;
			_lineNumberCon.enabled = _enable;
			_betLineCashCon.enabled = _enable;
			
			if (_enable)
			{
				DisplayUtil.enableButton(_betMaxBtn.interactiveObject);
				if(_dragonPlayBtn){
					DisplayUtil.enableButton(_dragonPlayBtn.interactiveObject);
				}
				if(_gambleBtn){
					if(GameGlobalRef.gameManager.isMakeliving){
						if(GameGlobalRef.gameData.canIntoGamble){
							DisplayUtil.enableButton(_gambleBtn.interactiveObject);
						}else{
							DisplayUtil.disableInterObjectWithDark(_gambleBtn.interactiveObject);
						}
					}else{
						_gambleMsg.visible = GameGlobalRef.gameData.canIntoGamble;
					}
				}
			}
			else
			{
				DisplayUtil.disableInterObjectWithDark(_betMaxBtn.interactiveObject);
				if(_dragonPlayBtn){
					DisplayUtil.disableInterObjectWithDark(_dragonPlayBtn.interactiveObject);
				}
				if(_gambleBtn){
					if(GameGlobalRef.gameManager.isMakeliving){
						DisplayUtil.disableInterObjectWithDark(_gambleBtn.interactiveObject);
					}else{
						_gambleMsg.visible = false;
					}
				}
			}
		}
		
		override public function show(par:DisplayObjectContainer, x:Number=0, y:Number=0):void
		{
			super.show(par, x, y);
			
			if (isBonusGetted)
			{
				enableControlBtn();
			}
			else
			{
				enable = true;
			}
			
			_playBtn.setFrame(1);
			
			if (GameGlobalRef.gameData.canIntoGamble)
			{
				if(GameGlobalRef.gameManager.isMakeliving){
					DisplayUtil.enableButton(_gambleBtn.interactiveObject);
				}else{
					_gambleMsg.visible = true;
				}
				_wordMeter.text = (GameGlobalRef.gameData.totalWin + GameGlobalRef.freeGameInfo.totalWon).toString();
			}
			else
			{
				if(GameGlobalRef.gameManager.isMakeliving){
					DisplayUtil.disableInterObjectWithDark(_gambleBtn.interactiveObject);
				}else{
					_gambleMsg.visible = false;
				}
				if (GameGlobalRef.gameData.isWin && GameGlobalRef.gameData.currentStatue != GameStatue.GAMBLE_PENDING)
				{
					_wordMeter.text = GameGlobalRef.gameData.totalWin.toString();
				}
				else
				{
					if (GameGlobalRef.gameData.currentStatue == GameStatue.GAMBLE)
					{
						_wordMeter.text = GameGlobalRef.gameData.lastWin.toString();
					}
					else
					{
						_wordMeter.text = "0";
					}
				}
			}
			dispatchToContext(new SlotEvent(SlotEvent.GAME_AUTO_MODE_CHANGED, false, GameStatue.GAMEIDLE));
		}
		
		
		
		override protected function addEvent():void
		{
			if(_dragonPlayBtn){
				_dragonPlayBtn.addEventListener(MouseEvent.ROLL_OVER, onDragBtnHandler);
				_dragonPlayBtn.addEventListener(MouseEvent.ROLL_OUT, onDragBtnHandler);
				_dragonPlayBtn.addEventListener(MouseEvent.CLICK, onDragonClick);
			}
			_playBtn.addEventListener(ComponentEvent.FRAME_CHANGED, onPlayClicked);
			_helpBtn.addEventListener(ComponentEvent.FRAME_CHANGED, onHelp);
			
			_betLineCashCon.addEventListener(Event.CHANGE, onChange);
			_lineNumberCon.addEventListener(Event.CHANGE, onChange);
			
			_autoPlayBtn.addEventListener(SlotUIEvent.AUTO_PLAY_CHANGED, onAutoPlay);
			_autoPlayBtn.addEventListener(SlotUIEvent.AUTO_IN_CHOOSE, onAutoChoose);
			
			_gambleBtn.addEventListener(MouseEvent.CLICK, onGambleClick);
			
			_betMaxBtn.addEventListener(MouseEvent.CLICK, onBetMaxClick);
		}
		
		override protected function removeEvent():void
		{
			if(_dragonPlayBtn){
				_dragonPlayBtn.removeEventListener(MouseEvent.ROLL_OVER, onDragBtnHandler);
				_dragonPlayBtn.removeEventListener(MouseEvent.ROLL_OUT, onDragBtnHandler);
				_dragonPlayBtn.removeEventListener(MouseEvent.CLICK, onDragonClick);
			}
			_playBtn.removeEventListener(ComponentEvent.FRAME_CHANGED, onPlayClicked);
			_helpBtn.removeEventListener(ComponentEvent.FRAME_CHANGED, onHelp);
			
			if (_betLineCashCon)
			{
				_betLineCashCon.removeEventListener(Event.CHANGE, onChange);
			}
			if (_lineNumberCon)
			{
				_lineNumberCon.removeEventListener(Event.CHANGE, onChange);
			}
			
			_autoPlayBtn.removeEventListener(SlotUIEvent.AUTO_PLAY_CHANGED, onAutoPlay);
			_autoPlayBtn.removeEventListener(SlotUIEvent.AUTO_IN_CHOOSE, onAutoChoose);
			_gambleBtn.removeEventListener(MouseEvent.CLICK, onGambleClick);
			_betMaxBtn.removeEventListener(MouseEvent.CLICK, onBetMaxClick);
		}
		
		protected function onBetMaxClick(e:MouseEvent):void
		{
			GameGlobalRef.gameData.currentStatue = "";
			GameGlobalRef.gameManager.setBetInfoToMax();
			updateBetInfo();
			_playBtn.setFrame(2);
			onPlayClicked();
		}
		
		protected function onHelp(e:ComponentEvent):void
		{
			if (_helpBtn.currentFrame == 2)
			{
				enable = false;
				_helpBtn.enabled = true;
				if(GameGlobalRef.gameManager.isMakeliving){
					DisplayUtil.disableInterObjectWithDark(_gambleBtn.interactiveObject);
				}else{
					_gambleMsg.visible = false;
				}
			}
			else
			{
				enable = true;
				if (GameGlobalRef.gameData.isWin)
				{
					if(GameGlobalRef.gameManager.isMakeliving){
						DisplayUtil.enableButton(_gambleBtn.interactiveObject);
					}else{
						_gambleMsg.visible = true;
					}
				}
			}
			dispatchToContext(new SlotUIEvent(SlotUIEvent.SHOW_HELP, _helpBtn.currentFrame == 2 ? true : false));
		}
		
		protected function onGambleClick(e:MouseEvent):void
		{
			if(GameGlobalRef.gameManager.isMakeliving)
			{
				DisplayUtil.disableInterObjectWithDark(_gambleBtn.interactiveObject);
			
			}
			else
			{
				_gambleMsg.visible = false;
			}
			
			dispatchToContext(new SlotUIEvent(SlotUIEvent.SHOW_GAMBLE, true));
			dispatchToContext(new SlotEvent(SlotEvent.GAMBLE_GAME, null, GambleType.GAMBLE_START));
			_wordMeter.text = (GameGlobalRef.gameData.totalWin + GameGlobalRef.freeGameInfo.totalWon).toString();
			enable = false;
		}
		
		/**
		 * 自动游戏 
		 * @param e
		 * 
		 */		
		public function onAutoPlay(e:SlotUIEvent = null):void
		{
			_autoPlayTimes = uint(e.data);
			_playBtn.setFrame(2);
			dispatchToContext(new SlotEvent(SlotEvent.GAME_AUTO_MODE_CHANGED, true, GameStatue.GAMEIDLE));
			dispatchToContext(new SlotUIEvent(SlotUIEvent.AUTO_IN_CHOOSE, false));
			
			onPlayClicked();
		}
		
		protected function onAutoChoose(e:SlotUIEvent):void
		{
			if (e.data)
			{
				enable = false;
				_autoPlayBtn.enabled = true;
				if(GameGlobalRef.gameManager.isMakeliving){
					DisplayUtil.disableInterObjectWithDark(_gambleBtn.interactiveObject);
				}else{
					_gambleMsg.visible = false;
				}
			}
			else
			{
				enable = true;
				checkGambleShow();
			}
			dispatchToContext(e.clone());
		}
		
		public function checkGambleShow():void
		{
			if (GameGlobalRef.gameData.canIntoGamble)
			{
				if(GameGlobalRef.gameManager.isMakeliving){
					DisplayUtil.enableButton(_gambleBtn.interactiveObject);
				}else{
					_gambleMsg.visible = true;
				}
			}
		}
		
		protected function onChange(e:Event):void
		{
			if (e.currentTarget == _betLineCashCon.viewComponent)
			{
				GameGlobalRef.gameManager.currentEachLineCash = _betLineCashCon.currentValue * GameSetting.betTimes;
			}
			else
			{
				GameGlobalRef.gameManager.currentBetLine = _lineNumberCon.currentValue;
			}
		}
		
		private function get isBonusGetted():Boolean
		{
			return GameGlobalRef.gameData.currentStatue == GameStatue.FREE_GAME_INTRO || GameGlobalRef.gameData.currentStatue == GameStatue.PROGRESSIVE;
		}
		
		protected function onPlayClicked(e:ComponentEvent = null):void
		{
			if (isAutoPlay && _isPause)
			{
				_isAutoWaitted = true;
				return;
			}
			
			enable = false;
			if (!e || e.data == 2)
			{
				if (_betLineCashCon.currentValue > GameGlobalRef.gameManager.betCashEachLineMax) 
				{
					SlotServerManager.isInTakeWinRequest = true;
					GameGlobalRef.gameManager.currentEachLineCash = GameGlobalRef.gameManager.betCashEachLineMax;
					GameGlobalRef.gameManager.setBetInfoToMax();
					updateBetInfo();
				}
				
				if (isBonusGetted)
				{
					_wordMeter.directToTarget();
					outorAutoPlay();
					
					if (GameGlobalRef.gameData.currentStatue == GameStatue.FREE_GAME_INTRO)
					{
						dispatchToContext(new SlotEvent(SlotEvent.GAME_CHECK_STATUE));
					}
					return;
				}
				
				if (GameGlobalRef.gameData.afterPlayDollar < 0)
				{
					outorAutoPlay();
					enable = true;
					dispatchToContext(new BussinessEvent(BussinessEvent.NOT_ENOUGH_MONEY, null, CoinType.GAMECOIN));
					return;
				}
				
				updateAfterPlayDollar();
				
				if (isAutoPlay)
				{
					_autoPlayBtn.updateTimes(_autoPlayTimes);
				}
				
				//play
				dispatchToContext(new SlotEvent(SlotEvent.GAME_PLAY, null, GamePlayType.BASE_GAME_PLAY));
			}
			else
			{
				//stop
				if (isAutoPlay)
				{
					outorAutoPlay();
				}
				
				if (!GameGlobalRef.gameManager.isReelRolling)
				{
					enable = true;
					checkGamble();
				}
				dispatchToContext(new SlotEvent(SlotEvent.GAME_STOP));
			}
		}
		
		protected function updateAfterPlayDollar():void
		{
			_creditsTxt.text = (GameGlobalRef.gameData.afterPlayDollar + GameGlobalRef.freeGameInfo.totalWon).toString();
			trace("updateAfterPlayDollar _creditsTxt.text",_creditsTxt.text)
			_txtAutoFix.fix();
		}
		
		protected function outorAutoPlay():void
		{
			GameGlobalRef.gameManager.gameTick.removeTimeout(GameTickConstant.AUTO_PLAY_DELAY);
			
			
			_playBtn.setFrame(1);
			_isAutoWaitted = false;
			
			if (isAutoPlay)
			{
				dispatchToContext(new SlotEvent(SlotEvent.GAME_AUTO_MODE_CHANGED, false, GameStatue.GAMEIDLE));
			}
			else if(_autoPlayTimes == 0)
			{
				GameGlobalRef.gameManager.gameTick.addTimeout(
					function():void
					{
						dispatchToContext(new SlotEvent(SlotEvent.GAME_AUTO_MODE_CHANGED, false, GameStatue.GAMEIDLE));
					}, GameGlobalRef.gameData.isWin ? GameSetting.AUTO_PLAY_WIN_DELAY : GameSetting.AUTO_PLAY_LOST_DELAY);
				
			}
			_autoPlayBtn.reset();
			_autoPlayTimes = 0;
		}
		
		private function onDragonClick(e:MouseEvent):void
		{
			enable = false;
			outorAutoPlay();
			_powerTips.visible = false;
			if (isBonusGetted)
			{
				dispatchToContext(new SlotEvent(SlotEvent.GAME_CHECK_STATUE));
				return;
			}
			
			if (GameGlobalRef.gameData.dragon < GameSetting.dragonPlayNum)
			{
				enable = true;
				ModuleManager.dispatchToGame(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_NOT_ENOUGH_MOENY, CoinType.DRAGON, "0", { path:TrackPath.ANY_SLOTS + TrackPath.BET_WITH_DOLLARS }));
//				dispatchToContext(new BussinessEvent(BussinessEvent.NOT_ENOUGH_MONEY, null, CoinType.DRAGON));
				return;
			}
			
			var winNum:Number = GameGlobalRef.gameData.totalCent + NumberUtil.dollarToCent(GameGlobalRef.gameData.totalWin) + NumberUtil.dollarToCent(GameGlobalRef.freeGameInfo.totalWon);
				
			_creditsTxt.text = Math.floor(NumberUtil.centToDollar(winNum)).toString();
			trace("onDragonClick _creditsTxt.text",_creditsTxt.text)
			_txtAutoFix.fix();
			
			GameGlobalRef.gameData.currentStatue = "";
			GameGlobalRef.gameManager.currentBetLine = GameGlobalRef.gameManager.betLineMax;
			dispatchToContext(new SlotEvent(SlotEvent.GAME_PLAY, winNum, GamePlayType.POWER_PLAY));
		}
		
		public function afterPlayClick():void
		{
			enable = false;
			if(GameGlobalRef.gameManager.isMakeliving){
				DisplayUtil.disableInterObjectWithDark(_gambleBtn.interactiveObject);
			}else{
				_gambleMsg.visible = false;
			}
			if(!isAutoPlay){
				outorAutoPlay();
			}
			_wordMeter.reset();
			_playBtn.setFrame(2);
		}
		
		public function updateBetData():void
		{
			_betLineCashCon.maxNum = GameGlobalRef.gameManager.betCashEachLineMax;
		}
		
		public function updateTotalWin():void
		{
			trace(GameGlobalRef.gameData.totalWin, GameGlobalRef.gambleInfo.totalGambleWin, GameGlobalRef.freeGameInfo.totalWon);
			_wordMeter.text = (GameGlobalRef.gameData.totalWin + GameGlobalRef.gambleInfo.totalGambleWin + GameGlobalRef.freeGameInfo.totalWon).toString();
		}
		
		private function onDragBtnHandler(e:MouseEvent):void
		{
			_powerTips.visible = e.type == MouseEvent.ROLL_OVER;
		}
		
		public function stopMeter():void
		{
			_wordMeter.directToTarget();
		}
		
		override public function dispose():void
		{
			super.dispose();
			_helpBtn.dispose();
			_playBtn.dispose();
			_autoPlayBtn.dispose();
			_wordMeter.dispose();
			_wordMeter = null;
			_helpBtn = _playBtn = null;
			_autoPlayBtn = null;
			_betMaxBtn.dispose();
			_dragonPlayBtn.dispose();
			_betMaxBtn = _dragonPlayBtn = null;
			
			if (_betLineCashCon)
			{
				_betLineCashCon.dispose();
				_betLineCashCon = null;
			}
			if (_lineNumberCon)
			{
				_lineNumberCon.dispose();
				_lineNumberCon = null;
			}
		}
	}
}