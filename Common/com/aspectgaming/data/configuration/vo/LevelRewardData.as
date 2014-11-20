package  com.aspectgaming.data.configuration.vo
{
	//import com.aspectgaming.net.vo.LevelConfigDTO;
	//import com.aspectgaming.net.vo.LoyaltyDTO;
	//import com.aspectgaming.net.vo.LoyaltyLevelInfoDTO;
	import com.aspectgaming.utils.NumberUtil;
	
	/**
	 * 升级奖励信息 
	 * @author mason.li
	 * 
	 */	
	public class LevelRewardData 
	{
		private var _levelName:String;
		private var _purchaseBonus:Number;
		private var _freeChipsEvery:Number;
		private var _timeBonus:Number;
		private var _enterHighLimits:Boolean;
		private var _tableLimit:Number;
		
		private var _loyaltyPoint:Number;
		
		private var _level:uint;
		// 旧的		
		private var _rewardList:Array
		
		//		private var _maxBet:uint;
		//	//	private var _timeBonus:uint;
		//		private var _dailyBonus:uint;
		//		private var _tableLimits:uint;
		//		private var _tableHands:uint;
		//		private var _maxRouletteBet:int;
		
		/**
		 * 传入 level对应信息 当前 只是 荣誉积分点  和 level名字 
		 * @param config
		 * @param levelName
		 * 
		 */			
		public function LevelRewardData(config:Object):void//levelPoint:Number, levelName:String = null):void //config : LevelConfigDTO, =》 loyaltyDTO?
		{
			_levelName = config.levelName;
			_purchaseBonus = config.purchaseBonus;			
			_freeChipsEvery = config.freeChipsEvery;
			_timeBonus = config.timeBonus; 
			_enterHighLimits = config.enterHighLimits;
			_loyaltyPoint = NumberUtil.centToDollar(config.tableLimit); // 传入分数
			processTableLimit();
			//			_level = config.level;
			// 旧的
			_rewardList = [];
			//			config.dailyReward = NumberUtil.centToDollar(config.dailyReward);
			//			config.timeReward = NumberUtil.centToDollar(config.timeReward);
			//					public var playerId:Number;
			//			processReward(RewardData.UNLOCK, RewardName.MaxBetReward, config.maxBet);
			//			processReward(RewardData.UNLOCK, RewardName.RouletteBet, config.maxRouletteBet);
			//			processReward(RewardData.UNLOCK, RewardName.tablehandsReward, config.tablehands);
			//			processReward(RewardData.UNLOCK, RewardName.tableLimitsReward, config.playerTablelimit);
			//			processReward(RewardData.BONUS, RewardName.DailyReward, config.dailyReward);
			//			processReward(RewardData.BONUS, RewardName.TimeReward, config.playerFreechipevery);// 时间
		}
		
		public function get tableLimit():Number
		{
			return _tableLimit;
		}
		
		public function get enterHighLimits():Boolean
		{
			return _enterHighLimits;
		}
		
		public function get freeChipsEvery():Number
		{
			return _freeChipsEvery;
		}
		
		public function get purchaseBonus():Number
		{
			return _purchaseBonus;
		}
		
		/**
		 * 和 LoyaltyLevelDefined 统一
		 */
		public function get levelName():String
		{
			return _levelName;
		}
		
		private function processTableLimit():void
		{
			_loyaltyPoint == LoyaltyLevelPoint.BasicLoyaltyPoint?				
				_tableLimit = 2:_loyaltyPoint == LoyaltyLevelPoint.GoldLoyaltyPoint?
				_tableLimit = 3:_loyaltyPoint == LoyaltyLevelPoint.PlatinumLoyaltyPoint?
				_tableLimit = 4:_loyaltyPoint == LoyaltyLevelPoint.DiamondLoyaltyPoint?
				_tableLimit = 5:_tableLimit = 6;
			trace("_tableLimit", _tableLimit )
		}
		
		
		//		public function get maxRouletteBet():int
		//		{
		//			return _maxRouletteBet;
		//		}
		//		
		//		private function processReward(type:String, name:String, value:Number):void
		//		{
		//			var data:RewardData = new RewardData(type, name, value)
		//			switch(data.name) 
		//			{
		//				case RewardName.DailyReward:
		//					_dailyBonus = data.value;
		//					break;
		//				case RewardName.MaxBetReward:
		//					_maxBet= data.value;
		//					break;
		//				case RewardName.RouletteBet:
		//					_maxRouletteBet = data.value;
		//					return;
		//					break;
		//				case RewardName.tablehandsReward:
		//					_tableHands = data.value
		//					break;
		//				case RewardName.tableLimitsReward:
		//					_tableLimits = data.value
		//					break;
		//				case RewardName.TimeReward:
		//					_timeBonus= data.value
		//					break;
		//			}
		//			_rewardList.push(data)
		//		}
		//		
		public function get level():uint 
		{
			return _level;
		}
		
		public function get rewardList():Array 
		{
			return _rewardList;
		}
		
		//		public function get maxBet():uint 
		//		{
		//			return _maxBet;
		//		}
		
		public function get timeBonus():uint 
		{
			return _timeBonus;
		}
		
		//		public function get dailyBonus():uint 
		//		{
		//			return _dailyBonus;
		//		}
		//		
		//		public function get tableLimits():uint 
		//		{
		//			return _tableLimits;
		//		}
		//		
		//		public function get tableHands():uint 
		//		{
		//			return _tableHands;
		//		}
	}
	
}