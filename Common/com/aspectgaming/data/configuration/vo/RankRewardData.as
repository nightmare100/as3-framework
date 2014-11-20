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
	public class RankRewardData 
	{

		private var _level:uint;
		private var _timeReward:Number
		private var _tablelimits:Number 
		private var _maxBet:Number
		private var _dailyReward:Number
		private var _maxRouletteBet:Number
		private var _tablehands:int
		
		/**
		 * 传入 level对应信息 当前 只是 荣誉积分点  和 level名字 
		 * @param config
		 * @param levelName
		 * 
		 */			
		public function RankRewardData(config:Object):void//levelPoint:Number, levelName:String = null):void //config : LevelConfigDTO, =》 loyaltyDTO?
		{
			/*
				timeReward 245000
			tablelimits 6
			maxBet 95
			level 95
			dailyReward 8200000
			maxRouletteBet 50000
			tablehands 5
			
			*/
			_level = config.level;
			_timeReward = NumberUtil.centToDollar(config.timeReward);			
			_tablelimits = config.tablelimits;
			_maxBet = config.maxBet; 
			_dailyReward = config.dailyReward;
			_maxRouletteBet =config.maxRouletteBet //NumberUtil.centToDollar(config.tableLimit); // 传入分数
			_tablehands = config.tablehands
			
		}
		
		public function get level():uint 
		{
			return _level;
		}
		
		public function get timeReward():Number 
		{
			return _timeReward;
		}
		
		public function get tablelimits():Number 
		{
			return _tablelimits;
		}
		
		public function get maxBet():Number 
		{
			return _maxBet;
		}
		
		public function get dailyReward():Number 
		{
			return _dailyReward;
		}
		
		public function get maxRouletteBet():Number 
		{
			return _maxRouletteBet;
		}
		
		public function get tablehands():int 
		{
			return _tablehands;
		}
		

	}
	
}