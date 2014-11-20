package com.aspectgaming.data.vo
{
	public class InviteBonus
	{
		public var rewardNum:Number;
		public var rewardCount:int;
		public var allSendUser:int;
		
		public function InviteBonus(n:Number, count:int, allInvited:int)
		{
			rewardNum = n;
			rewardCount = count;
			allSendUser = allInvited;
		}
		
		public function get totalAmout():Number
		{
			return rewardNum * rewardCount;
		}
	}
}