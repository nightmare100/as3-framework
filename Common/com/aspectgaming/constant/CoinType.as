package com.aspectgaming.constant
{
	/**
	 * 货币类型 
	 * @author mason.li
	 * 
	 */	
	public class CoinType
	{
		/**
		 * 游戏币 
		 */		
		public static const GAMECOIN:String = "gamecoin";
		
		/**
		 *   龙币
		 */
		public static const DRAGON:String = "charms";
		/**
		 *捆绑销售 
		 */		
		//public static const BUNDLESALE:String = "Bundle";
		
		
		public static function hackType(type:String):String
		{
			if (type == "normal")
			{
				type = CoinType.GAMECOIN;
			}

			return type;
		}
	}
}