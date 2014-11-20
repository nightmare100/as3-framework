package com.aspectgaming.data.vo 
{
	
	public class TotalBalance 
	{
		public var prevTotalBalance:Number = 900000000;
		
		public var responseCode:Boolean;
		public var currencyCode:String;
		
		/**
		 * Balance 
		 */		
		private var _totalBalance:Number=0;
		
		/**
		 * 龙币 
		 */		
		private var _dragonDollars:Number = 0;
		
		public function get dragonDollars():Number
		{
			return _dragonDollars;
		}
		
		public function set dragonDollars(value:Number):void
		{

			_dragonDollars = value;
		}
		
		
		
		public function TotalBalance() 
		{
			
		}

		public function get totalBalance():Number
		{
			return _totalBalance;
		}

		public function set totalBalance(value:Number):void
		{
			prevTotalBalance = _totalBalance;
			_totalBalance = value;
		}
		
		public function get rewardAmount():Number
		{
			return totalBalance - prevTotalBalance;
		}

		public function get addBalance():Number
		{
			return _totalBalance - prevTotalBalance;
		}

	}

}