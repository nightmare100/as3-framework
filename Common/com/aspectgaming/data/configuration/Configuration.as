package com.aspectgaming.data.configuration
{
	import com.aspectgaming.constant.PromotionDefine;
	import com.aspectgaming.data.configuration.game.GameListConfig;
	import com.aspectgaming.data.configuration.item.ItemDescription;
	import com.aspectgaming.data.configuration.vo.AdvertisList;
	import com.aspectgaming.data.configuration.vo.AssetsPath;
	import com.aspectgaming.data.configuration.vo.ConfigedLangWord;
	import com.aspectgaming.data.configuration.vo.DelcareInfo;
	import com.aspectgaming.data.configuration.vo.GameDescription;
	import com.aspectgaming.data.configuration.vo.General;
	import com.aspectgaming.data.configuration.vo.ImageInfo;
	import com.aspectgaming.data.configuration.vo.Language;
	import com.aspectgaming.data.configuration.vo.Servers;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.utils.LoggerUtil;
	
	public class Configuration 
	{
		private static const _promoGame:Array = [PromotionDefine.HALLOWEEN, PromotionDefine.XMAS, PromotionDefine.BLUE_DRAGON_FESTIVAL, PromotionDefine.ST_PATRICKS_DAY];
		
		/**
		 * LeaderBoard 周期 
		 */		
		public static const LEADER_BOARD_CYCLE:Number = 1000 * 3600 * 24 * 7;
		
		public static var configXML:XML;
		public static var general:General;
		public static var servers:Servers;
		public static var assetsPath:AssetsPath;
		public static var images:ImageInfo;
		public static var language:Language;
		public static var gameListConf:GameListConfig;
		public static var jackpotsUpdateTime:uint;
		public static var playGameDesc:GameDescription;
		public static var messageAreaDatas:AdvertisList;
	
		public static var lang:ConfigedLangWord;
		public static var delcare:DelcareInfo;
		public static var isDebugMode:Boolean;
		public static var debugServerList:Array;
		
		/**
		 * 促销配置 
		 */		
		public static var promotionSetting:PromotionSetting;
		
		public static var itemDescription:ItemDescription;
		
		public static function get hasMiniGame():Boolean
		{
			if (_promoGame.indexOf(ClientManager.lobbyModel.facebookUser.promoName) != -1) 
			{
				return true;
			}
			return false;
		}
		
		public static function parseData(xml:XML, debugServer:XMLList):void
		{
			configXML = xml;
			
			
			var generalXML:XMLList = configXML.general;
			var serversXML:XMLList = configXML.servers;
			var assetsPathXML:XMLList = configXML.assetsPath;
			var imagesXML:XMLList = configXML.images;
			var languageXML:XMLList = configXML.languages.language;
			
			general = new General(generalXML);
			servers = new Servers(serversXML);
			assetsPath = new AssetsPath(assetsPathXML);
			images = new ImageInfo(imagesXML);
			language = new Language(languageXML);
			gameListConf = new GameListConfig(configXML.gameInfo[0], configXML.gameGiftInfo[0]);
			messageAreaDatas = new AdvertisList(configXML.MessageingArea);
			jackpotsUpdateTime = uint(generalXML[0].jackpot.@updateTime);
			
			playGameDesc = new GameDescription(configXML.Gamedescription.game);
			promotionSetting = new PromotionSetting(generalXML.promotion.@mode, generalXML.promotion.@perTime, generalXML.promotion.@onlyTime);
			
			if (ClientManager.isDebug)
			{
				parseDebugServer(debugServer);
			}
		}
			
		
		public static function parseItemDesc(xml:XML):void
		{
			if (!itemDescription)
			{
				itemDescription = new ItemDescription();
			}
			itemDescription.parse(xml);
		}
		
		public static function parseLang(langXML:XML, declare:XML):void
		{
			if (langXML != null) {
				lang = new ConfigedLangWord(langXML);
				delcare = new DelcareInfo(declare);
			}else {
				LoggerUtil.traceNormal("langXML is null!");
			}
		}
		
		public static function parseDebugServer(list:XMLList):void
		{
			debugServerList = [];
			for each (var xml:XML in list)
			{
				var obj:Object = {};
				obj.name = xml.@name;
				obj.server = xml.@server;
				debugServerList.push(obj);
			}
		}
		
		/**
		 * 取Language配置 文本语句 
		 * @param key language.xml配置的 id
		 * @return 
		 * 
		 */		
		public static function getConfigedWord(key:String):String
		{
			return lang.getWord(key);
		}
		
	}
	
}