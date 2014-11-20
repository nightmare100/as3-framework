package com.aspectgaming.net.vo
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.LevelConfigDTO")]
	public class LevelConfigDTO
	{
		public var dailyReward:Number;
		public var timeReward:Number;
		public var maxBet:int;
		public var maxRouletteBet:int;
		public var tablehands:int;
		public var tablelimits:int;
		public var level:int;

		/**
		 *
		 */
		public function LevelConfigDTO()
		{
		}
	}
}
