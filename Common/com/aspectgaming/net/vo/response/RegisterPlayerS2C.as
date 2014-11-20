package com.aspectgaming.net.vo.response
{
	import com.aspectgaming.net.vo.LoyaltyDTO;
	import com.aspectgaming.net.vo.PlayerDTO;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.lobby.RegisterPlayerS2C")]
	public class RegisterPlayerS2C
	{
		public var msgId:String;
		public var retCode:int;
		public var player:PlayerDTO;
		public var loyalty:LoyaltyDTO;
		public var leaderBoardDate:Date;
		public var result:String;
		public var aspectUid:String;
		public var timelineBonus:Number;
		public var timelineId:String;
		public var severalLoginReward:Number;
		//public var pupLoyalty:Boolean;				//是否显示Loyalty Welcome
		
		public var chipsLeaderRank:int;
		public var winningsLeaderRank:int;

		

		public var alertBonusTime:Number;	
		public var missions:Array;//element Type is MissionDTO

		
		
		
		/**
		 *
		 */
		public function RegisterPlayerS2C()
		{
		}
	}
}
