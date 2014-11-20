package com.aspectgaming.notify
{
	import com.aspectgaming.constant.BonusType;
	import com.aspectgaming.notify.constant.NotifyDefined;
	import com.aspectgaming.notify.constant.NotifyType;
	import com.aspectgaming.ui.iface.IMessage;
	
	import flash.utils.Dictionary;

	/**
	 * 消息工厂 
	 * @author mason.li
	 * 
	 */	
	public class NotifyFactory
	{
		private static var _messageDic:Dictionary = new Dictionary();
		private static var _messageCache:Dictionary = new Dictionary();
		
		public static function registerMessageView(type:String, cls:Class):void
		{
			_messageDic[type] = cls;
		}
		
		public static function createMessage(type:String, name:String, isSingle:Boolean):IMessage
		{
			//只有View类型消息有Imessage对象
			if (type == NotifyType.NOTIFY_VIEW)
			{
				var cls:Class = _messageDic[name];
				var message:IMessage;
				
				message = isSingle ? _messageCache[cls] : new cls();
				
				if (!message && cls)
				{
					message = new cls();
				}
				
				if (isSingle)
				{
					_messageCache[cls] = message;
				}
				
				return message;
			}
			else
			{
				return null;
			}
		}
		
		public static function getDailyRewardNotifyType(type:int):String
		{
			switch (type)
			{
				case BonusType.PLAYER_MSG_TYPE_NEWPLAYER:					//new player
				case BonusType.PLAYER_MSG_TYPE_DAILY_REWARD:				//welcome back
					return NotifyDefined.REWARD_DAILY;
				case BonusType.PLAYER_MSG_TYPE_COME_BACK_REWARD:
				case BonusType.PLAYER_MSG_TYPE_EXTRA_WELCOME_REWARD:
					return NotifyDefined.REWARD_EXTRA;
			}
			return null;
		}
	}
}