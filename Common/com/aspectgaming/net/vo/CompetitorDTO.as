package com.aspectgaming.net.vo
{
	
	/**
	 *
	 * @author zy
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.CompetitorDTO")]
	public class CompetitorDTO
	{
		public var playerId:Number;
		public var firstName:String;
		public var lastName:String;
		/**游戏里TOTAL WIN*/
		public var points:Number;		//游戏里TOTAL WIN
		/** 排名*/
		public var rank:int;
		/** 点击play 刷新tournament 排名*/
		public var currentRank : int;
		public var totalWinAmount:Number;		//结束后分配的奖金
		public var leftTime:Number;
		public var getAchievement:Array;	//爆竹奖励 如果有值的话 0索引 为名称  1索引 为奖励金额
		public var times:int;			//参加的轮次
		public var playGameCount:int;	//点击的次数
		public var stops:String;
		public var winLineInfo:Array;//element Type is String
		public var rewardBonusHistory:Array;//element Type is Long		
		public var mathSpecificParams:Object;
		public var ruling:Number;
		
		public function CompetitorDTO()
		{
		}
	}
}
