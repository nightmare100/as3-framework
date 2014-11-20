package com.aspectgaming.game.controller 
{
	import com.aspectgaming.net.event.ServerEvent;

	
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class RegisterLobbyResultCommand extends BaseModuleCommand
	{
		[Inject]
		public var event:ServerEvent
		
		public override function execute ( ):void
		{
			
			this.moduleCommandMap.unmapEvent("registerPlayer", RegsterLobbyCommand, ServerEvent)
			this.sendLog(event.data)
			this.dispatch(new ServerEvent("registerPlayerCompleted", null))
		}
		
	}
	
}