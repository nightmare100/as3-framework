package com.aspectgaming.game.error
{
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.iface.IErrorParse;
	import com.aspectgaming.globalization.managers.ModuleManager;

	/**
	 * 系统错误 和 游戏错误 解析 
	 * 如有需要 请继承覆盖 
	 * @author mason.li
	 * 
	 */	
	public class ErrorParse implements IErrorParse
	{
		public function parseGameError(code:uint):void
		{
			/*switch (code)
			{
				
			}*/
		}
		
		public function parseSystemError(isServerError:Boolean):void
		{
			if (isServerError)
			{
				ModuleManager.dispatchToGame(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_ERROR));
			}
			else
			{
				ModuleManager.dispatchToGame(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_LOADING_ERROR));
			}
		}
		
	}
}