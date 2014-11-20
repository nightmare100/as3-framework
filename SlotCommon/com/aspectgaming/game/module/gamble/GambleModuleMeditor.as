package com.aspectgaming.game.module.gamble
{
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GambleType;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.gamble.GambleInfo;
	import com.aspectgaming.game.event.GambleEvent;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.net.event.ServerEvent;
	
	import flash.events.Event;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
	
	public class GambleModuleMeditor extends ModuleMediator
	{
		[Inject]
		public var gambleModule:GambleModule;
		
		[Inject]
		public var gameMgr:GameManager;
		
		public function GambleModuleMeditor()
		{
			super();
		}
		
		override public function onRegister():void
		{
			addModuleListener(SlotEvent.GAMBLE_GAME_REQUEST_BACK, onGameEvent, SlotEvent);
			
			super.onRegister();
		}
		
		private function onGameEvent(evt:SlotEvent):void 
		{
			trace("GambleModuleMeditor onGameEvent",evt.content)
			var isWin:Boolean;
			var cardV:int;
			var allWon:Number = GameGlobalRef.gambleInfo.gambleWager;
			
			switch(evt.content) 
			{
				case SlotAmfCommand.CMD_GAMBLE_GAME:
					if (allWon == 0 ) 
					{
						allWon = GameGlobalRef.gameData.totalWin + GameGlobalRef.freeGameInfo.totalWon;
					}
					gambleModule.start(allWon, GameGlobalRef.gambleInfo.totalGambleWin);
					
					if (GameGlobalRef.gambleInfo.currentIndex < 1)
					{
						dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.RISK)))
					}
					else
					{					
						dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.CONTINUE_GAMBLE_OR_TAKEWIN)));
					}
					
					dispatch(new GambleEvent(GambleEvent.GAMBLE_WIN_METER,allWon))
					break;
				case SlotAmfCommand.CMD_GAMBLE_GAMESELETE:
					
					// lost : exit-out / win : takewin
					
					isWin = GameGlobalRef.gambleInfo.isWon;
					cardV = GameGlobalRef.gambleInfo.currentDrawCardVal;
					
					if(isWin)
					{
						//Gamble WIN
//						gambleModule.setBtnTakewin(false);
//						gambleModule.setBtns(true)
						gambleModule.update(isWin, cardV, GameGlobalRef.gambleInfo.totalGambleWin);
						
						dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.GAMBLE_WIN)));
						if (GameGlobalRef.gameData.currentStatue == GameStatue.GAMBLE_PENDING) 
						{
							gambleModule.gamebleEnd();
						}
						else
						{
							
							gameMgr.gameTick.addTimeout(function():void{
								dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.CONTINUE_GAMBLE_OR_TAKEWIN)));
							}, 2);
						}
					}
					else
					{
						//Gamble Lost
						
						dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.GAMBLE_LOST)))
						
						//if (allWon < 0) allWon = 0;
						allWon = GameGlobalRef.gameData.totalWin  +  GameGlobalRef.gambleInfo.totalGambleWin + GameGlobalRef.freeGameInfo.totalWon;
						//_gamble.update(isWin, cardV, gRes._gambleWonT);  // 要退出Gamble page后再更新meter
						gambleModule.update(isWin, cardV,GameGlobalRef.gambleInfo.gambleWager);  // 要退出Gamble page后再更新meter
						gambleModule.gamebleEnd();
					}
					
					dispatch(new GambleEvent(GambleEvent.GAMBLE_WIN_METER, allWon))
					break;
				
				case SlotAmfCommand.CMD_GAME_END:
					
					gambleModule.exit(0);
					break;
			}
			
		}
	}
}