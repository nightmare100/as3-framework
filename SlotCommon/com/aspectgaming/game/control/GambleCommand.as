package com.aspectgaming.game.control
{
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GambleType;
	import com.aspectgaming.game.constant.GamePlayType;
	import com.aspectgaming.game.event.GambleEvent;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.net.event.ServerEvent;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * 玩游戏Gamble 命令 
	 * @author mason.li
	 * 
	 */	
	public class GambleCommand extends ModuleCommand
	{
		[Inject]
		public var slotEvent:SlotEvent;
		
		[Inject]
		public var server:IServer;
		
		override public function execute():void
		{
			switch (slotEvent.content)
			{
				case GambleType.GAMBLE_START:
					server.addEventListener(SlotAmfCommand.CMD_GAMBLE_GAME, onPlayBack);
					server.sendRequest(SlotAmfCommand.CMD_GAMBLE_GAME, slotEvent.data);
					break;
				case GambleType.GAMBLE_SELECT:
					server.addEventListener(SlotAmfCommand.CMD_GAMBLE_GAMESELETE, onPlayBack);
					server.sendRequest(SlotAmfCommand.CMD_GAMBLE_GAMESELETE, slotEvent.data);
					break;
				case GambleType.GAMBLE_TAKEWIN:
				case GambleType.GAMBLE_END:
					server.addEventListener(SlotAmfCommand.CMD_GAME_END, onPlayBack);
					server.sendRequest(SlotAmfCommand.CMD_GAME_END, slotEvent.data);
					break;
				default:
					break;
			}
		}
		
		private function onPlayBack(e:ServerEvent):void
		{
			server.removeEventListener(SlotAmfCommand.CMD_GAMBLE_GAME, onPlayBack);
			server.removeEventListener(SlotAmfCommand.CMD_GAMBLE_GAMESELETE, onPlayBack);
			server.removeEventListener(SlotAmfCommand.CMD_GAME_END, onPlayBack);
			dispatchToModules(new SlotEvent(SlotEvent.GAMBLE_GAME_REQUEST_BACK,e.data,e.req));
			if (e.req == SlotAmfCommand.CMD_GAME_END)
			{
				dispatch(new GambleEvent(GambleEvent.GAMBLE_END));
			}
		}
	}
}