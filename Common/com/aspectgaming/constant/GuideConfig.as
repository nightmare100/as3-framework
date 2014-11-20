package com.aspectgaming.constant
{

	/**
	 * 新手引导Action定义
	 * @author mason.li
	 *
	 */
	public class GuideConfig
	{
		public static var ACTION_POPUP:String="popup";

		public static var ACTION_CLEAR_MSG:String="clearMsg";

		public static var ACTION_DISPOSE:String="dispose";

		public static var ACTION_PLAYGAME:String="gamePlay";

		public static var ACTION_FREEPLAY:String="freeGamePlay";

		public static var ACTION_SET_BET:String="setBet";

		public static var ACTION_SET_LINE:String="setLine";
		
		public static var ACTION_LOCK_NEWSLOTCELL:String="lockNewSlotCell";
		
		public static var ACTION_UNLOCK_NEWSLOTCELL:String="unlockNewSlotCell";
		
		public static var ACTION_DELAY_NEXT_STEP:String="delay";


		public static const SLOT_GUIDE_GAME_ID:int=73;

		/**
		 * 新手指引从FREEGAME赢得的奖励
		 */
		public static var FRRE_GAME_WIN:int=0;

		/**
		 * welcome
		 */
		static public const STEP_1:int=1;
		/**
		 *  spin
		 */
		static public const STEP_2:int=2;

		/**
		 * slot
		 */
		static public const STEP_3:int=3;

		/**
		 *  collect
		 */
		static public const STEP_4:int=4;

		/**
		 *  unlockGame
		 */
		static public const STEP_5:int=5;

		/**
		 * 在线长满足，附为true
		 */
		static public var STEP_4_DEPEND:Boolean;




	}
}


