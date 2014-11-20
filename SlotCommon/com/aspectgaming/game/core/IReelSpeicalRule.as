package com.aspectgaming.game.core
{
	import com.aspectgaming.game.data.reel.ReelAction;

	/**
	 * 轮子滚动 特殊效果 规则 
	 * @author Nightmare
	 * 
	 */	
	public interface IReelSpeicalRule
	{
		function getSpeical(stops:Array):Vector.<ReelAction>;
	}
}