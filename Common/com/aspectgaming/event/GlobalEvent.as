package com.aspectgaming.event
{
	import flash.events.Event;
	
	/**
	 * 全局事件 
	 * @author mason.li
	 * 
	 */	
	public class GlobalEvent extends Event
	{
		
		/**
		 * 注册AMF 映射类 
		 */		
		public static const REGISTER_AMF_CLASS:String = "registerAmfClass";
		
		/**
		 * 加载资源 
		 */		
		public static const LOAD_ASSETS:String = "loadAssets";		
		
		/**
		 * 添加版本信息 
		 */		
		public static const ADD_VERINFO:String = "addVersionInfo";	
		
		/**
		 * LeaderBoard 奖励检测 
		 */		
		public static const CHECK_LEADERBOARD_BONUS:String = "checkLeaderBoardBonus";
		
		/**
		 * 注册JS 
		 */		
		public static const JS_REGISTER:String = "jsRegister";
		
		/**
		 * 音量开关控制 
		 */		
		public static const SOUND_CONTROL_CHANGED:String = "soundControlChanged";
		
		/**
		 * 自动照相开关控制 
		 */		
		public static const CARMER_CONTROL_CHANGED:String = "carmerControlChanged";
		
		/**
		 * 游戏作弊 
		 */		
		public static const EMNULATOR_PLAY:String = "emnulatorPlay";
		
		
		/** tournament slot leaderboard event 
		 * add by zy
		 * leaderBoard to lobby 事件
		 * */
		public static const TOURNAMENT_LEADERBOARD_EVENT:String = "tournamentLeadBoardEvent";
		/** 刷新leaderboard*/
		public static const UPDATE_LEADBOARD:String = "updateLeadBoard";
		/**点击play刷新tournament排名*/
		public static const REFRESH_RANK:String = "refreshRank";
		
		public static const CHANGE_TOURNAMENT_LEVEL:String = "changeTournamentLevel";
		
		private var  _str:String;
		private var  _value:String;
		private var  _obj:Object;	//loading_update {filename:string,count:int}
		
		public var callback:Function;

		public function GlobalEvent(type:String, str:String = null, value:String = null, obj:Object = null)
		{ 
			super(type);
			_str = str;
			_value = value;
			_obj = obj;
		} 
		
		public function get obj():Object
		{
			return _obj;
		}

		public function set obj(value:Object):void
		{
			_obj = value;
		}

		public function get value():String
		{
			return _value;
		}

		public function get str():String
		{
			return _str;
		}

		public override function clone():Event 
		{ 
			return new GlobalEvent(type, _str, _value, _obj);
		} 
		
		public override function toString():String 
		{ 
			//return formatToString("AGEvent", "type", "bubbles", "cancelable", "eventPhase", "_str", "_value", "_obj");
			return formatToString("AGEvent", "type", "_str", "_value", "_obj");
		}
	}

}