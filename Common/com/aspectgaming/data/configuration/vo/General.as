package com.aspectgaming.data.configuration.vo 
{
	import com.aspectgaming.utils.NumberUtil;

	public class General 
	{
		public var defautLanguage:String;
		public var myCasinoLabel:String = "My\rCasino";

		public var giftAmount:int;				//gift-coin amount
		public var spinAmount:int;				//slot gift-freespin amount
		public var handAmount:int;				//BJ gift-freehand amount
		public var kenoAmount:int;				//keno gift
		
		public var balanceLimit:int;
		public var freePopNum:int;
		public var freePopAmount:Number = 0;
		public var bigWinTimes:int;
		public var highLimit:int;
		public var likeReward:Number = 0;
		public var scrollMsgUpdateTime:Number;
		public var scrollMsgDisplayTime:Number;
		
		/**
		 * FcaeBook认证错误页面地址 
		 */		
		public var fanPage:String;
		
		/**
		 * ChipsIndex 
		 */		
		public var chipProIndex:int;
		
		/**
		 * DragonDollarsIndex 
		 */		
		public var dragonDollarsProIndex:int;
		
		public var gameWaitTime:uint;
		
		public var hasNewUserPrice:Boolean;
		
		public var touramentDelay:Number;
		
		private var _tournamentCost:Object;
		public function set tournamentChips(value:Object):void
		{
			for (var key:String in value)
			{
				value[key] = NumberUtil.centToDollar(value[key]);
			}
			_tournamentCost = value;
		}
		/**
		 * 服务器 宏定义数值 
		 * @param xml
		 * 
		 */		
		public function General(xml:XMLList) 
		{
			defautLanguage = xml.defautLanguage;
			gameWaitTime = uint(xml.gameWaitTime.@time);
			hasNewUserPrice = Boolean(uint(xml.newUserPrice.@enabled));
			touramentDelay = Number(xml.tournamentBonusTick.@value);
			
			/*giftAmount = xml.giftAmount;
			spinAmount = xml.spinAmount;
			handAmount = xml.handAmount;
			freePopNum = xml.freePopNum;
			freePopAmount = xml.freePopAmount;
			bigWinTimes = xml.bigWinTimes;
			highLimit = xml.highLimit;
			balanceLimit = xml.balanceLimit;*/
			
			fanPage = xml.fanPage;
			
			scrollMsgUpdateTime = Number(xml.scrollMessage.@updateTime);
			scrollMsgDisplayTime = Number(xml.scrollMessage.@displayTime);
		}
		
		public function getTournamentCost(lv:String):Number
		{
			return _tournamentCost[lv];
		}
		
	}
}