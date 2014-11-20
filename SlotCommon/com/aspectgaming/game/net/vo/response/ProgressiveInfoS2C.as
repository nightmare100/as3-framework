package com.aspectgaming.game.net.vo.response
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.slotgame.ProgressiveInfoS2C")]
	public class ProgressiveInfoS2C
	{
		public var msgId:String;
		public var progressiveLevelDTOs:Array;//element Type is ProgressiveLevelDTO
		public var result:String;

		/**
		 *
		 */
		public function ProgressiveInfoS2C()
		{
		}
	}
}
