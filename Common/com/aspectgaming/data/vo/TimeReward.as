package com.aspectgaming.data.vo 
{
	import com.aspectgaming.utils.constant.TickConstant;
	import com.aspectgaming.utils.tick.Tick;
	
	public class TimeReward 
	{
		public static const DELAY_TIME:uint = 10;
		
		public var rewardAmount:Number = 0;
		private var _remainTime:int;
		
		public function TimeReward() 
		{
			
		}
		
		public function get remainTime():int
		{
			return Tick.getTimeLeft(TickConstant.TIME_REWARD_COLLECT);
		}

		public function set remainTime(value:int):void
		{
			if (value >= 0) // loyalty 更新 playerinfo -》 rewardlefttime 赋值直接变0
			{
				_remainTime = value;
				Tick.addTimeout(null, _remainTime, TickConstant.TIME_REWARD_COLLECT);
			}
		}

	}

}