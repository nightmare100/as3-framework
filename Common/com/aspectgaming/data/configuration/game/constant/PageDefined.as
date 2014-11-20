package com.aspectgaming.data.configuration.game.constant
{
	/**
	 * 页面名称定义 
	 * @author mason.li
	 * 
	 */	
	public class PageDefined
	{
		
		public static const SINGLE_GAME_PAGE:Array = [Baccarat_Page, BlackJack_Page, Roulette_Page, Keno_Page, MyCasino_Page, Poker_Page];
		
		public static const SINGLE_GAME_PAGE_FACEBOOK:Array = [Keno_Page, MyCasino_Page, Poker_Page];
		
		public static var Lobby_Home:String;
		
		public static const Slots_Page:String = "slots";
		
		public static const MyCasino_Page:String = "MyCasino";
		
		public static const BlackJack_Page:String = "BLACKJACK";
		
		public static const JackPots_Page:String = "jackpots";
		
		public static const HighLimit_Page:String = "highlimit";
		
		public static const Keno_Page:String = "KENO";
		
		public static const Baccarat_Page:String = "BACCARAT";
		
		public static const Roulette_Page:String = "ROULETTE";
		
		public static const Poker_Page:String = "POKER";
		
		public static const Page_Tourament:String = "tourament";
		
		public static const Page_TableGame:String = "tablegame";
		
		/**
		 * back 返回上一页 
		 */		
		public static const Previous_Page:String = "previousPage";
		
		/**
		 * 游戏加载中
		 */		
		public static const Page_GameLoading:String = "PageGameLoading";
		
		/**
		 * 已进入游戏
		 */		
		public static const Page_InGame:String = "PageInGame";
		
		public static const BACCARAT_STANTDER:String = "Baccarat Standard";
		
		
		public static function isSingleGamePage(pagename:String):Boolean
		{
			return SINGLE_GAME_PAGE.indexOf(pagename) != -1;
		}
		
		public static function isSingleGamePageFacebook(pageName:String):Boolean
		{
			return SINGLE_GAME_PAGE_FACEBOOK.indexOf(pageName) != -1;
		}
	}
}