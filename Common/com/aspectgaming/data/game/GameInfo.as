package com.aspectgaming.data.game 
{
	import com.aspectgaming.data.vo.SlotCustomized;
	/**
	 * 新游戏信息 for all game
	 * @author Evan.Chen
	 */
	public dynamic class GameInfo
	{
		public var gameServer:String;
		
		public var gameAssetsPath:String;
		
		public var gameName:String;
		
		public var gameID:int;				//按用户当前等级进入的game的id
		
		public var operator:String;
		
		public var level:String;
		
		public var playerID:String;
		
		public var sig:String;
		
		public var sessionKey:String;
		
		public var lang:String;
		
		public var isFreeSpin:Boolean;
		
		public var freeHandID:int;			//免费游戏进入的game id
		
		public var freespinCount:uint;
		
		public var isVip:Boolean;
		
		public var range:String;
		
		public var currency:String;
		
		public var currencySymbol:String;
		
		public var waitTime:uint;
		
		public var clientSource:String;
		
		public var customizedData:SlotCustomized;
		
		public var hasLevelModule:Boolean;
		
		public var isCarmerEnabled:Boolean;
	}
}