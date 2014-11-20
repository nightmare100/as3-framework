package com.aspectgaming.game.module.uicontrol
{
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.component.event.ReelEvent;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GameModuleDefined;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.constant.SlotGameType;
	import com.aspectgaming.game.constant.asset.AnimationDefined;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.data.FreeGameModel;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.GambleEvent;
	import com.aspectgaming.game.event.GameAnimaEvent;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.SlotServerManager;
	import com.aspectgaming.game.utils.SlotInfoUtil;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.net.event.ServerEvent;
	import com.aspectgaming.utils.NumberUtil;
	
	import flash.events.Event;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	public class UiControlBarMeditor extends ModuleMediator
	{
		[Inject]
		public var controlBar:UiControlBar;
		
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var gameData:GameData;
		
		[Inject]
		public var server:IServer;
		
		public function UiControlBarMeditor()
		{
			super();
		}
		
		override public function onRegister():void
		{
			/**玩游戏回调 */
			addModuleListener(SlotEvent.GAME_PLAY_REQUEST_BACK, onServerBack);
			addModuleListener(SlotAmfCommand.CMD_GAME_END, onTakeWin);
			addModuleListener(SlotAmfCommand.CMD_GAME_PROGRESSIVE_END, onProgressiveEnd);
			/**轮子停下*/
			addContextListener(ReelEvent.REEL_END, onReelEnd, ReelEvent);
			/**下注线变更*/
			addContextListener(SlotUIEvent.BET_LINE_CHANGED, onBetLineChanged);
			/**下注每根线钱的变更*/
			addContextListener(SlotUIEvent.BET_CASH_CHANGED, onBetLineChanged);
			
			addContextListener(SlotUIEvent.BET_CASH_MAX_CHANGED, onBetMaxValueChanged);
			/**游戏模式改变*/
			addContextListener(SlotEvent.GAME_MODE_CHANGED, onGameModeChanged);
			
			addContextListener(SlotEvent.GAME_UPDATE_BALANCE, onUpdateBalance);
			
			addContextListener(SlotUIEvent.SHOW_GAMBLE, onGambleShow);
			
			addContextListener(GambleEvent.GAMBLE_WIN_METER, onGambleWin);
			/** 显示全局动画*/
			addContextListener(SlotEvent.SHOW_GLOBAL_ANIMATION, onAnimationPlay);
			
			addContextListener(GameEvent.GAME_CREATED_COMPLETE, onGameCreateComplete);
			/** 关闭窗口*/
			addContextListener(GameEvent.GAME_POPUP_END, onLobbyCommand);
			/**弹遮罩面板*/
			addContextListener(GameEvent.GAME_WIN_POPUP, onLobbyCommand);
			/**play 游戏*/			
			addContextListener(SlotEvent.GAME_PLAY, onGamePlay);
			
			super.onRegister();
		}
		
		/**
		 * 暂停 / 继续游戏 
		 * @param e
		 * 
		 */		
		private function onLobbyCommand(e:GameEvent):void
		{
			var isPause:Boolean = e.type == GameEvent.GAME_WIN_POPUP;
			controlBar.currentControl.pause = isPause;
		}
		
		private function onGameCreateComplete(e:GameEvent):void
		{
			removeContextListener(GameEvent.GAME_CREATED_COMPLETE, onGameCreateComplete);
			checkWinshowListener(true);
		}
		private function onGambleShow(e:SlotUIEvent):void
		
		{
			controlBar.currentControl.enable = !Boolean(e.data);
		}
		
		protected function onBetLineChanged(e:SlotUIEvent):void
		{
			if (gameData.canIntoGamble && !SlotServerManager.isInTakeWinRequest)
			{
				
				if (NewPlayerGuidManager.isInGuild)
				{
					gameData.totalCent += NumberUtil.dollarToCent(gameData.totalWin);
					gameData.totalDollar += gameData.totalWin;
					gameData.totalWin = 0;
					gameData.currentStatue = GameStatue.GAMEIDLE;
					ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_UPDATE_BALANCE, "", "", SlotInfoUtil.getUpdateBalanceInfo(gameData.totalCent, NumberUtil.dollarToCent(gameData.dragon))));
					controlBar.currentControl.takeWinEnd();
					
					
				}
				else
				{
					controlBar.enable = false;
					server.sendRequest(SlotAmfCommand.CMD_GAME_END);
				}
				
				dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.PLAY_AGAIN)));
			}

			controlBar.currentControl.updateBetInfo();
			SoundManager.playSound(SlotSoundDefined.BUTTON_CLICK);
		}
		
		private function onBetMaxValueChanged(e:SlotUIEvent):void
		{
			controlBar.currentControl.updateBetData();
		}
		
		/**
		 * 轮子停下 
		 * @param e
		 * 
		 */		
		public function onReelEnd(e:ReelEvent):void
		{
			controlBar.currentControl.changeButtonStatue(e.type);
			controlBar.reflushBall();
			if (!(gameMgr.isBaseGame || gameMgr.isPropGame))
			{
				controlBar.currentControl.updateBetInfo(false);
				controlBar.updateAfterStop();
			}
			
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_UPDATE_BALANCE, "", "", {cash:gameData.totalCent }));
			if (gameData.currentStatue == GameStatue.FREE_GAME_OUTRO)
			{
				removeContextListener(SlotUIEvent.WIN_SHOW_END, onWinShowEnd);
			}
		}
		
		/**玩游戏回调 */
		private function onServerBack(e:Event):void
		{
			controlBar.currentControl.enableControlBtn();
			if (!(gameMgr.isBaseGame || gameMgr.isPropGame))
			{
				controlBar.currentControl.updateBetInfo();
				controlBar.updateWildAni();
			}
		}
		
		private function onTakeWin(e:ServerEvent):void
		{
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_UPDATE_BALANCE, "", "", SlotInfoUtil.getUpdateBalanceInfo(gameData.totalCent, NumberUtil.dollarToCent(gameData.dragon))));
			controlBar.currentControl.takeWinEnd();
		}
		
		private function onProgressiveEnd(e:ServerEvent):void
		{
			controlBar.currentControl.enable = true;
			GameGlobalRef.gameManager.dispatchToContext(new ReelEvent(ReelEvent.REEL_END));
		}
		
		private function onGameModeChanged(e:SlotEvent):void
		{
			checkWinshowListener();
			controlBar.changeGameMode(gameMgr.gameMode);
		}
		
		protected function onAnimationPlay(e:SlotEvent):void
		{
			if (e.content == AnimationDefined.FREE_OUTRO)
			{
				controlBar.currentControl.updateTotalWin();
				controlBar.currentControl.updateBetData();
			}
			
			if (gameData.currentStatue == GameStatue.FREE_GAME_INTRO || gameData.currentStatue == GameStatue.FREE_GAME_OUTRO)
			{
				controlBar.currentControl.winMeter.directToTarget();
			}
		}
		
		private function checkWinshowListener(isInit:Boolean = false):void
		{
			if (gameMgr.gameMode == SlotGameType.FREE_GAME)
			{
				addContextListener(GameAnimaEvent.ANIMATION_COMPLETE, onWinShowEnd);
				addContextListener(SlotUIEvent.WIN_SHOW_END, onWinShowEnd);
				if (isInit)
				{
					controlBar.currentControl.onAutoPlay();
				}
			}
			else
			{
				removeContextListener(SlotUIEvent.WIN_SHOW_END, onWinShowEnd);
				removeContextListener(GameAnimaEvent.ANIMATION_COMPLETE, onWinShowEnd);
			}
		}
		
		private function onGambleWin(e:GambleEvent):void
		{
			controlBar.currentControl.updateTotalWin();
		}
		
		/**
		 *  Free game Winshow End事件
		 */
		private function onWinShowEnd(e:Event):void
		{
			if (e.type == GameAnimaEvent.ANIMATION_COMPLETE)
			{
				removeContextListener(GameAnimaEvent.ANIMATION_COMPLETE, onWinShowEnd);
			}
			controlBar.currentControl.onAutoPlay();
		}
		
		private function onUpdateBalance(e:Event):void
		{
			controlBar.currentControl.updateBalanceInfo();
		}

		private function onGamePlay(e:SlotEvent):void
		{
			controlBar.currentControl.afterPlayClick();
		}
	}
}