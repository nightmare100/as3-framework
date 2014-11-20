package com.aspectgaming.game.base.control.error
{
	import com.aspectgaming.event.AssetLoaderEvent;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.iface.IErrorParse;
	import com.aspectgaming.net.event.ServerErrorEvent;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * 全局错误事件 
	 * @author mason.li
	 * 
	 */	
	public class ErrorHandlerCommand extends Command
	{
		[Inject]
		public var errorEvent:Event;
		
		[Inject]
		public var errorParse:IErrorParse;
		
		override public function execute():void
		{
			if (errorParse)
			{
				errorParse.parseSystemError(isServerError);
			}
		}
		
		public function get isServerError():Boolean
		{
			return errorEvent is ServerErrorEvent;
		}
		
	}
}