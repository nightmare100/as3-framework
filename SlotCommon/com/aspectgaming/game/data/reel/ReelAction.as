package com.aspectgaming.game.data.reel
{
	import com.aspectgaming.game.component.reels.IReel;

	/**
	 * 轮子特殊指令 
	 * @author Nightmare
	 * 
	 */	
	public class ReelAction
	{
		/**
		 * 第几个轮子 
		 */		
		public var reelIndex:uint;
		
		/**
		 * 特殊指令 
		 */		
		public var action:String;
		
		/**
		 * 特殊指令参数 
		 */		
		public var actionParm:*;
		
		/**
		 * 消息层文字 
		 */		
		public var actionMsg:String;
		
		public var reel:IReel;

	}
}