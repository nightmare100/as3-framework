package com.aspectgaming.game.constant
{
	
	/**
	 * 游戏状态定义 
	 * @author mason.li
	 * 
	 */	
	public class GameStatue
	{
		public static const GAMBLE:String 				= "Gamble";
		
		public static const GAMBLE_OR_TAKEWIN:String 	= "GambleOrTake";
		
		public static const GAMBLE_PENDING:String 		= "GamblePending";
		
		public static const BONUS_OUTRO:String 			= "BonusOutro";
		
		public static const BONUS_PICK:String 			= "BonusPick";
		
		public static const BONUS_GAME:String 			= "BonusGame";
		
		public static const PROGRESSIVE:String 			= "Progressive";	
		
		public static const GAMEIDLE:String 			= "GameIdle";
		
		public static const FREEGAME:String 			= "FreeGame";
		
		public static const FREE_GAME_OUTRO:String 		= "FreeGameOutro";
		
		public static const FREE_GAME_INTRO:String 		= "FreeGameIntro";
		
		public static const POWER_SPIN:String			= "PowerSpin";
		
		/**
		 * Online专有状态 意思貌似为 钱不够 
		 */		
		public static const INTERAL_WALLET:String		= "InteralWallet";
	}
}