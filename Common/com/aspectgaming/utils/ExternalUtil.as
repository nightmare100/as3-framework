package com.aspectgaming.utils
{
	
	import flash.external.ExternalInterface;

	/**
	 *  
	 * @author mason.li
	 * 
	 */	
	public class ExternalUtil
	{
		public static function addCallBack(jsFunction:String, callBack:Function):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback(jsFunction, callBack);
			}
		}
		
		public static function call(jsFunction:String, ...arg):*
		{
			if (ExternalInterface.available)
			{
				return ExternalInterface.call(jsFunction, arg);
			}
			else
			{
				return null;
			}
		}
	}
}