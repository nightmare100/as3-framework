package com.aspectgaming.game.data
{
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.core.ISimulator;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.core.ISpeicalParse;
	import com.aspectgaming.game.data.gamble.GambleInfo;
	import com.aspectgaming.game.manager.GameManager;

	/**
	 * 游戏相关内容静态引用 
	 * @author mason.li
	 * 
	 */	
	public class GameGlobalRef
	{
		/**
		 * 游戏基本信息 
		 */		
		public static var gameInfo:GameInfo;
		
		
		/**
		 * 游戏管理 
		 */		
		public static var gameManager:GameManager;
		
		/**
		 * 游戏数据 
		 */		
		public static var gameData:GameData;
		
		/**
		 * 游戏服务分发器 
		 */		
		public static var gameServer:IServer;
		
		/**
		 * 作弊器 
		 */		
		public static var simulator:ISimulator;
		
		/**
		 * Gamble信息 
		 */		
		public static var gambleInfo:GambleInfo;
		
		/**
		 * Free Game信息 
		 */		
		public static var freeGameInfo:FreeGameModel;
	}
}