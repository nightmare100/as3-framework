package  com.aspectgaming.data.configuration 
{
	import com.aspectgaming.constant.global.LoyaltyLevelDefined;
	import com.aspectgaming.data.configuration.vo.LevelRewardData;
	import com.aspectgaming.data.configuration.vo.RankRewardData;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.utils.NumberUtil;

	//import com.aspectgaming.net.vo.LevelConfigDTO;
	//import com.aspectgaming.net.vo.LoyaltyDTO;
	//import com.aspectgaming.net.vo.LoyaltyLevelInfoDTO;

	/**
	 * ...
	 * @author 1
	 */
	public class LevelsRuinConfiguration 
	{
		private static var _currentLevelName:String;
		private static var _levelsRuin:Array;
		private static var _rankRuin:Array;
		private static var _tableLimits:uint;
		private static var _enterHighLimits:Boolean;
		private static var _levelName:String;
		private static var _purchaseBonus:Number;
		private static var _timeBonus:uint;
		private static var _freeChipsEvery:Number;
		// 旧的
		private static var _level:uint;
		private static var _maxBet:uint = 1;
		
		private static var _dailyBonus:uint;
		
		private static var _tableHands:uint;
		private static var _maxRouletteBet:uint;
		
		public function LevelsRuinConfiguration() 
		{
		
		}

		public static function get enterHighLimits():Boolean
		{
			return _enterHighLimits;
		}

		public static function get purchaseBonus():Number
		{
			return _purchaseBonus;
		}

		public static function get freeChipsEvery():Number
		{
			return _freeChipsEvery;
		}

		public static function get maxRouletteBet():uint
		{
			return _maxRouletteBet;
		}

		public static function parseData(loyalty:Array,rank:Array):void 
		{
			trace("///////////////////////////")
			_levelsRuin = [];
			_rankRuin = []
			for (var i:uint = 0; i < loyalty.length; i++) 
			{
				_levelsRuin.push(new LevelRewardData(loyalty[i]));	//LevelConfigDTO);
			}
			
			for (var j:uint = 0; j < rank.length; j++) 
			{
				_rankRuin.push(new RankRewardData(rank[j]));

			}
			updateLevel(LoyaltyLevelDefined.BasicLoyalty);//1);
		}
		
		public static function updateLevel(lv:String):void//lv:uint):void 
		{
			for (var i:uint = 0; i < _levelsRuin.length; i++ ) 
			{
				var lvData:LevelRewardData = _levelsRuin[i] as LevelRewardData;
				if (lvData.levelName == lv)
				{
					_tableLimits = lvData.tableLimit > 0?lvData.tableLimit:_tableLimits;
					_enterHighLimits = lvData.enterHighLimits;
					_levelName = lvData.levelName;
					_purchaseBonus = lvData.purchaseBonus;			
					_freeChipsEvery = lvData.freeChipsEvery * 60; // 分钟
					_timeBonus = lvData.timeBonus; //
					break;
				}
			}
			_currentLevelName = lv;
			
//			ClientManager.lobbyModel.timeReward.rewardAmount = NumberUtil.centToDollar(_timeBonus);//LevelsRuinConfiguration.timeBonus);//dto.timeRewardCount);
						
			_maxRouletteBet = 5000; // 荣耀 现在 默认blackjack 是最大
			_tableHands = 5;
//			for (var i:uint = 0; i < _levelsRuin.length; i++ ) 
//			{
//				var lvData:LevelRewardData = _levelsRuin[i] as LevelRewardData;
//				if (lvData.level == lv)
//				{
//					_maxBet = lvData.maxBet > 0?lvData.maxBet:_maxBet;
//					_timeBonus = lvData.timeBonus > 0?lvData.timeBonus:_timeBonus;
//					_dailyBonus = lvData.dailyBonus > 0?lvData.dailyBonus:_dailyBonus;
//					_tableHands = lvData.tableHands > 0?lvData.tableHands:_tableHands;
//					_tableLimits = lvData.tableLimits > 0?lvData.tableLimits:_tableLimits;
//					_maxRouletteBet = lvData.maxRouletteBet > 0?lvData.maxRouletteBet : _maxRouletteBet;
//					break;
//				}
//			}
//			_level = lv;
		}
		
		/**
		 * 获取指定等级的等级配置数据
		 * @param	levelName
		 * @return
		 */
		public function getLevelInfo(levelName:String):LevelRewardData
		{
			for each(var item:LevelRewardData in _levelsRuin) {
				if (item.levelName == levelName) {
					return item;
				}
			}
			return null;
		}
		
		public static function get levelsRuin():Array 
		{
			return _levelsRuin;
		}
		
		public static function get rankRuin():Array 
		{
			return _rankRuin;
		}
		public static function get level():uint 
		{
			return _level;
		}
		
		public static function get maxBet():uint 
		{
			return _maxBet;
		}
		
		public static function get timeBonus():uint 
		{
			return _timeBonus;
		}
		
		public static function get dailyBonus():uint 
		{
			return _dailyBonus;
		}
		
		public static function get tableLimits():uint 
		{
			return _tableLimits;
		}
		
		public static function get tableHands():uint 
		{
			return _tableHands;
		}
	}
}