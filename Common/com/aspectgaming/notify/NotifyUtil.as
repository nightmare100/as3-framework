package com.aspectgaming.notify
{
	/**
	 * 消息层 辅助类 
	 * @author mason.li
	 * 
	 */	
	public class NotifyUtil
	{
		
		/**
		 * 从消息列表中 取出消息内容数组 
		 * @param vec
		 * @return 
		 * 
		 */		
		public static function parseNotifyDataToArray(vec:Vector.<NotifyInfo>):Array
		{
			var result:Array = [];
			for (var i:uint = 0; i < vec.length; i++)
			{
				result.push(vec[i].data);
			}
			return result;
		}
	}
}