package com.aspectgaming.game.control
{
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.utils.NumberUtil;
	
	import org.robotlegs.mvcs.Command;
	
	public class UpdateBalanceCommand extends Command
	{
		[Inject]
		public var gameEvent:GameEvent;
		
		[Inject]
		public var gameData:GameData;
		
		override public function execute():void
		{
			var data:Object = gameEvent.data;
			gameData.totalCent = data.balance;
			gameData.totalDollar = Math.floor(NumberUtil.centToDollar( data.balance ) );
			gameData.dragon =  Math.floor(NumberUtil.centToDollar( data.charms ));
			dispatch(new SlotEvent(SlotEvent.GAME_UPDATE_BALANCE));
		}
		
		
	}
}