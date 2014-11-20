package com.aspectgaming.core
{
	
	/**
	 * Server解析接口
	 * 实现 参考AMFPARSE 
	 * @author mason.li
	 * 
	 */	
	public interface IParse
	{
		function parseRequestData(req:String, data:Object = null):*;
		function parseResponse(req:String, data:*, parm:* = null):void;
	}
}