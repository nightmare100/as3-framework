package com.aspectgaming.globalization.managers
{
	import com.aspectgaming.utils.LoggerUtil;
	import com.aspectgaming.utils.StringUtil;
	import com.aspectgaming.utils.constant.LogType;
	
	import flash.net.SharedObject;

	/**
	 * 本地存储管理 
	 * @author mason.li
	 * 
	 */	
	public class SharedObjectManager
	{
		private static var _commonRoot:String;
		private static var _userRoot:String;
		
		/**
		 * 
		 * @param productName 产品名
		 * @param userID      当前用户ID
		 * 
		 */		
		public static function setup(productName:String, playID:String):void
		{
			productName = StringUtil.trim(productName);
			playID = StringUtil.trim(playID);
			_commonRoot = productName + "/common/";
			_userRoot = productName + "/" + playID + "/";
		}
		
		public static function getCommonSharedObject(name:String):SharedObject
		{
			return SharedObject.getLocal(_commonRoot + name, "/");
		}
		
		public static function getUserSharedObject(name:String):SharedObject
		{
			return SharedObject.getLocal(_userRoot + name, "/");
		}
		
		public static function flush(sharedObject:SharedObject):void
		{
			try
			{
				sharedObject.flush();
			}
			catch(e:Error)
			{
				LoggerUtil.logServer(sharedObject.toString() + " flush error" + e.message, LogType.LOG_SHAREDOBJECT, LogType.LOG_SHAREDOBJECT_FLUSH_ERROR);
			}
		}
	}
}