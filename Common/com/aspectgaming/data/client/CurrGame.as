package com.aspectgaming.data.client 
{
	import com.aspectgaming.constant.GiftType;
	import com.aspectgaming.data.configuration.game.GameCellInfo;
	import com.aspectgaming.data.configuration.game.constant.PageDefined;
	
	public class CurrGame 
	{
		/**
		 * 当前游戏目前每一线赌注 
		 */		
		public var totalBet:Number;
		
		/**
		 * 当前游戏允许的最大行数 
		 */		
		public var maxLine:Number;
		public var maxBet:Number = 200;
		
		public var publishDesc:String;
		public var publishPic:String;

		public var freeSpinRunNum:Number = 0;
		public var freeSpinWon:Number = 0;
		public var freeSpinName:String;
		
		public var freeSpinActivityID:String;		//FreeSpin ID
		public var freeHandsActivityID:String;		//FreeHand ID
		public var newLevelActivityID:String;		//newLevel ID
		public var gamePlayActivityID:String;		//GamePlay ID
		public var bigWinActivityID:String;		//BigWin   ID
		
		private var _isInGamingProgress:Boolean;
		
		private var _currentGameInfo:GameCellInfo;
		private var _lastGameInfo:GameCellInfo;
		
		private var _isInGame:Boolean;
		
		private const CUSTOM_GAME_LIST:Array = ["74", "12"];

		public function CurrGame() 
		{
			
		}
		
		public function get lastGameInfo():GameCellInfo
		{
			return _lastGameInfo;
		}

		/**
		 * 游戏是否在游戏进程中 
		 */
		public function get isInGamingProgress():Boolean
		{
			return _isInGamingProgress && _currentGameInfo && isCustomizeGame(_currentGameInfo.gameID);
		}

		/**
		 * @private
		 */
		public function set isInGamingProgress(value:Boolean):void
		{
			_isInGamingProgress = value;
		}

		public function get currentGameInfo():GameCellInfo
		{
			return _currentGameInfo;
		}

		public function set currentGameInfo(value:GameCellInfo):void
		{
			if (!value)
			{
				_lastGameInfo = _currentGameInfo;
			}
			_currentGameInfo = value;
			isInGamingProgress = false;
		}
		
		/**
		 * 是否在可使用道具的 游戏中 
		 * @return 
		 * 
		 */		
		public function get isInCustomizeGame():Boolean
		{
			return isInGame && _currentGameInfo && isCustomizeGame(_currentGameInfo.gameID);
		}
		
		public function isCustomizeGame(gid:String):Boolean
		{
			return CUSTOM_GAME_LIST.indexOf(gid) != -1;
		}
		
		public function isBlackJack(gid:String):Boolean
		{
			return (gid == "12");
		}
		public function isMyslot(gid:String):Boolean
		{
			return (gid == "74");
		}
		
		/**
		 * 游戏初始化完成 
		 * @return 
		 * 
		 */		
		public function get isInGame():Boolean
		{
			return _isInGame;
		}
		
		public function set isInGame(value:Boolean):void
		{
			_isInGame = value;
			
			if (value)
			{
				isInGamingProgress = false;
			}
		}
		
		public function get gameName():String
		{
			if (_currentGameInfo)
			{
				return _currentGameInfo.name;
			}
			else
			{
				return null;
			}
		}
		
		public function get gameID():String
		{
			if (_currentGameInfo)
			{
				return _currentGameInfo.gameID;
			}
			else
			{
				return null;
			}
		}
		
		public function get publishName():String
		{
			if (_currentGameInfo)
			{
				return _currentGameInfo.name;
			}
			else if (_lastGameInfo)
			{
				return _lastGameInfo.name;
			}
			else
			{
				return null;
			}
		}
		
		public function get pageName():String
		{
			if (_currentGameInfo)
			{
				return _currentGameInfo.usedPageName;
			}
			else
			{
				return null;
			}
		}
		
		public function get gameGift():uint
		{
			if (_currentGameInfo.name.toLocaleLowerCase() == PageDefined.Keno_Page.toLocaleLowerCase() || _currentGameInfo.name.toLocaleLowerCase() == PageDefined.Baccarat_Page.toLocaleLowerCase())
			{
				return GiftType.GIFT_TYPE_KENO_SPIN;
			}
			else if (_currentGameInfo.name.toLocaleLowerCase() == PageDefined.BlackJack_Page.toLocaleLowerCase())
			{
				return GiftType.GIFT_TYPE_SPIN_PLAY;
			}
			else if (_currentGameInfo.name.toLocaleLowerCase() == PageDefined.BACCARAT_STANTDER.toLocaleLowerCase())
			{
				return GiftType.GIFT_TYPE_KENO_SPIN;
			}else if (_currentGameInfo.name.toLocaleLowerCase() == PageDefined.Roulette_Page.toLocaleLowerCase()) 
			{
				return GiftType.GIFT_TYPE_KENO_SPIN;
			}
			else
			{
				return GiftType.GIFT_TYPE_FREE_GAME;
			}
		}
	}

}