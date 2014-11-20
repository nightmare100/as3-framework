package com.aspectgaming.error
{
	import com.aspectgaming.ui.ReconnectBox;
	import com.aspectgaming.utils.constant.TickConstant;
	import com.aspectgaming.utils.tick.Tick;

	/**
	 * 数据请求出错处理 
	 * @author mason.li
	 * 
	 */	
	public class ServerErrorAgent
	{
		private static const MAX_ERROR_COUNT:uint = 3;
		private static var _errorTimes:uint;

		public static function get errorTimes():uint
		{
			return _errorTimes;
		}

		public static function setErrorTimes(value:uint, callBack:Function = null):void
		{
			_errorTimes = value;
			if (_errorTimes <= MAX_ERROR_COUNT)
			{
				if (callBack != null)
				{
					callBack();
				}
				else
				{
					defaultError();
				}
			}
		}
		
		/**
		 * 添加请求超时处理 
		 * 
		 */		
		public static function addTimeOutHandler():void
		{
			Tick.addTimeout(defaultError, TickConstant.TIME_OUT_NUM, TickConstant.TIMEOUT_SETTED_TAG);
		}
		
		/**
		 * 检查请求是否超时 
		 * @return 
		 * 
		 */		
		public static function isRequestTimeout():Boolean
		{
			var leftTime:Number = Tick.getTimeLeft(TickConstant.TIMEOUT_SETTED_TAG);
			Tick.removeTimeout(TickConstant.TIMEOUT_SETTED_TAG);
			if (leftTime == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function defaultError():void
		{
			Tick.clear();
			ReconnectBox.show();
		}
	}
}