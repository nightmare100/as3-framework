package com.aspectgaming.net.amf.parse.cmd
{

	public interface ICommand
	{
		/**
		 * 执行回包转换
		 * @param data
		 * 
		 */		
		function execute(data:* = null, requestData:* = null):void;
		
		/**
		 * 执行请求包转换 
		 * @param req
		 * @param data
		 * @return 
		 * 
		 */		
		function parse(req:String, data:Object = null):*;
	}
}