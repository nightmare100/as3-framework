package com.aspectgaming.notify
{
	
	import flash.utils.getTimer;
	
	/**
	 * 基本消息定义 
	 * @author mason.li
	 * 
	 */	
	public class NotifyInfo
	{
		public var notifyType:String;
		public var priority:uint;
		public var messageTimer:int;
		
		protected var _data:*;
		protected var _notifyName:String;
		/**
		 *  
		 * @param type 消息类型
		 * @param name 该消息对应的名称
		 * @param info 消息VO数据
		 * @parm prior 优先级
		 * 
		 */		
		public function NotifyInfo(type:String, name:String, info:* = null, prior:uint = 2)
		{
			notifyType = type;
			_notifyName = name;
			_data = info;
			priority = prior;
			messageTimer = getTimer();
		}

		public function get data():*
		{
			return _data;
		}

		public function get notifyName():String
		{
			return _notifyName;
		}

	}
}