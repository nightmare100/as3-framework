package com.aspectgaming.data.configuration.game
{
	import com.aspectgaming.constant.global.TournamentLevelDefined;
	import com.aspectgaming.data.configuration.LevelsRuinConfiguration;
	import com.aspectgaming.data.configuration.game.constant.ActionDefined;
	import com.aspectgaming.data.configuration.game.constant.PageDefined;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.utils.NumberUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 * 大厅游戏数据配置 
	 * @author mason.li
	 * 
	 */	
	public class GameListConfig
	{
		public static const MY_SLOT_ID:String = "74";
		private const KENO_ID:String = "28";
		
		private var _pageDic:Dictionary;
		private var _giftGameCell:Dictionary;
		
		public function GameListConfig(xml:XML, giftInfo:XML)
		{
			_pageDic = new Dictionary();
			parseOtherPageInfo(xml);
			parseGiftInfo(giftInfo);
		}
		
		/**
		 *  Slot数据过滤 
		 * @param arr 过滤JACKPOT ID
		 * @return 
		 * 
		 */		
		public function filterSlotGameIDs(arr:Array):Array
		{
			var result:Array = [];
			var slotGames:Vector.<GameCellInfo> = PageInfo(_pageDic[PageDefined.Slots_Page]).gameInfos;
			
			for (var i:uint = 0 ; i < arr.length; i++)
			{
				var gameID:String = arr[i];
				
				for each (var info:GameCellInfo in slotGames)
				{
					if (info.normalGameID == gameID || info.jackpotGameID == gameID)
					{
						if (result.indexOf(info.normalGameID) == -1)
						{
							result.push(info.normalGameID);
							break;
						}
					}
				}
			}
			
			
			return result;
		}
		
		/**
		 * 获取升级 可解锁的游戏列表 
		 * @return 
		 * 
		 */		
		public function getLevelUpGameLists(preLv:int, curLv:int):Vector.<GameCellInfo>
		{
			var result:Vector.<GameCellInfo> = new Vector.<GameCellInfo>();
			var lists:Vector.<GameCellInfo> = PageInfo(_pageDic[PageDefined.Slots_Page]).gameInfos;
			for (var i:uint = 0 ; i < lists.length; i++)
			{
				if (lists[i].isLocked && lists[i].unLockLevel > preLv && lists[i].unLockLevel <= curLv)
				{
					lists[i].isLocked = false;
					lists[i].gameID = null;
					result.push(lists[i]);
				}
			}
			filterOverCell(result);
			return result;
				
		}
		
		/**
		 * 过滤重复元素 
		 * @param list
		 * 
		 */		
		private function filterOverCell(list:*):void
		{
			for (var i:uint = 0; i < list.length; i++)
			{
				var currentCell:GameCellInfo = list[i];
				for (var j:uint = i + 1; j < list.length; j++)
				{
					if (currentCell.name == list[j].name)
					{
						list.splice(j--, 1);
					}
				}
			}
		}
		
		
		
		/**
		 * 列表中是否存在某个游戏
		 * @param list
		 * 
		 */		
		public function hasExistInList(name:String, list:Vector.<GameCellInfo>):Boolean
		{
			for (var i:uint = 0; i < list.length; i++)
			{
				var currentCell:GameCellInfo = list[i];
				if (currentCell.name == name)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 获取子页面的最上级父页面 
		 * @param pageName
		 * @return 
		 * 
		 */		
		public function getParentPage(pageName:String):String
		{
			var pageInfo:PageInfo = _pageDic[pageName];
			if (pageInfo && pageInfo.parentName != PageDefined.Lobby_Home)
			{
				return getParentPage(pageInfo.parentName);
			}
			else
			{
				return pageInfo.name;
			}
		}
		
		public function get pageDic():Dictionary
		{
			return _pageDic;
		}
		
		public function get mainPageNames():Array
		{
			return [PageDefined.Slots_Page, PageDefined.Page_TableGame, PageDefined.HighLimit_Page, PageDefined.Page_Tourament];
		}
		
		private function parseGiftInfo(xml:XML):void
		{
			_giftGameCell = new Dictionary();
			for (var i:uint = 0; i < xml.game.length(); i++ )
			{
				var innerList:XML = xml.game[i];
				_giftGameCell[String(innerList.@name)] = new GameCellInfo(innerList, String(innerList.@page));
			}
		}

		/**
		 * 解析页面信息 
		 * @param xml
		 * 
		 */		
		private function parseOtherPageInfo(xml:XML):void
		{
			var list:XMLList = xml.children();
			for (var i:uint = 0; i < list.length(); i++ )
			{
				var innerList:XML = list[i];
				
				if (String(innerList.@action) != ActionDefined.ACTION_INTO_GAME && String(innerList.@action) != ActionDefined.ACTION_DISABLED && innerList.name() != "game")
				{
					
					if (!String(innerList.@parent))
					{
						PageDefined.Lobby_Home = String(innerList.@name);
						ClientManager.currentPage = PageDefined.Lobby_Home;
					}
					
					_pageDic[String(innerList.@name)] = new PageInfo(innerList);
					parseOtherPageInfo(innerList);
				}
			}
		}
		
		/**
		 * 设置游戏解锁信息 
		 * @param gameArr 已用龙币解锁的游戏
		 * 
		 */		
		public function setLockGameInfo(gameArr:Array):void
		{
			var pageInfo:PageInfo = _pageDic[PageDefined.Slots_Page];
			var currentLevel:int = ClientManager.lobbyModel.levelInfo.currentLevel;
			for each (var info:GameCellInfo in pageInfo.gameInfos)
			{
				if (gameArr.indexOf(int(info.normalGameID)) != -1 || info.unLockLevel <= currentLevel)
				{
					info.isLocked = false;
				}
				else
				{
					info.isLocked = true;
				}
			}
		}
		
		public function get isInHomePage():Boolean
		{
			var currGameName:String = ClientManager.currGame.gameName;
			
//			if (currGameName==PageDefined.Keno_Page || currGameName==PageDefined.Poker_Page) {
//				return true;
//			}
			return false;
			
			//return [PageDefined.Keno_Page].indexOf(ClientManager.currGame.gameName) != -1;
		}
		
		/**
		 * 获取TournamentID 
		 * @param lv
		 * @return 
		 * 
		 */		
		public function getTournamentGameID(lv:String):String
		{
			var gameCell:GameCellInfo = getGameInfoByGameID("79");
			var idx:uint = lv == TournamentLevelDefined.TournamentLevelLow ? 0 : (lv == TournamentLevelDefined.TournamentLevelMiddle ? 1 : 2);
			idx = ClientManager.lobbyModel.isNormalTouramentID ? idx + 3 : idx;
			
			return gameCell.getGameidByIdx(idx);
		}
		
		public function isTournamentGame(id:String):Boolean
		{
			var gameCell:GameCellInfo = getGameInfoByGameID("79");
			return gameCell.gameIDs.indexOf(id) != -1
		}
		
		public function isPage(key:String):Boolean
		{
			return _pageDic[key] != null || key == PageDefined.Previous_Page;
		}
		
		/**
		 * 设置游戏解锁金额 
		 * 
		 */		
		public function setUnlockDragonDollor(obj:Object):void
		{
			var pageInfo:PageInfo;
			for (var key:String in _pageDic)
			{
				pageInfo = _pageDic[key];
				for each (var cell:GameCellInfo in pageInfo.gameInfos)
				{
					if (cell.normalGameID in obj)
					{
						cell.unLockCharms += NumberUtil.centToDollar(obj[cell.normalGameID]);
					}
					
					if (cell.jackpotGameID in obj)
					{
						cell.unLockCharms += NumberUtil.centToDollar(obj[cell.jackpotGameID]);
					}
				}
			}
		}
		
		/**
		 * 设置Slot 游戏 等级解锁信息
		 * 
		 */		
		public function setSlotGameUnLockLevel(obj:Object):void
		{
			var pageInfo:PageInfo = _pageDic[PageDefined.Slots_Page];
			for (var i:uint = 0; i < pageInfo.gameInfos.length; i++)
			{
				var gameCell:GameCellInfo = pageInfo.gameInfos[i];
				if (gameCell.normalGameID in obj)
				{
					gameCell.unLockLevel = obj[gameCell.normalGameID];
				}
			}
		}
		
		/**
		 * 解锁游戏 
		 * @param gameID
		 * 
		 */		
		public function unlockGame(gameID:String):void
		{
			var pageInfo:PageInfo;
			for (var key:String in _pageDic)
			{
				pageInfo = _pageDic[key];
				for each (var cell:GameCellInfo in pageInfo.gameInfos)
				{
					if (cell.gameID == gameID || cell.jackpotGameID == gameID || cell.normalGameID == gameID)
					{
						cell.isLocked = false;
					}
				}
			}
		}
		
		public function getGameCell(gameId:Number, amount:Number, pageName:String, level:uint = 0, isGift:Boolean = false ):GameCellInfo 
		{
			//trace("getGameCell_1", gameId, amount, pageName, level);
			var cell:GameCellInfo;
			switch(gameId) 
			{
				case 1:
					cell =	getBlackJackCell(amount, pageName, level);
					break;
				case 2:
					cell =	getKenoCell(amount);
					break;
				case 3:
					cell = getBaccaratCell(amount, pageName, level);
					//trace("getGameCell_2:", gameId, pageName, cell.name, _giftGameCell[cell.name]);
					break;
				case 4:
					cell = getRouletteCell(amount, pageName, level);
			}
			
			if (_giftGameCell[cell.name])
			{
				var giftCell:GameCellInfo = _giftGameCell[cell.name];
				
				
				
				if (isGift)
				{
					cell.logoUrl = giftCell.logoUrl.replace("jackpotSlots", "gift");
					cell.title = giftCell.title.replace("jackpotSlots", "gift");
					cell.currentPageName = PageDefined.BlackJack_Page;
					cell.isGift = true;
				}
				else
				{
					cell.logoUrl = giftCell.logoUrl;
					cell.title = giftCell.title;
				}
			}
			return cell;
		}
		
		
		/**
		 * 获取FREE HAND INFO (blackJackInfo)
		 * @param amount
		 * @return 
		 * 
		 */		
		public function getBlackJackCell(amount:Number, pageName:String, bjLevel:uint = 0):GameCellInfo
		{
			pageName = pageName == PageDefined.HighLimit_Page? pageName : PageDefined.BlackJack_Page;
			var blackJackPage:PageInfo = getPageInfoByName(pageName);
			var cell:GameCellInfo;
			if (pageName == PageDefined.BlackJack_Page)
			{
				cell = blackJackPage.gameInfos[bjLevel].clone();
			}
			else
			{
				cell = blackJackPage.getCellByGameID("38");
			}
			
			if (amount>0) {
				cell.isFreeGame = true;
			}
			cell.freeGameAmount = amount;
			
			return cell;
		}
		
		/**
		 * 获取Keno Spin信息 
		 * @param amount
		 * @return 
		 * 
		 */		
		public function getKenoCell(amount:Number):GameCellInfo
		{
			var cell:GameCellInfo = getGameInfoByGameID(KENO_ID).clone();
			
			if (amount>0) {
				cell.isFreeGame = true;
			}
			cell.freeGameAmount = amount;
			
			return cell;
		}
		
		/**
		 * 获取Baccarat Spin信息 
		 * @param amount
		 * @return 
		 * 
		 */	
		public function getBaccaratCell(amount:Number, pageName:String, bcLevel:uint=0):GameCellInfo
		{
			pageName = pageName == PageDefined.HighLimit_Page? pageName : PageDefined.Baccarat_Page;
			
			var baccaratPage:PageInfo = getPageInfoByName(pageName);
			var cell:GameCellInfo;
			
			if (pageName == PageDefined.Baccarat_Page)
			{
				cell = baccaratPage.gameInfos[bcLevel].clone();
				//cell = baccaratPage.getCellByGameID("52");
			}
			else
			{
				cell = baccaratPage.getCellByGameID("67");
			}
			
			if (amount>0) {
				cell.isFreeGame = true;
			}
			cell.freeGameAmount = amount;
			
			return cell;
		}
		
		public function getRouletteCell(amount:Number, pageName:String, bcLevel:uint = 0):GameCellInfo
		{
			pageName = pageName == PageDefined.HighLimit_Page? pageName : PageDefined.Roulette_Page;
			
			var roulettePage:PageInfo = getPageInfoByName(pageName);
			var cell:GameCellInfo;
			
			
			if (pageName == PageDefined.Roulette_Page)
			{
				cell = roulettePage.gameInfos[bcLevel].clone();
			}
			else
			{
				cell = roulettePage.getCellByGameID("68");		//roulette in highLimit page
			}
			
			if (amount>0) {
				cell.isFreeGame = true;
			}
			cell.freeGameAmount = amount;
			
			return cell;
		}
		
		
		/**
		 * 获取用户能玩的最高等级的BLACK JACK游戏信息
		 * @return 
		 * 
		 */		
		public function getUserBlackJackGame():GameCellInfo
		{
			var blackJackPage:PageInfo = getPageInfoByName(PageDefined.BlackJack_Page);
			var cell:GameCellInfo = blackJackPage.gameInfos[LevelsRuinConfiguration.tableLimits - 1];
			
			return cell;
		}
		
		/**
		 * 获取FreeSpin游戏列表 
		 * @return 
		 * 
		 */		
		public function getFreeSpinInfo(amount:Number, pageName:String):Vector.<GameCellInfo>
		{
			var pageInfo:PageInfo;
			var vec:Vector.<GameCellInfo>;
			if (pageName == PageDefined.HighLimit_Page)
			{
				pageInfo = _pageDic[pageName];
				vec = Vector.<GameCellInfo>([pageInfo.getCellByGameID("36"), pageInfo.getCellByGameID("43"), pageInfo.getCellByGameID("39")]);
			}
			else if (pageName == PageDefined.JackPots_Page)
			{
				pageInfo = _pageDic[pageName];
				vec = Vector.<GameCellInfo>([pageInfo.getCellByGameID("25"), pageInfo.getCellByGameID("31"), pageInfo.getCellByGameID("30")]);
			}
			else
			{
				pageInfo = _pageDic[PageDefined.Slots_Page];
				vec = Vector.<GameCellInfo>([pageInfo.getCellByGameID("13"), pageInfo.getCellByGameID("6"), pageInfo.getCellByGameID("2")]);
			}
			
			for each (var info:GameCellInfo in vec)
			{
				//大背景
				info.currentPageName = PageDefined.BlackJack_Page;
				info.logoUrl = info.logoUrl.replace("slots", "gift").replace("slots","highlimits");
				info.title = info.title.replace("slots", "gift").replace("slots","highlimits");
				info.isFreeGame = true;
				info.isGift = true;
				info.freeGameAmount = amount;
				info.isLocked = false;
			}
			return vec;
		}
		
		public function getPageInfoByName(name:String):PageInfo
		{
			return _pageDic[name];
		}
		
		public function getGameInfoByName(name:String):GameCellInfo
		{
			var pageSortArr:Array = [PageDefined.Slots_Page, PageDefined.Page_TableGame, PageDefined.Baccarat_Page, PageDefined.BlackJack_Page, PageDefined.Roulette_Page, PageDefined.HighLimit_Page]
			for (var i:uint = 0; i < pageSortArr.length; i++)
			{
				var info:PageInfo = _pageDic[pageSortArr[i]];
				for each (var data:GameCellInfo in info.gameInfos)
				{
					if (data.name.toLocaleUpperCase() == name.toLocaleUpperCase())
					{
						return data;
					}
				}
			}
			return null;
		}
		
		public function getGameInfoByGameID(id:String):GameCellInfo
		{
			for (var key:String in _pageDic)
			{
				var info:PageInfo = _pageDic[key];
				for each (var data:GameCellInfo in info.gameInfos)
				{
					if (data.gameID && data.gameID == id)
					{
						return data;
					}
					else
					{
						if (data.normalGameID == id || data.jackpotGameID == id)
						{
							return data;
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * 取游戏原始名字 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getSourceGameNameByID(id:String):String
		{
			for (var key:String in _pageDic)
			{
				var info:PageInfo = _pageDic[key];
				for each (var data:GameCellInfo in info.gameInfos)
				{
					if (data.gameID && data.gameID == id)
					{
						return data.name;
					}
					else
					{
						if (data.jackpotGameID == id || data.normalGameID == id)
						{
							return data.name;
						}
					}
				}
			}
			return null;
		}
		
		public function getParentPageName(id:String):String
		{
			for (var key:String in _pageDic)
			{
				var info:PageInfo = _pageDic[key];
				for each (var data:GameCellInfo in info.gameInfos)
				{
					if (data.gameID == id)
					{
						if (data.currentPageName != PageDefined.Lobby_Home)
						{
							return data.currentPageName;
						}
						else
						{
							return null;
						}
					}
				}
			}
			return null;
		}
		
		public function getGameCellList(pageName:String, isLock:Boolean = false, angionLock:Boolean = false):Array
		{
			var info:PageInfo = _pageDic[pageName];
			var result:Array = [];
			var sortArr:Vector.<GameCellInfo> = info.sortedGameInfo;
			for (var i:uint = 0; i < sortArr.length; i++)
			{
				var gameInfo:GameCellInfo = sortArr[i];
				if ((angionLock || gameInfo.isLocked == isLock) && gameInfo.name != ClientManager.currGame.gameName && gameInfo.name != "Coming Soon")
				{
					result.push(gameInfo)
				}
			}
			filterOverCell(result);
			return result;
		}
		
		
		
		public function getAllGameCellList(isLock:Boolean = false):Array
		{
			var info:PageInfo = _pageDic[PageDefined.Slots_Page];
			var result:Array = [];
			var gameInfo:GameCellInfo
			for (var i:uint = 0; i < info.gameInfos.length; i++)
			{
				gameInfo = info.gameInfos[i];
				if (gameInfo.name != ClientManager.currGame.gameName && gameInfo.name != "Coming Soon")
				{
					result.push(gameInfo)
				}
			}
			filterOverCell(result);
			
			info = _pageDic[PageDefined.Page_TableGame];
			for (i = 0; i < info.gameInfos.length; i++)
			{
				gameInfo = info.gameInfos[i];
				if (gameInfo.name != ClientManager.currGame.gameName && gameInfo.action == ActionDefined.ACTION_INTO_GAME)
				{
					result.push(gameInfo)
				}
			}
			var pageArr:Array = [PageDefined.Baccarat_Page, PageDefined.Roulette_Page, PageDefined.BlackJack_Page];
			if (pageArr.indexOf(ClientManager.currentPage) != -1)
			{
				pageArr.splice(pageArr.indexOf(ClientManager.currentPage) , 1);
			}
			for (i = 0; i < pageArr.length; i++)
			{
				result.push(_pageDic[pageArr[i]]);
			}
			return result;
		}
	}
}