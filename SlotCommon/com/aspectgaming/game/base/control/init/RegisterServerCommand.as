package com.aspectgaming.game.base.control.init
{
	import com.aspectgaming.core.IParse;
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.data.configuration.Configuration;
	import com.aspectgaming.data.configuration.game.GameCellInfo;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.utils.LoggerUtil;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * 服务器初始化 
	 * @author mason.li
	 * 
	 */	
	public class RegisterServerCommand extends Command
	{
		[Inject]
		public var server:IServer;
		
		[Inject]
		public var serverParse:IParse;
		
		[Inject]
		public var gameInfo:GameInfo;
		
		override public function execute():void
		{
			server.init(gameInfo.gameServer, ClientManager.useEncode, serverParse,  LoggerUtil.logServer);	
		}
		
	}
}