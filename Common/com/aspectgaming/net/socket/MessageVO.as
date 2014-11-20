package com.aspectgaming.net.socket
{
	public class MessageVO
	{
		public var description:String;
		public var cmdReq:int;
		public var cmdRes:int;
		public var reqClass:Class;
		public var resClass:Class;
		public function MessageVO(cmdRequest:int, reqCls:Class, cmdResponse:int, resCls:Class, desc:String)
		{
			description = desc;
			cmdReq = cmdRequest;
			cmdRes = cmdResponse;
			reqClass = reqCls;
			resClass = resCls;
			
		}
	}
}