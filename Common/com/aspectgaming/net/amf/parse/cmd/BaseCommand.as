package com.aspectgaming.net.amf.parse.cmd
{

	public class BaseCommand implements ICommand
	{
		public function execute(data:*=null, requestData:* = null):void
		{
			
		}
		
		public function parse(req:String, data:Object = null):*
		{
			return data;
		}
		
	}
}