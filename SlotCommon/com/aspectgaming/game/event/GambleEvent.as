package com.aspectgaming.game.event
{
	import com.aspectgaming.event.base.BaseEvent;
	
	import flash.events.Event;
	
	/**
	 * Gamble相关事件 
	 * @author mason.li
	 * 
	 */	
	public class GambleEvent extends BaseEvent
	{
		/**
		 * 更新gamble开始 
		 */		
		public static const GAMBLE_START:String = "gamble_start";
		
		/**
		 * 更新gamble界面 
		 */		
		public static const GAMBLE_UPDATE:String = "gamble_update";
		
		/**
		 * gamble选择
		 */		
		public static const GAMBLE_SELECT:String = "gamble_select";
		
		/**
		 * gamble 点击  takeWin
		 */		
		public static const GAMBLE_TAKEWIN:String = "gamble_takewin";
		
		/**
		 * gamble lost 或者 gamble pending
		 */		
		public static const GAMBLE_END:String = "gamble_end";
		
		/**
		 * gamble lost 或者 gamble pending
		 */		
		public static const GAMBLE_WIN_METER:String = "gamble_win_meter";
		
		public function GambleEvent(type:String, data:*=null, content:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
		}
		override public function clone():Event
		{
			return new SlotEvent(type, data, content, bubbles, cancelable);
		}
	}
}