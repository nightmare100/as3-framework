package com.aspectgaming.constant.global 
{
	/**
	 * Loyalty 等级字符串定义，和后台定义保持一致...
	 * @author 
	 */
	public class LoyaltyLevelDefined 
	{
		public static const BasicLoyalty:String = "BasicLoyalty";
		public static const GoldLoyalty:String = "GoldLoyalty";
		public static const PlatinumLoyalty:String = "PlatinumLoyalty";
		public static const DiamondLoyalty:String = "DiamondLoyalty";
		public static const VipLoyalty:String = "VipLoyalty";
		
		
		public static function getDisplayLevelName(level:String):String
		{
			if (level == LoyaltyLevelDefined.BasicLoyalty) {
				return 	"Basic"
			}else if (level == LoyaltyLevelDefined.GoldLoyalty) {
				return "Gold"
			}else if (level == LoyaltyLevelDefined.PlatinumLoyalty) {
				return "Platinum"
			}else if (level == LoyaltyLevelDefined.DiamondLoyalty) {
				return "Diamond"
			}else if (level == LoyaltyLevelDefined.VipLoyalty) {
				return "Black"
			}
			
			return null;
		}
		
		
	}

}