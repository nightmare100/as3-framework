package com.aspectgaming.notify
{
	import com.aspectgaming.notify.constant.NotifyType;
	import com.aspectgaming.ui.iface.IMessage;

	/**
	 * 界面消息 界面代理 
	 * @author mason.li
	 * 
	 */	
	public class NotifyViewInfo extends NotifyInfo
	{
		public var notifyInstance:IMessage;
		private var _isSingle:Boolean;
		
		/**
		 * 构造函数
		 * @param type
		 * @param name
		 * @param isSingle 是否使用单列
		 * @param info
		 * @param prior
		 * 
		 */		
		public function NotifyViewInfo(name:String, isSingle:Boolean = true, info:*=null, prior:uint = 2)
		{
			super(NotifyType.NOTIFY_VIEW, name, info, prior);
			_isSingle = isSingle;
		}
		
		/**
		 * 界面类消息有用 
		 * 
		 */		
		public function showView():void
		{
			notifyInstance = NotifyFactory.createMessage(notifyType, _notifyName, _isSingle);
			if (notifyInstance)
			{
				notifyInstance.data = _data;
				notifyInstance.viewName = notifyName;
				notifyInstance.autoShow();
			}
		}
		
		public function get statue():String
		{
			if (!notifyInstance)
			{
				return null;
			}
			
			return notifyInstance.statue;
		}
	}
}