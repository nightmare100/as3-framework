package com.aspectgaming.event
{
	import flash.events.Event;

	/**
	 * 大厅 <=> 游戏 通信 事件 
	 * @author mason.li
	 * 
	 */	
	public class LobbyGameBridgeEvent extends Event
	{
		//加载
		public static const GAME_LOADING_START:String = "LOADING_START";
		public static const GAME_LOADING_ERROR:String = "LOADING_ERROR";
		public static const GAME_LOADING_END:String = "LOADING_END";
		public static const GAME_LOADING_UPDATE:String = "ASSETS_LOADER_UPDATE";
		
		//声音开关
		public static const GAME_MUTE_SOUND_ON:String = "game_mute_off";
		public static const GAME_MUTE_SOUND_OFF:String = "game_mute_on";
		
		/**
		 * 金钱不足 
		 */		
		public static const GAME_NOT_ENOUGH_MOENY:String = "GAME_TO_LOBBY_BUY_CHIPS";
		
		//游戏内
		public static const GAME_FREESPIN_END:String = "freespin_end";
		public static const GAME_FREEGAME_END:String = "freegame_end";
		public static const GAME_BIG_WIN:String = "SLOT_WINNING";
		public static const GAME_UPDATE_BALANCE:String = "GAME_UPDATE_BALANCE";
		
		/**
		 * 拍照 
		 */		
		public static const GAME_MAKE_SCREEN_SNAP:String = "GAME_MAKE_SCREEN_SNAP";
		
		/**
		 * 游戏错误 
		 */		
		public static const GAME_ERROR:String = "error";
		
		/**
		 * keno专用 
		 */		
		public static const GAME_ON_KENO_DATA:String = "GAME_TO_GAME_TO_LOBBY";
		
		/**
		 * 游戏状态变更 (参数为Ture 表示游戏进行中 FALSE 表示游戏闲置) 
		 */		
		public static const GAME_STATUE_CHANGE:String = "GAME_STATUE_CHANGE";
		
		/**
		 * 告知大厅 道具已使用 
		 */		
		public static const ON_PROP_ITEM_USED:String = "onPropItemUsed";
		
		/**
		 * 弹出 定制头像
		 */		
		public static const ON_CUSTOMIZE_REQUEST:String = "onCustomizeRequest";
		
		public static const ON_TOTAL_BET_CHANGED:String = "onTotalBetChanged";
		/**
		 * tournament 游戏返回大厅
		 * add by zy
		 * */
		public static const TOURNAMENT_TO_LOBBY:String = "tournamentToLobby";
		/** tournament 通过lobby 刷新 leadboard 排名*/
		public static const TOURNAMENT_REFRESH_LEADBOARD:String = "refreshLeadBoard";
		/** 点击刷新用户排名*/
		public static const TOURNAMENT_REFRESH_RANK:String = "refreshTournamentRank";
		//============================LOBBY TO GAME=============================
		public static const ON_LOBBY_COMMAND:String = "ON_LOBBY_COMMAND";
		public static const UP_LOAD_SYMBOL:String = "UP_LOAD_SYMBOL";
		

		public var  _str:String;
		public var  _value:String;
		public var  data:Object;	//loading_update {filename:string,count:int}
		
		public function LobbyGameBridgeEvent(type:String, str:String = "", value:String = "0", obj:Object = null)
		{
			super(type);
			_str = str;
			_value = value;
			data = obj;
		}
		public override function clone():Event 
		{ 
			return new LobbyGameBridgeEvent(type, _str, _value, data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AGEvent", "type", "_str", "_value", "data");
		}
	}
}