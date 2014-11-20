package com.aspectgaming.net.vo
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.LevelInfoDTO")]
	public class LevelInfoDTO
	{
		/**
		 * 用户当前经验值 
		 */		
		public var currentMemshipPoint:Number;
		public var currentLevel:int;
		
		/**
		 * 需要升级达到的经验值 
		 */		
		public var levelMemshipPoint:Number;
		
		/**
		 * 下一级的经验值 
		 */		
		public var nextLevelMemshipPoint:Number;
		public var levelUpReward:int;
		
		/**
		 * 最大等级 
		 */		
		public var maxLevel:int;		

		/**
		 *
		 */
		public function LevelInfoDTO()
		{
		}
	}
}
