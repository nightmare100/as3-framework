package com.aspectgaming.game.base.control.init
{
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.event.GlobalEvent;
	import com.aspectgaming.game.animation.GameAnimationLibrary;
	import com.aspectgaming.game.animation.GameAnimationiControl;
	import com.aspectgaming.game.animation.ProgressiveAnimation;
	import com.aspectgaming.game.animation.RetriggerAnimation;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GameModuleDefined;
	import com.aspectgaming.game.constant.GamePlayType;
	import com.aspectgaming.game.constant.asset.AnimationDefined;
	import com.aspectgaming.game.control.AutoPlayModeChangeCommand;
	import com.aspectgaming.game.control.CheckGameStatueCommand;
	import com.aspectgaming.game.control.GambleCommand;
	import com.aspectgaming.game.control.GamePlayCommand;
	import com.aspectgaming.game.control.LevelUpCommand;
	import com.aspectgaming.game.control.NoMoneyProcessCommand;
	import com.aspectgaming.game.control.ShowGambleCommand;
	import com.aspectgaming.game.control.ShowHelpCommand;
	import com.aspectgaming.game.control.ShowSimulatorCommand;
	import com.aspectgaming.game.control.UpdateBalanceCommand;
	import com.aspectgaming.game.controller.InitGameLobbyConnectionCommand;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.BussinessEvent;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.module.gamble.GambleModule;
	import com.aspectgaming.game.module.gamble.GambleModuleMeditor;
	import com.aspectgaming.game.module.game.ReelModule;
	import com.aspectgaming.game.module.game.ReelModuleMeditor;
	import com.aspectgaming.game.module.game.winshow.WinShowView;
	import com.aspectgaming.game.module.help.HelpModule;
	import com.aspectgaming.game.module.message.MessageModule;
	import com.aspectgaming.game.module.message.MessageModuleMeditor;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * 创建游戏 
	 * @author mason.li
	 * 
	 */	
	public class CreateGameCommand extends Command
	{
		[Inject]
		public var gameManager:GameManager;
		
		public function CreateGameCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			commandMap.mapEvent(GameEvent.REGISTER_LOBBY_COMMAND, InitGameLobbyConnectionCommand, GameEvent, true);
			commandMap.mapEvent(SlotUIEvent.SHOW_HELP, ShowHelpCommand, SlotUIEvent);
			commandMap.mapEvent(SlotUIEvent.SHOW_GAMBLE, ShowGambleCommand, SlotUIEvent);
			commandMap.mapEvent(SlotEvent.GAME_PLAY, GamePlayCommand, SlotEvent);
			commandMap.mapEvent(SlotEvent.GAMBLE_GAME, GambleCommand, SlotEvent);
			commandMap.mapEvent(BussinessEvent.NOT_ENOUGH_MONEY, NoMoneyProcessCommand, BussinessEvent);
			
			commandMap.mapEvent(GameEvent.GAME_LEVEL_UP, LevelUpCommand, GameEvent);
			
			gameManager.registerModuleClass(GameModuleDefined.GAME_HELP, HelpModule);
			
			//大厅UpdateBalance
			commandMap.mapEvent(GameEvent.GAME_UPDATE_BALANCE, UpdateBalanceCommand, GameEvent);
			
			commandMap.mapEvent(SlotEvent.GAME_CHECK_STATUE, CheckGameStatueCommand, SlotEvent);
			
			
			commandMap.mapEvent(SlotEvent.GAME_AUTO_MODE_CHANGED, AutoPlayModeChangeCommand);
						
			GameAnimationLibrary.registerAniClass(AnimationDefined.PROGRESSIVE, ProgressiveAnimation);
			if (GameSetting.hasRetrigger)
			{
				GameAnimationLibrary.registerAniClass(AnimationDefined.RETRIGGER, RetriggerAnimation);
			}
			
			//自定义UI创建
			dispatch(new GameEvent(GameEvent.GAME_BEFORE_CREATE_UI));
			
			
			
			
			mediatorMap.mapView(MessageModule, MessageModuleMeditor);
			mediatorMap.mapView(GambleModule, GambleModuleMeditor);
			
			gameManager.addModule(new MessageModule(), GameModuleDefined.GAME_MESSAGE, GameLayerManager.uilayer, GameSetting.messageBarInfo.x, GameSetting.messageBarInfo.y);
			
			dispatch(new GameEvent(GameEvent.REGISTER_LOBBY_COMMAND));
			dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.WELCOME)));
			dispatch(new SlotEvent(SlotEvent.GAME_CHECK_STATUE, null, "true"));
			
			//创建完毕
			dispatch(new GameEvent(GameEvent.GAME_CREATED_COMPLETE));
			
			if(ClientManager.isLocalDebug)
			{
				commandMap.mapEvent(SlotUIEvent.SHOW_SIMULATOR, ShowSimulatorCommand, SlotUIEvent, true);
				dispatch(new SlotUIEvent(SlotUIEvent.SHOW_SIMULATOR, addSimulatorListener))
			}
			
			addSimulatorListener();
		}
		
		private function addSimulatorListener():void
		{
			if (GameGlobalRef.simulator)
			{
				(GameGlobalRef.simulator as IEventDispatcher).addEventListener(GlobalEvent.EMNULATOR_PLAY, onEmnulatorPlay);
			}
		}
		
		private function onEmnulatorPlay(event:GlobalEvent):void
		{
			var obj:Object = {};
			obj.emulation = true;
			obj.stops = String(event.obj.r);
			obj.storedParams = {
				SixthReelSymbol:String(event.obj.r6)
			}
			if (GameGlobalRef.gameManager.isBaseGame || GameGlobalRef.gameManager.isPropGame)
			{
				dispatch(new SlotEvent(SlotEvent.GAME_PLAY, obj, GamePlayType.BASE_GAME_PLAY));
			}
			else
			{
				dispatch(new SlotEvent(SlotEvent.GAME_PLAY, obj, GameGlobalRef.gameInfo.isFreeSpin ? GamePlayType.FREE_SPIN_PLAY : GamePlayType.FREE_GAME_PLAY));
			}
		}
		
	}
}