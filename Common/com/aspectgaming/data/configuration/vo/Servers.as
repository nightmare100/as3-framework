package com.aspectgaming.data.configuration.vo 
{
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.utils.StringUtil;
	
	public class Servers 
	{
		private var _lobbyServer:String;				//where to load soap data for casino
		public var logServer:String;
		public var lobbyAssets:String;				//where to load Casino.swf
		public var gamesAssets:String;				//where to load games
		public var gameServer:String;				//where to load soap data for games
		public var trackServer:String;
		
		public function Servers(xml:XMLList) 
		{
			getData(xml);
			//	trace("xml="+xml);
		}

		public function get lobbyServer():String
		{
			return _lobbyServer;
		}

		public function set lobbyServer(value:String):void
		{
			_lobbyServer = value;
			logServer = lobbyServer.replace("amfmessage/", "logop/");
		}
		
		public function get shareServerUrl():String
		{
			return logServer + "?optype=share";
		}
		
		private function getData(xml:XMLList):void 
		{
			lobbyServer = getPathUrl(ClientManager.protocolType ,  StringUtil.formatUrl(xml.lobby.@server));
			lobbyAssets = getPathUrl(ClientManager.protocolType ,  xml.lobby.@assetsRoot);
			gamesAssets = getPathUrl(ClientManager.protocolType ,  xml.game.@assetsRoot);
			gameServer  = getPathUrl(ClientManager.protocolType ,  xml.game.@server);
			trackServer  = getPathUrl(ClientManager.protocolType , xml.tag.@server);
			//trackServer  = getPathUrl(ClientManager.protocolType , "http://172.16.1.165:8080/datatrackmessage");
			
			/*	
			trace("-------http/https--------------------------------------");
			trace("lobbyServer=" + lobbyServer);
			trace("lobbyAssets=" + lobbyAssets);
			trace("gamesAssets=" + gamesAssets);
			trace("gameServer="+gameServer);
			trace("-------------------------------------------------------");
			*/	
		}
		
		private function getPathUrl(protocol:String, path:String):String
		{
			if (path.substr(0, 2) == "//")
			{
				return protocol + path;
			}
			else
			{
				return path;
			}
		}
		
		public function setServerPath(path:String):void
		{
			lobbyServer = path;
			gameServer = path;
		}
	}

}