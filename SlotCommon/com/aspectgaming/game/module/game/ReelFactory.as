package com.aspectgaming.game.module.game
{
	import com.aspectgaming.game.component.reels.HorizontalReel;
	import com.aspectgaming.game.component.reels.IReel;
	import com.aspectgaming.game.component.reels.VerticalReel;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.reel.ReelInfo;
	import com.aspectgaming.game.constant.RollDirectionDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.ui.iface.IAssetLibrary;
	
	/**
	 * 轮子工厂 
	 * @author mason.li
	 * 
	 */	
	public class ReelFactory
	{
		public static function createReel(info:ReelInfo):IReel
		{
			var ireelObject:IReel;
			switch (info.direction)
			{
				case RollDirectionDefined.ROLL_LEFT_TO_RIGHT:
				case RollDirectionDefined.ROLL_RIGHT_TO_LEFT:
					ireelObject = new HorizontalReel(GameAssetLibrary.symbolLibrary);
					break;
				case RollDirectionDefined.ROLL_BOTTOM_TO_TOP:
				case RollDirectionDefined.ROLL_TOP_TO_BOTTOM:
				default:
					ireelObject = new VerticalReel(GameAssetLibrary.symbolLibrary); 
					break;
			}
			if (ireelObject)
			{
				ireelObject.rollDirection = info.direction;
				ireelObject.setup(info, GameSetting.getSpeedInfo(GameSetting.speedLv));
			}
			return ireelObject;
		}
	}
}