package com.aspectgaming.game.module.game
{
	
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.component.event.ReelEvent;
	import com.aspectgaming.game.component.reels.IReel;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.constant.SlotGameType;
	import com.aspectgaming.game.constant.asset.AnimationDefined;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.data.FreeGameModel;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.GambleEvent;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.utils.SlotInfoUtil;
	import com.aspectgaming.game.utils.SlotUtil;
	import com.aspectgaming.game.utils.WinShowUtil;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.tick.Tick;
	
	import flash.events.Event;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	public class ReelModuleMeditor extends ModuleMediator
	{
		[Inject]
		public var reelModule:ReelModule;
		
		[Inject]
		public var gameData:GameData;
		
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var server:IServer;
		
		[Inject]
		public var freeGameInfo:FreeGameModel;
		
		public function ReelModuleMeditor()
		{
			super();
		}
		
		override public function onRegister():void
		{
			/**play 游戏*/
			addContextListener(SlotEvent.GAME_PLAY, onGameReelStatueChanged, SlotEvent);
			/**stop 游戏 */
			addContextListener(SlotEvent.GAME_STOP, onGameReelStatueChanged, SlotEvent);
			/**轮子停下*/
			addContextListener(ReelEvent.REEL_END, onReelStop, ReelEvent);
			/**下注线变更*/
			addContextListener(SlotUIEvent.BET_LINE_CHANGED, onBetLineChanged, SlotUIEvent);
			/**下注每根线钱的变更*/
			addContextListener(SlotUIEvent.BET_CASH_CHANGED, onBetLineChanged, SlotUIEvent);
			
			addContextListener(SlotUIEvent.SHOW_HELP, onHelpPageShow, SlotUIEvent);
			addContextListener(SlotUIEvent.SHOW_GAMBLE, onGambleShow, SlotUIEvent);
			addModuleListener(SlotAmfCommand.CMD_GAME_END, onGambleShow);
			/** 显示全局动画*/
			addContextListener(SlotEvent.SHOW_GLOBAL_ANIMATION, onAnimationPlay);
			/**玩游戏请求回调*/
			addModuleListener(SlotEvent.GAME_PLAY_REQUEST_BACK, onServerPlayBack, SlotEvent);
			/**自动游戏模式切换*/
			addModuleListener(SlotEvent.GAME_AUTO_MODE_CHANGED, onAutoPlayStop);
			/**游戏模式切换*/
			addContextListener(SlotEvent.GAME_MODE_CHANGED, onGameModeChanged);
			/**gamble lost or gamble pending*/
			addContextListener(GambleEvent.GAMBLE_END, onGambleEnd);
			
			addContextListener(SlotUIEvent.AUTO_IN_CHOOSE, onAutoShow);
			
			checkStatue(false);
			super.onRegister();
		}
		
		/**
		 * AUTO PLAY 停止 检查WINSHOW 
		 * @param e
		 * 
		 */		
		protected function onAutoPlayStop(e:SlotEvent):void
		{
			//AUTOPLAY 中断
			if (needShowWinLine && !WinShowUtil.isInWinShow && !reelModule.reelBox.isStart && !gameMgr.isInFreeGame && !gameMgr.isAfterFreeOutro && !gameMgr.isInFreeGameAnimation)
			{
				reelModule.payLine.hideAllLine();
				reelModule.showWinLine(gameData.winLines, gameData.scatterInfo, gameData.totalWin, false);
			}
		}
		
		protected function onAutoShow(e:SlotUIEvent):void
		{
			reelModule.payLine.enabled = !Boolean(e.data);
		}
		
		protected function onGameModeChanged(e:SlotEvent):void
		{
			if (gameMgr.isBaseGame||gameMgr.isPropGame)
			{
				reelModule.clearWinShow();
				reelModule.payLine.hideAllLine();
				reelModule.payLine.processReelStop();
				reelModule.reelBox.setSymblo(gameData.baseGameStops);
			}
			else
			{
				reelModule.reelBox.setSymblo(freeGameInfo.freeGameStops);
				reelModule.payLine.addBtnEvent();
			}
		}
		
		protected function onGambleEnd(e:GambleEvent):void
		{
			reelModule.payLine.processReelStop();
		}
		
		/**
		 * FreeIntro outro才会检查状态 
		 * @param isDelay
		 * 
		 */		
		protected function checkStatue(isDelay:Boolean = true):void
		{
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_STATUE_CHANGE, "", "", gameData.isGaming));
			if (gameData.currentStatue == GameStatue.FREE_GAME_INTRO)
			{
				reelModule.showWinLine(gameData.winLines, gameData.scatterInfo, gameData.totalWin);
				reelModule.payLine.stopLineApi();
				reelModule.payLine.addBtnEvent();
				dispatch(new SlotEvent(SlotEvent.GAME_CHECK_STATUE, GameSetting.freeAnimationDelay));
			}
			else if (gameData.currentStatue == GameStatue.FREE_GAME_OUTRO)
			{
				reelModule.clearWinShow();
				var delayTime:uint = isDelay ? GameSetting.freeAnimationDelay : 0;
				dispatch(new SlotEvent(SlotEvent.GAME_CHECK_STATUE, delayTime));
			}
			else if (gameData.currentStatue == GameStatue.GAMBLE_PENDING)
			{
				server.sendRequest(SlotAmfCommand.CMD_GAME_END);
			}
			else if (gameData.currentStatue == GameStatue.PROGRESSIVE)
			{
				dispatch(new SlotEvent(SlotEvent.SHOW_GLOBAL_ANIMATION, gameData.progressiveInfo , AnimationDefined.PROGRESSIVE));
			}
			
			//新用户 填充currentStop
			if (!GameGlobalRef.gameData.currentStops || GameGlobalRef.gameData.currentStops.length < GameSetting.baseSymbloLen)
			{
				var arr:Array = [];
				for (var i:uint = 0; i < GameSetting.reelColume; i++)
				{
					var reel:IReel = gameMgr.getReelInfoByIndex(i);
					for (var j:uint = 0; j < reel.showListIds.length; j++)
					{
						arr[j * GameSetting.reelColume + i] = reel.showListIds[j];
					}
				}
				GameGlobalRef.gameData.currentStops = arr;
			}
		}
		
		protected function onAnimationPlay(e:SlotEvent):void
		{
			if (e.content != AnimationDefined.RETRIGGER)
			{
				removeContextListener(SlotUIEvent.WIN_SHOW_END, onWinShowEnd);
				reelModule.clearWinShow();
				reelModule.payLine.hideAllLine();
			}
		}
		
		protected function onGameReelStatueChanged(e:SlotEvent):void
		{
			removeContextListener(SlotUIEvent.WIN_SHOW_END, onWinShowEnd);
			if (e.type == SlotEvent.GAME_PLAY)
			{
				reelModule.reelBox.start();
				reelModule.payLine.stopLineApi();
				reelModule.clearWinShow();
			}
			else
			{
				if (reelModule.reelBox.isStart)
				{
					SoundManager.playSound(SlotSoundDefined.REEL_STOP);
				}
				else
				{
					//AUTOPLAY 中断
					/*if (needShowWinLine)
					{
						reelModule.showWinLine(gameData.winLines, gameData.scatterInfo, gameData.totalWin);
					}*/
				}
				
				SlotUtil.stopScattarSound();
				reelModule.reelBox.stop();
			}
		}
		
		protected function onServerPlayBack(e:SlotEvent):void
		{
			reelModule.reelBox.setReelInfo(gameData.currentStops);
		}
		
		protected function get needShowWinLine():Boolean
		{
			return (gameMgr.isBaseGame && gameData.isWin) || (!gameMgr.isBaseGame && freeGameInfo.isCurrentWin);
		}
		
		/**
		 * 轮子已停下 
		 * @param e
		 * 
		 */		
		private function onReelStop(e:ReelEvent):void
		{
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_STATUE_CHANGE, "", "", gameData.isGaming));
			
			if (gameData.currentStatue == GameStatue.FREE_GAME_INTRO)
			{
				SoundManager.playSound(SlotSoundDefined.FREE_GAME_BELL);
				Tick.addTimeout(processReelStop, 2);
				return;
			}
			if(gameData.currentStatue == GameStatue.PROGRESSIVE){
				dispatch(new SlotEvent(SlotEvent.GAME_CHECK_STATUE, 0));
				return;
			}
			processReelStop();
		}
		
		protected function processReelStop():void
		{
			if (!reelModule.reelBox)
			{
				return;
			}
			
			reelModule.reelBox.clearStopAni();
			if (needShowWinLine)
			{
				//赢钱 winshow
				var totalWin:Number = gameMgr.isInFreeGame?GameGlobalRef.freeGameInfo.currentWon:gameData.totalWin;
				
				if (!gameMgr.isInFreeGameAnimation)
				{
					addContextListener(SlotUIEvent.WIN_SHOW_END, onWinShowEnd);
					reelModule.showWinLine(gameData.winLines, gameData.scatterInfo, totalWin);
				}
				else
				{
					gameMgr.isInFreeGameAnimation = false;
				}
				
				if (!gameMgr.isInFreeGame)
				{
					reelModule.payLine.addBtnEvent();
					
					//bigWin Checked!!
					ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_BIG_WIN, null, null, SlotInfoUtil.getBigWinInfo(gameData.totalWin, gameMgr.currentEachLineCash)));
				}
				else
				{
					if (freeGameInfo.needAniMovie)
					{
						freeGameInfo.needAniMovie = false;
						dispatch(new SlotEvent(SlotEvent.SHOW_GLOBAL_ANIMATION, gameData.scatterInfo.symbloLength, AnimationDefined.RETRIGGER));
					}
				}
			}
			else
			{
				//lost
				if (!gameMgr.isInFreeGame)
				{
					if (!gameMgr.isAutoPlay)
					{
						reelModule.payLine.processReelStop();
					}
					dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.GAME_LOST)));
				}
				onWinShowEnd();
			}
		}
		
		/**
		 * winshow 播放完一个轮回 
		 * 
		 */		
		protected function onWinShowEnd(e:SlotUIEvent = null):void
		{
			removeContextListener(SlotUIEvent.WIN_SHOW_END, onWinShowEnd);
			checkGameStatue();
		}

		/**
		 * WINSHOW 结束后 检测游戏状态变更 
		 * 
		 */		
		private function checkGameStatue():void
		{
			if (gameData.currentStatue == GameStatue.FREE_GAME_INTRO || gameData.currentStatue == GameStatue.FREE_GAME_OUTRO)
			{
				dispatch(new SlotEvent(SlotEvent.GAME_CHECK_STATUE, GameSetting.freeAnimationDelay));
			}
			else if (gameData.currentStatue == GameStatue.PROGRESSIVE)
			{
				dispatch(new SlotEvent(SlotEvent.GAME_CHECK_STATUE, GameSetting.progressAnimationDelay));
			}
		}
		
		protected function onBetLineChanged(e:SlotUIEvent):void
		{
			if (e.type == SlotUIEvent.BET_LINE_CHANGED)
			{
				reelModule.payLine.updateButton();
			}
			else
			{
				reelModule.payLine.hideAllLine();
				reelModule.payLine.processReelStop();
			}
			reelModule.clearWinShow();
		}
		
		protected function onHelpPageShow(e:SlotUIEvent):void
		{
			if (Boolean(e.data))
			{
				reelModule.hideWinShow();
				reelModule.payLine.stopLineApi();
			}
			else
			{
				reelModule.showWinShow();
				if (gameData.isWin)
				{
					reelModule.payLine.addBtnEvent();
				}
				else
				{
					reelModule.payLine.processReelStop();
				}
			}
		}
		
		protected function onGambleShow(e:Event):void
		{
			reelModule.payLine.hideAllLine();
			reelModule.clearWinShow();
		}
	}
}