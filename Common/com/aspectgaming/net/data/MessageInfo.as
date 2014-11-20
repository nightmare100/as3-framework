package com.aspectgaming.net.data
{
	
	/**
	 * 响应信息VO 
	 * @author mason.li
	 * 
	 */	
	public class MessageInfo
	{
		public function MessageInfo(reqCmd:String, responseData:*, requestData:* = null)
		{
			req = reqCmd;
			response = responseData;
			request = requestData;
		}
		
		public var req:String;
		public var request:*;
		public var response:*;
	}
}