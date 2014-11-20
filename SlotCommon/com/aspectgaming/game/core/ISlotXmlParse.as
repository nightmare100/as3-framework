package com.aspectgaming.game.core
{
	import com.aspectgaming.game.config.reel.SpeedInfo;

	public interface ISlotXmlParse
	{
		function init(xml:XML):void;
		function getSpeedInfo(o:*):SpeedInfo;
	}
}