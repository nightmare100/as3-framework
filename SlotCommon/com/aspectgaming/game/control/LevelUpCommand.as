package com.aspectgaming.game.control
{
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.game.manager.GameManager;
	
	import org.robotlegs.mvcs.Command;
	
	public class LevelUpCommand extends Command
	{
		[Inject]
		public var evt:GameEvent;
		
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var gameInfo:GameInfo;
		
		override public function execute():void
		{
			var level:uint = evt.data.level;
			if (!gameInfo.isVip)
			{
				gameMgr.betCashEachLineMax = level;
			}
		}
		
	}
}