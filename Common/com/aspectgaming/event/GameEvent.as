package com.aspectgaming.event 
{
	import com.aspectgaming.event.base.BaseEvent;
	
	import flash.events.Event;
	
	/**
	 * 存放游戏公共事件 
	 * 游戏个别事件 请迁移至游戏本体
	 * @author Evan.Chen
	 */
	public class GameEvent extends BaseEvent
	{
		
		public static const LOADING_MODULE_COMPLETED:String = "LOADING_MODULE_COMPLETED";
		public static const GAMBLE_MODULE_COMPLETED:String = "GAMBLE_MODULE_COMPLETED";
		public static const MAIN_MODULE_COMPLETED:String = "MAIN_MODULE_COMPLETED";
		public static const ASSETS_LOADER_C0MPLETED:String = "ASSETS_LOADER_C0MPLETED";
		public static const ASSETS_LOADER_UPDATE:String="ASSETS_LOADER_UPDATE";
		
		/**
		 * 游戏初始化开始 
		 */		
		public static const GAME_INITIALIZE:String = "GAME_INITIALIZE";
		public static const REGISTER_SERVICE:String="REGISTER_SERVICE";
		public static const ASSETS_LOADER_STARTUP:String = "ASSETS_LOADER_STARTUP";
		
		/**
		 * 注册大厅事件侦听 
		 */		
		public static const REGISTER_LOBBY_COMMAND:String = "REGISTER_LOBBY_COMMAND";
		
		/**
		 * 创建游戏
		 */		
		public static const GAME_CREATED_COMMAND:String = "GAME_CREATED_COMMAND";
		
		/**
		 * 创建游戏结束
		 */		
		public static const GAME_CREATED_COMPLETE:String = "GAME_CREATED_COMPLETE";
		
		/**
		 * 游戏初始化完成 
		 */		
		public static const GAME_INITIALIZE_COMPLETED:String = "GAME_INITIALIZE_COMPLETED";
		
		/**
		 * 游戏UI自定义创建命令 
		 */		
		public static const GAME_BEFORE_CREATE_UI:String = "GAME_BEFORE_CREATE_UI";
		
		/**
		 * 游戏初始化自定义命令 
		 */		
		public static const GAME_CUSTOM_INIT:String = "GAME_CUSTOM_INIT";
		
		/**
		 * 游戏重启 
		 */		
		public static const GAME_RESTART:String = "GAME_RESTART";
		
		//===========================大厅 to 游戏 事件==============================================
		
		/**
		 * 升级 
		 */		
		public static const GAME_LEVEL_UP:String 		= "GAME_LEVEL_UP";
		
		/**
		 * 弹遮罩面板 
		 */		
		public static const GAME_WIN_POPUP:String 		= "GAME_WIN_POPUP";
		
		/**
		 * balance更新 
		 */		
		public static const GAME_UPDATE_BALANCE:String 	= "GAME_UPDATE_BALANCE";
		
		/**
		 * 重新注册游戏 
		 */		
		public static const GAME_CONTINUE:String 		= "GAME_CONTINUE";
		
		/**
		 * 关闭窗口 
		 */		
		public static const GAME_POPUP_END:String		= "GAME_POPUP_END";
		
		/**
		 * 大厅LOADING 条子走完 
		 */		
		public static const GAME_LOADINGBAR_TO_END:String		= "GAME_LOADINGBAR_TO_END";
		
		/**
		 * 声音
		 */		
		public static const GAME_MUTE:String 		= "GAME_MUTE";
		
		/**
		 * 使用道具 
		 */		
		public static const PROP_USED:String 		= "PROP_USED";

		public function GameEvent ( type:String, data:* = null, content:String = null )
		{
			super(type, data, content);
		}
		
		public override function clone ( ):Event
		{
			return new GameEvent(type, _data, _content);
		}
		
	}
	
}