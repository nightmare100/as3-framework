package com.aspectgaming.data.configuration.game
{
	import com.aspectgaming.data.configuration.game.constant.ActionDefined;
	import com.aspectgaming.data.configuration.game.constant.PageDefined;
	import com.aspectgaming.utils.StringUtil;

	/**
	 * 游戏信息 
	 * @author mason.li
	 * 
	 */	
	public dynamic class GameCellInfo
	{
		public var currentPageName:String;
		
		/**
		 * gameInfo用的PageName 
		 */		
		public var usedPageName:String;
		
		public var name:String;
		public var gameStyle:String;
		public var needExclusive:Boolean;
		
		private var _gameID:String;			
		public var gameName:String;
		public var folderName:String;
		public var logoUrl:String;
		public var freeSpinLogo:String;
		public var title:String;
		public var label:String;
		public var rangTxt:String;
		public var gameLockUrl:String;
		public var limitTxt:String;
		public var level:String;
		public var reEnter:Boolean;
		
		public var serverFormat:String;
		
		/**
		 * 解锁等级(到等级自动解锁) 
		 */		
		public var unLockLevel:int;
		
		/**
		 * 是否为使用新框架的游戏 
		 */		
		public var isNewGame:Boolean;
		
		
		
		public var action:String;
		
		/**
		 * Demo版本的路径 
		 */		
		public var demoPath:String;
		
		/**
		 * 是否为FreeGame 
		 */		
		public var isFreeGame:Boolean;
		public var isGift:Boolean;
		public var freeGameAmount:Number = 0;
		
		/**
		 * 是否被锁 
		 */		
		public var isLocked:Boolean;
		public var unLockCharms:Number = 0;
		
		public var serverUrl:String;
		public var loadingBarStyle:String;
		
		public var gameIDs:Array = [];
		
		public var normalGameID:String;
		public var jackpotGameID:String;
		
		public function GameCellInfo(xml:XML, pageName:String = null)
		{
			if (pageName)
			{
				currentPageName = pageName;
				usedPageName = pageName;
				name = String(xml.@name);
				action = (String(xml.@action) == null || String(xml.@action) == "") ? ActionDefined.ACTION_INTO_GAME : String(xml.@action);
				
				gameStyle = String(xml.@gameStyle);
				gameName = String(xml.@gameName);
				gameName = StringUtil.isEmptyString(gameName) ? name : gameName;
				
				folderName = String(xml.@folderName);
				logoUrl = String(xml.@logo);
				
				freeSpinLogo = String(xml.@logopic);
				title = String(xml.@title);
				label = String(xml.@label);
				rangTxt = String(xml.@range);
				gameLockUrl = String(xml.@gameLock);
				limitTxt = String(xml.@limit);
				isNewGame = Boolean(uint(xml.@isNewGame));
				needExclusive = Boolean(uint(xml.@needExclusive));
				
				if (String(xml.@gameID))
				{
					gameIDs = String(xml.@gameID).split(",");
					gameID = gameIDs[0];
				}
				else
				{
					//for slot
					if (xml.normal[0])
					{
						normalGameID = String(xml.normal[0].@gameID);
					}
					
					if ( xml.jackpot[0])
					{
						jackpotGameID = String(xml.jackpot[0].@gameID);
					}
				}
				
				
				serverUrl = String(xml.@server);
				loadingBarStyle = String(xml.@loadingBar);
				
				demoPath = String(xml.@demoPath);
				
			}
		}

		public function get gameID():String
		{
			return _gameID;
		}
		/**
		 * 判断是否是jackpot游戏 
		 * @return 
		 * 
		 */		
		public function isJackPortGame():Boolean
		{		
			return _gameID == jackpotGameID;
		}
		
		public function getCoverUrl(isBig:Boolean = false):String
		{
			if (currentPageName == PageDefined.Lobby_Home)
			{
				return logoUrl + (isBig ? "_big.jpg" : "_cover.jpg");
			}
			else
			{
				return logoUrl;
			}
		}
		
		public function getReelUrl(isBig:Boolean = false):String
		{
			if (currentPageName == PageDefined.Lobby_Home)
			{
				return logoUrl + (isBig ? "_reel_big.jpg" : "_reel.jpg");
			}
			else
			{
				return null;
			}
		}
		
		

		/**
		 * 游戏ID 
		 */
		public function getGameidByIdx(idx:uint = 0):String
		{
			if (idx >= gameIDs.length)
			{
				return gameIDs[0];
			}
			else
			{
				return gameIDs[idx];
			}
		}

		/**
		 * @private
		 */
		public function set gameID(value:String):void
		{
			_gameID = value;
		}

		public function clone():GameCellInfo
		{
			var cell:GameCellInfo = new GameCellInfo(null, null);
			cell.currentPageName = currentPageName;
			cell.usedPageName	 = usedPageName;
			cell.name = name;
			cell.action = action;
			
			cell.gameStyle = gameStyle;
			cell.gameName = gameName;
			cell.folderName = folderName;
			cell.logoUrl = logoUrl;
			cell.title = title;
			cell.label = label;
			cell.rangTxt = rangTxt;
			cell.gameLockUrl = gameLockUrl;
			cell.limitTxt = limitTxt;
			cell.isNewGame = isNewGame;
			cell.gameID = gameID;
			cell.isLocked = isLocked;
			cell.unLockCharms = unLockCharms;
			
			cell.isNewGame = isNewGame;
			cell.needExclusive = needExclusive;
			cell.serverUrl = serverUrl;
			cell.loadingBarStyle = loadingBarStyle;
			cell.demoPath = demoPath;
			cell.gameIDs = gameIDs;
			cell.jackpotGameID = jackpotGameID;
			cell.normalGameID = normalGameID;
			
			cell.freeSpinLogo = freeSpinLogo;
			cell.unLockLevel = unLockLevel;
			
			return cell;
		}
		
		public function get isDisabled():Boolean
		{
			return action == ActionDefined.ACTION_DISABLED;
		}
		
		public function get isHighLimitGame():Boolean
		{
			return usedPageName == PageDefined.HighLimit_Page;
		}
		
		public function get isBlackJackGame():Boolean
		{
			return usedPageName == PageDefined.BlackJack_Page;
		}
	}
}