package com.aspectgaming.game.animation
{
	
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GameModuleDefined;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.constant.SlotGameType;
	import com.aspectgaming.game.constant.asset.AnimationDefined;
	import com.aspectgaming.game.core.IGameAnimation;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.event.GameAnimaEvent;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.module.uicontrol.UiControlBar;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * 游戏全局动画控制器 
	 * @author mason.li
	 * 
	 */	
	public class GameAnimationiControl extends Command
	{
		[Inject]
		public var slotEvent:SlotEvent;
		
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var gameData:GameData;
		
		override public function execute():void
		{
			var gameAni:IGameAnimation = GameAnimationLibrary.getAnimation(slotEvent.content, slotEvent.m_boolValue);
			
			gameMgr.isInFreeGameAnimation = slotEvent.content == AnimationDefined.FREE_INTRO || slotEvent.content == AnimationDefined.FREE_OUTRO || slotEvent.content == AnimationDefined.PROGRESSIVE;
			
			if (gameAni && !gameAni.isPlaying)
			{
				gameAni.addEventListener(GameAnimaEvent.ANIMATION_HALF, onAnimationPastHalf);
				gameAni.addEventListener(GameAnimaEvent.ANIMATION_COMPLETE, onAnimationComplete);
				gameAni.data = slotEvent.data;
				gameAni.content = slotEvent.content;
				
				gameAni.show(GameLayerManager.topLayer);
				gameAni.start();
				GameAnimationLibrary.addAniRef(slotEvent.content, gameAni);
			}
		}
		
		/**
		 * 动画播放至一半的处理 
		 * @param e
		 * 
		 */		
		protected function onAnimationPastHalf(e:GameAnimaEvent):void
		{
			switch (slotEvent.content)
			{
				case AnimationDefined.FREE_INTRO:
					gameMgr.gameMode = GameStatue.FREEGAME;
					break;
				case AnimationDefined.FREE_OUTRO:
					if (NewPlayerGuidManager.isInGuild)
					{
						gameData.currentStatue = GameStatue.GAMBLE_OR_TAKEWIN;
					}
					
					gameMgr.gameMode = GameStatue.GAMEIDLE;
					dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.GAMBLE_OR_PLAY)));
					gameMgr.isAfterFreeOutro = true;
					
					if (NewPlayerGuidManager.isInGuild)
					{
						ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_UPDATE_BALANCE, "", "", {cash:gameData.totalCent }));
						(gameMgr.getModule(GameModuleDefined.GAME_UI) as UiControlBar).currentControl.updateBalanceInfo();
					}
					
					break;
			}
			
		}
		
		protected function onAnimationComplete(e:GameAnimaEvent):void
		{
			var tar:IGameAnimation = e.currentTarget as IGameAnimation;
			tar.removeEventListener(GameAnimaEvent.ANIMATION_HALF, onAnimationPastHalf);
			tar.removeEventListener(GameAnimaEvent.ANIMATION_COMPLETE, onAnimationComplete);
			dispatch(e.clone());
//			GameAnimationLibrary.removeAniRef(slotEvent.content);
			if (slotEvent.content == AnimationDefined.FREE_INTRO || slotEvent.content == AnimationDefined.FREE_OUTRO  || slotEvent.content == AnimationDefined.PROGRESSIVE )
			{
				gameMgr.isInFreeGameAnimation = false;
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_STATUE_CHANGE, "", "", gameData.isGaming));
			}
		}
		
	}
}