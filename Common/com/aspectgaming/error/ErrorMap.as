package com.aspectgaming.error
{
	import com.aspectgaming.globalization.managers.NotifyManager;
	import com.aspectgaming.notify.NotifyViewInfo;
	import com.aspectgaming.notify.constant.NotifyDefined;
	
	import flash.utils.Dictionary;

	/**
	 * 错误消息 
	 * @author mason.li
	 * 
	 */	
	public class ErrorMap
	{
		private static var _map:Dictionary = new Dictionary();
		
		initialize();
		private static function initialize():void
		{
			//系统

		}
		
		public static function parseErrorCode(errID:int, data:* = null):void
		{
			switch (errID)
			{
				case ErrorMapCode.NOT_ENOUGH_CHARMS:
					NotifyManager.addMessageViewDirect(new NotifyViewInfo(NotifyDefined.UNLOCK_PANEL))
					break;
				default:
					//不做处理
					/*var description:String = getDescription(errID);
					AlertManager.showAlert(description + "!");*/
					break;
			}
		}
		
		private static function getDescription(errorID:*):String
		{
			if(_map[errorID])
			{
				return _map[errorID];
			}
			return "ErrorID:" + errorID;
		}
	}
}