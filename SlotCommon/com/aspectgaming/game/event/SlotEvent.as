package com.aspectgaming.game.event
{
	import com.aspectgaming.event.base.BaseEvent;
	
	import flash.events.Event;
	
	/**
	 * Slot 游戏事件  
	 * @author mason.li
	 * 
	 */	
	public class SlotEvent extends BaseEvent
	{
		/**
		 * 游戏模式变更 
		 */		
		public static const GAME_MODE_CHANGED:String = "gameModeChanged";
		
		/**
		 * PLAY游戏 
		 */		
		public static const GAME_PLAY:String = "gamePlay";
		
		/**
		 * 玩游戏请求回调 
		 */		
		public static const GAME_PLAY_REQUEST_BACK:String = "gamePlayRequestBack";
		
		/**
		 * STOP游戏 
		 */		
		public static const GAME_STOP:String = "gameStop";
		
		/**
		 * 显示消息 
		 */		
		public static const SHOW_MESSAGE:String = "showMessage";
		
		/**
		 * 自动游戏模式切换 
		 */		
		public static const GAME_AUTO_MODE_CHANGED:String = "gameAutoModeChanged";
		
		/**
		 * 显示全局动画 
		 */		
		public static const SHOW_GLOBAL_ANIMATION:String = "showGlobalAnimation";
		
		/**
		 * GAMBLE GAME 
		 */		
		public static const GAMBLE_GAME:String = "gamble_game";
		/**
		 * GAMBLE GAME CALL BACK
		 */		
		public static const GAMBLE_GAME_REQUEST_BACK:String = "gamble_gameRequestBack";
		
		public static const GAME_UPDATE_BALANCE:String = "gameUpdateBalance";
		
		/**
		 * 登陆完成后检测游戏状态 
		 */		
		public static const GAME_CHECK_STATUE:String = "gameCheckStatue";
		
		/**
		 * 新手引导自定义游戏 
		 */		
		public static const GUILD_PLAY:String = "guildPlay";
		
		public static const GUILD_START:String = "guildStart";
		
		public var m_boolValue:Boolean;
		
		public function SlotEvent(type:String, data:*=null, content:String=null, boolValue:Boolean = false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
			m_boolValue = boolValue;
		}
		
		override public function clone():Event
		{
			return new SlotEvent(type, data, content, bubbles, cancelable);
		}
		
		
	}
}