package com.aspectgaming.game.controller 
{
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.net.event.ServerEvent;
	import com.aspectgaming.net.vo.request.RegisterPlayerC2S;

	
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class RegsterLobbyCommand extends BaseModuleCommand
	{
		[Inject]
		public var service:IServer
		
		[Inject]
		public var gameInfo:GameInfo
		
		public override function execute ( ):void
		{
			moduleCommandMap.mapEvent("registerPlayer", RegisterLobbyResultCommand, ServerEvent, true);
			
			var registerPlayer:RegisterPlayerC2S = new RegisterPlayerC2S();
			registerPlayer.firstName = "Zoe";
			registerPlayer.lastName = "Jin";
			registerPlayer.facebookId = "1";
			registerPlayer.email="zoejin1016@hotmail.com";
			registerPlayer.adSource="";
			registerPlayer.thirdPathId="";
			registerPlayer.sex="";
			registerPlayer.brithday="12/02/2013";
			registerPlayer.language = "";
			
			this.sendLog(registerPlayer)
			service.sendRequest("registerPlayer", registerPlayer);

		}
	}
	
}