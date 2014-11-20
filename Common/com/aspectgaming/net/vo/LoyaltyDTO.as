package com.aspectgaming.net.vo
{
	import com.aspectgaming.constant.global.LoyaltyLevelDefined;
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.LoyaltyDTO")]
	public class LoyaltyDTO
	{
		public var playerId:Number;							//用户id
		public var pointLevelName:String;					//用户当前达到的等级名称(进度条左卡)
		public var pointNextLevelName:String;				//下一等级名称(进度条右卡)
		public var point:Number;							//当前用户荣誉积分点
		public var pointLimitScore:Number;					//max points
		public var pointBaseScore:Number;					//min points
		public var playerLevel:String; 						//用户当前享受权利的等级
		public var playerNextLevel:String;
		public var message:String;							//是否升级消息(如果升级提示： [BasciLoyalty]upto[GlodLoyalty],如果降级提示： [GlodLoyalty]downto[BasciLoyalty])
		public var playerTablelimit:Number;
		public var playerFreechipevery:Number;
		public var playerPurchaseBonus:Number;
		public var seconds:Number; 							//过期时间
		public var startTime:String;
		public var endTime:String;
		public var showTutorial:Boolean;					
		
		//以下前台定义
		public var tierUp:int;								//升降级标识。1-升级；0-不升不降；-1降级
		public var days:int;								//seconds换算天数
		public var hours:int;								//seconds换算小时
		

		/**
		 *
		 */
		public function LoyaltyDTO()
		{
			playerLevel = LoyaltyLevelDefined.BasicLoyalty;
		}
	}
}
