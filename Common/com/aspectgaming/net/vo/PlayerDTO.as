package com.aspectgaming.net.vo
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.PlayerDTO")]
	public class PlayerDTO
	{
		public var playerId:Number;
		public var userName:String;
		public var membershipPoints:Number;
		public var level:int;
		public var totalAmount:Number;
		public var rewardLeftTime:Number;
		public var timeRewardCount:Number;// loyalty 系统不用
		public var accountType:int;
		public var hasLiked:Boolean;
		public var unsuberibeLike:Boolean;
		public var levelInfoDTO:LevelInfoDTO;
		public var hasNewUser:Boolean;
		public var dragonDollars:Number;
		public var unlockGameIds:Array;				//element Type is Integer
		public var lockGameIds:Array;				//element Type is Integer
		public var playGameIds:Array;				//element Type is Integer
		public var unPlayGameIds:Array;				//element Type is Integer
		public var defaultUnlockGameIds:Array;		//element Type is Integer
		public var slotCustomizedDTO:SlotCustomizedDTO;
		public var inventoryMap:Object;
		public var tutorialCompleted:Boolean;		//jackpot教程是否完成
		public var slotTournamentCompleted:Boolean;	//tournament教程是否完成
		public var severalLoginCount:int;			//bonus for continuous login
		public var hasLevelModule:Boolean;
		public var unlockGameIdsByDollars:Array;	//龙币解锁的游戏
	
		public var groups:int;
		
		/**
		 * true则进入新手引导界面
		 */		
		public var showTutorial:Boolean;
		/**
		 *
		 */
		public function PlayerDTO()
		{
		}
	}
}
