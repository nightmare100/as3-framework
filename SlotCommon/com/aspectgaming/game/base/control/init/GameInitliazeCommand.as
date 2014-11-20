package com.aspectgaming.game.base.control.init
{
	import com.aspectgaming.core.ICustomLoader;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.data.loading.AssetProgressInfo;
	import com.aspectgaming.data.loading.LoadingDataInfo;
	import com.aspectgaming.data.loading.LoadingListInfo;
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.event.GlobalEvent;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.OverrideCommandlDefine;
	import com.aspectgaming.game.constant.asset.AssetDefined;
	import com.aspectgaming.game.controller.InitGameLobbyConnectionCommand;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.utils.GameUrlUtil;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.URLUtil;
	
	import flash.display.Bitmap;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import org.assetloader.core.ILoader;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * 游戏初始化开始 
	 * @author mason.li
	 * 
	 */	
	public class GameInitliazeCommand extends Command
	{
		private var _gameSettingUrl:String;
		private var _taskBarUrl:String;
		private var _gameAssetUrl:String;
		private var _langTextUrl:String;
		
		private var _bitmapFontConfig:XML;
		private var _gambleHistoryConfig:XML;
		private var _soundConfig:XML;
		
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var gameInfo:GameInfo;
		
		[Inject]
		public var assetLoader:ICustomLoader;
		
		override public function execute():void
		{
			assetLoader.numConnections = 1;
			
			
			commandMap.mapEvent(GameEvent.GAME_INITIALIZE_COMPLETED, gameMgr.overrideControl.getCommandByType(OverrideCommandlDefine.RegisterGameCommand), GameEvent);
			
			//初始化加载路径
			GameUrlUtil.setupBase(gameInfo.gameAssetsPath);
			
			
			//加配置
			_gameSettingUrl = GameUrlUtil.getGameSetUrl();
			_gameAssetUrl = GameUrlUtil.getGameAssetUrl();
			_langTextUrl = GameUrlUtil.getLangConfigUrl();
			
			var loaderInfo:LoadingListInfo = new LoadingListInfo(onConfigLoaded);
			loaderInfo.addLoadDatas(new LoadingDataInfo(_gameSettingUrl, _gameSettingUrl));
			loaderInfo.addLoadDatas(new LoadingDataInfo(_gameAssetUrl, _gameAssetUrl));
			loaderInfo.addLoadDatas(new LoadingDataInfo(_langTextUrl, _langTextUrl));
			if (GameGlobalRef.simulator)
			{
				_taskBarUrl = GameUrlUtil.getTaskSetUrl();
				loaderInfo.addLoadDatas(new LoadingDataInfo(_taskBarUrl, _taskBarUrl));
			}
			
			dispatch(new GlobalEvent(GlobalEvent.LOAD_ASSETS, null, null, loaderInfo));
		}
		
		/**
		 * 配置加载完成 
		 * @param dic
		 * 
		 */		
		private function onConfigLoaded(dic:Dictionary):void
		{
			var gameSetXml:XML = XML(ILoader(dic[_gameSettingUrl]).data);
			GameSetting.init(gameSetXml);
			
			if (dic[_taskBarUrl] && GameGlobalRef.simulator)
			{
				var taskXml:XML = XML(ILoader(dic[_taskBarUrl]).data);
				GameGlobalRef.simulator.initEmnulation(taskXml.GameSetting.emnuStops[0], GameSetting.baseSymbloLen);
			}
			
			
			var langText:XML = XML(ILoader(dic[_langTextUrl]).data);
			_bitmapFontConfig = langText.font[0];
			_gambleHistoryConfig = langText.gamble[0];
				
			GameLanguageTextConfig.init(langText.lang[0], gameInfo.lang);
			
			var sringXml:String = String(ILoader(dic[_gameAssetUrl]).data).replace(/\$\{lang\}/g, gameInfo.lang);
			var assetXml:XML = XML(sringXml);
			GameAssetLibrary.version = String(assetXml.assetsGroup.@version);
			_soundConfig = assetXml.assetsGroup[0].sounds[0];
			
			//加载资源
			loadAssets(assetXml.assetsGroup.ui[0]);
		}
		
		private function loadAssets(xml:XML):void
		{
			var loaderInfo:LoadingListInfo = new LoadingListInfo(onAssetComplete, onProgress);
			GameAssetLibrary.gameAssetDomain = new ApplicationDomain();
			for each (var info:XML in xml.res)
			{
				if (Boolean(uint(info.@useRef)))
				{
					loaderInfo.addLoadDatas(new LoadingDataInfo(GameUrlUtil.getGameAssetUrlByTag(String(info.@url)), String(info.@match), GameAssetLibrary.gameAssetDomain));
				}
				else
				{
					loaderInfo.addLoadDatas(new LoadingDataInfo(GameUrlUtil.getGameAssetUrlByTag(String(info.@url)), String(info.@match), new ApplicationDomain()));
				}
			}
			dispatch(new GlobalEvent(GlobalEvent.LOAD_ASSETS, null, null, loaderInfo));
		}
		
		/**
		 * 资源加载完成 
		 * @param dic
		 * 
		 */		
		private function onAssetComplete(dic:Dictionary):void
		{
			if (dic[AssetDefined.MESSAGE_FONT])
			{
				var bitmap:Bitmap = (dic[AssetDefined.MESSAGE_FONT] as ILoader).data as Bitmap;
				GameAssetLibrary.initBitmap(_bitmapFontConfig, bitmap.bitmapData);
			}
			
			if (dic[AssetDefined.GAMBLE_HISTORY])
			{
				var histroyBitmap:Bitmap = (dic[AssetDefined.GAMBLE_HISTORY] as ILoader).data as Bitmap;
				GameAssetLibrary.initGambleHistory(_gambleHistoryConfig, histroyBitmap.bitmapData);
			}
			
			if (dic[AssetDefined.SOUNDS])
			{
				for each (var soundXml:XML in _soundConfig.sound)
				{
					SoundManager.registerSoundRefer(String(soundXml.@id), GameAssetLibrary.getClass(String(soundXml.@link)), uint(soundXml.@repeat), Boolean(uint(soundXml.@isMusic)));
				}
			}
			
			GameAssetLibrary.gameAssets = dic;
			
			assetLoader.numConnections = 5;
			
			//注册大厅监听
			dispatch(new GameEvent(GameEvent.GAME_INITIALIZE_COMPLETED));
		}
		
		private function onProgress(progressInfo:AssetProgressInfo):void
		{
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_LOADING_UPDATE, "", "", {pctAll: progressInfo.progress}))
		}
		
	}
}