package com.aspectgaming.game.event
{
	import com.aspectgaming.event.base.BaseEvent;
	
	import flash.events.Event;
	
	/**
	 * SlotUi事件 
	 * @author mason.li
	 * 
	 */	
	public class SlotUIEvent extends BaseEvent
	{
		/**
		 * 下注线变更 
		 */		
		public static const BET_LINE_CHANGED:String = "betLineChanged";
		
		/**
		 * 下注每根线的钱变更 
		 */		
		public static const BET_CASH_CHANGED:String = "betCashChanged";
		
		public static const BET_CASH_MAX_CHANGED:String = "betCashMaxChanged";
		
		public static const AUTO_PLAY_CHANGED:String = "autoPlayChanged";
		
		public static const AUTO_IN_CHOOSE:String = "autoInChoose";
		
		public static const SHOW_HELP:String = "showHelp";
		
		public static const SHOW_GAMBLE:String = "showGamble";
		
		/**
		 * 显示作弊
		 */
		public static const SHOW_SIMULATOR:String = "show_simulator";
		
		/**
		 * winshow线条已播放一个轮回 
		 */		
		public static const WIN_SHOW_END:String = "winShowEnd";
		
		/**
		 * 每条押中的线的winshow开始播放
		 */
		public static const SINGLE_WINSHOW_START:String = "singleWinshowStart";
		
		public function SlotUIEvent(type:String, data:*=null, content:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new SlotUIEvent(type, data, content, bubbles, cancelable);
		}
		

		
	}
}