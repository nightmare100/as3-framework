package com.aspectgaming.game.net.vo.dto
{
	
	/**
	 *
	 * @author admin
	 */
	[RemoteClass(alias="com.aspectgaming.facebook.gameserver.web.facade.msg.SlotGameBonusDTO")]
	public class SlotGameBonusDTO
	{
				public var maxSelectableBonus:int;
		public var pickTypes:Array;//element Type is String
		public var pickValues:Array;//element Type is int
		public var pickedSymMask:int;
		public var totalBonusPickWin:int;
		public var bonusPickMultiplier:int;
		public var pickOrder:Array;//element Type is int

		/**
		 *
		 */
		public function SlotGameBonusDTO()
		{
		}
	}
}
