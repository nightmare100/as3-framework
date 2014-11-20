package com.aspectgaming.net
{
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.net.amf.AMFService;
	import com.aspectgaming.net.constant.ServerType;
	import com.aspectgaming.net.socket.SocketService;

	/**
	 * 通信工厂  
	 * @author mason.li
	 * 
	 */	
	public class ServerFactory
	{
		public static function createServer(type:String = ""):IServer
		{
			switch (type)
			{
				case ServerType.AMF:
					return new AMFService();
				case ServerType.SOAP:
				case ServerType.SOCKET:
					return new SocketService();
				default:
					return null;
					break;
			}
		}
	}
}