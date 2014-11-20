package com.aspectgaming.game.net
{
	/**
	 * SlotAmf命令 
	 * @author mason.li
	 * 
	 */	
	public class SlotAmfCommand
	{
		public static const CMD_LOBBY_REGISTER:String = "registerPlayer";
		
		//================================================
		
		public static const CMD_BONUS_GAME_OUTRO:String = "slotBonusGameOutro";
		
		public static const CMD_BONUS_GAME_SLELECT:String = "slotBonusGameSelect";
		
		/**
		 * 进入FreeGame 
		 */		
		public static const CMD_FREEGAME_INTRO:String = "slotFreeGameIntro";
		
		/**
		 * 退出FreeGame 
		 */		
		public static const CMD_FREEGAME_OUTRO:String = "slotFreeGameOutro";
		
		/**
		 * FreeGame Play 
		 */		
		public static const CMD_FREEGAME_PLAY:String = "slotFreeGamePlay";
		
		/**
		 * 进入GAMBLE 
		 */		
		public static const CMD_GAMBLE_GAME:String = "slotGambleGame";
		
		/**
		 * 选择GAMBLE  
		 */		
		public static const CMD_GAMBLE_GAMESELETE:String = "slotGambleGameSelect";
		
		/**
		 * TAKE WIN 
		 */		
		public static const CMD_GAME_END:String = "slotGameEnd";
		
		/**
		 * 普通游戏Play 
		 */		
		public static const CMD_GAME_PLAY:String = "slotGamePlay";
		
		/**
		 * FREE SPIN PLAY 
		 */		
		public static const CMD_GAME_FREESPIN_PLAY:String = "slotGameFreeSpinPlay";
		
		/**
		 * Progress的TAKWIN
		 */		
		public static const CMD_GAME_PROGRESSIVE_END:String = "slotGameProgressiveEnd";
		
		/**
		 * 注册游戏 
		 */		
		public static const CMD_SLOTGAME_REGISTER:String = "slotGameRegister";
		
		/**
		 * 注册游戏 For Online
		 */		
		public static const CMD_SLOTGAME_REGISTER_FOR_ONLINE:String = "slotGameRegisterForOnlineGame";
		
		/**
		 * FREESPIN 注册游戏 
		 */		
		public static const CMD_SLOTFREESPIN_REGISTER:String = "slotGameFreeSpinRegister";
		
		/**
		 * 刷新BALANCE 
		 */		
		public static const CMD_FRESHBALANCE:String = "slotGameRefreshBalance";
		
		/**
		 * POWER PLAY调用 
		 */		
		public static const CMD_POWER_PLAY:String = "slotGameFreeGamePowerPlay";
		
		/**
		 * 使用道具
		 */
		public static const CMD_POWER_SPIN:String = "slotGamePlayByInventory";
	}
}