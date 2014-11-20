package com.aspectgaming.game.control
{
	import com.aspectgaming.constant.CoinType;
	import com.aspectgaming.constant.TrackPath;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.constant.asset.AssetRefDefined;
	import com.aspectgaming.game.event.BussinessEvent;
	import com.aspectgaming.game.manager.GameTipsManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * 金钱不足处理 
	 * @author mason.li
	 * 
	 */	
	public class NoMoneyProcessCommand extends Command
	{
		[Inject]
		public var bussinessEvent:BussinessEvent;
		
		override public function execute():void
		{
			if (NewPlayerGuidManager.isInGuild)
			{
				NewPlayerGuidManager.nextStep();
				return;
			}
			
			var isBalance:Boolean = bussinessEvent.content == CoinType.GAMECOIN;
			if (!isBalance)
			{
				GameTipsManager.popUp(AssetRefDefined.BUYDRAGON_TIPS, true);
			}
			else
			{
				if (isBalance)
				{
					ModuleManager.dispatchToGame(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_NOT_ENOUGH_MOENY, CoinType.GAMECOIN, "0", { path:TrackPath.ANY_SLOTS + TrackPath.BET_WITH_CHIPS } ));
				}
				else
				{
					ModuleManager.dispatchToGame(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_NOT_ENOUGH_MOENY, CoinType.DRAGON, "0", { path:TrackPath.ANY_SLOTS + TrackPath.BET_WITH_DOLLARS }));
				}
				
			}
		}
		
	}
}