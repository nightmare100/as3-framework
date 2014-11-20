package com.aspectgaming.game.utils
{
	
	/**
	 * Slot Object 信息包装类 
	 * @author mason.li
	 * 
	 */	
	public class SlotInfoUtil
	{
		public static function getBigWinInfo(win:Number, bet:Number):Object
		{
			var obj:Object = {};
			obj.win = win;
			obj.bet = bet;
			return obj;
		}
		
		public static function getFreeGameInfo(gameName:String, count:Number, win:Number):Object
		{
			var obj:Object = {};
			obj.gamename		= gameName;
			obj.freespincount	= count;
			obj.freespinwin		= win;
			
			return obj;
		}
		
		public static function getUpdateBalanceInfo(balance:Number, dragon:Number):Object
		{
			var obj:Object = {};
			obj.cash		= balance;
			obj.dragon		= dragon;
			
			return obj;
		}
	}
}