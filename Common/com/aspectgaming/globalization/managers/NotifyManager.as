package com.aspectgaming.globalization.managers
{
	import com.aspectgaming.event.NotifyEvent;
	import com.aspectgaming.globalization.module.ModuleStatue;
	import com.aspectgaming.net.vo.GiftDTO;
	import com.aspectgaming.notify.NotifyInfo;
	import com.aspectgaming.notify.NotifyViewInfo;
	import com.aspectgaming.notify.constant.NotifyDefined;
	import com.aspectgaming.notify.constant.NotifyType;
	import com.aspectgaming.utils.LoggerUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	
	[Event(name="onNotify", type="com.aspectgaming.event.NotifyEvent")]
	[Event(name="onNotifyDelete", type="com.aspectgaming.event.NotifyEvent")]
	[Event(name="onNotifyViewClose", type="com.aspectgaming.event.NotifyEvent")]
	/**
	 * 全局消息管理 
	 * @author mason.li
	 * 
	 */	
	public class NotifyManager
	{
		/**
		 * 消息上限 
		 */		
		private static const MAX_COUNT:uint = 500;
		
		private static var _notifyDic:Dictionary;
		
		/**
		 * 当前处理的消息 
		 */		
		private static var _currentNotify:NotifyViewInfo;
		private static var _eventDispatcher:EventDispatcher;
		
		initializa();

		public static function get eventDispatcher():EventDispatcher
		{
			if (!_eventDispatcher)
			{
				_eventDispatcher = new EventDispatcher();
			}
			return _eventDispatcher;
		}

		private static function initializa():void
		{
			_notifyDic = new Dictionary();
			_notifyDic[NotifyType.NOTIFY_VIEW] = new Vector.<NotifyInfo>();
			_notifyDic[NotifyType.NOTIFY_MARK] = new Vector.<NotifyInfo>();
			_notifyDic[NotifyType.NOTIFY_SCROLL] = new Vector.<NotifyInfo>();
			_notifyDic[NotifyType.NOTIFY_CHAT] = new Vector.<NotifyInfo>();
		}
		
		/**
		 * 向消息层 直接添加 面板消息 而不受队列影响(多窗口) 
		 * @param info
		 * 
		 */		
		public static function addMessageViewDirect(info:NotifyViewInfo):void
		{
			if (info)
			{
				info.showView();
				LoggerUtil.traceNormal("[ShowMessage]", info.notifyInstance);
				dispatchEvent(new NotifyEvent(NotifyEvent.ON_NOTIFYVIEW_SHOW, info.notifyName));
			}
		}
		
		/**
		 * 完全替换一个类型的消息 
		 * @param notices
		 * @param type
		 * @param name
		 * 
		 */		
		public static function replaceMessageList(notices:Vector.<NotifyInfo>, type:String, name:String = null):void
		{
			var notifyList:Vector.<NotifyInfo> = _notifyDic[type];
			if (!notifyList)
			{
				throw new Error("没有该类型消息!");
				return;
			}
			_notifyDic[type] = notices;
			dispatchEvent(new NotifyEvent(NotifyEvent.ON_NOTIFY + type, name));
		}
		
		/**
		 * 向消息层 添加一条消息 
		 * @param info
		 * 
		 */		
		public static function addMessage(info:NotifyInfo):void
		{
			var notifyList:Vector.<NotifyInfo> = _notifyDic[info.notifyType];
			if (!notifyList)
			{
				throw new Error("没有该类型消息!");
				return;
			}
			
			if (notifyList.length > MAX_COUNT)
			{
				if (info.notifyType ==  NotifyType.NOTIFY_CHAT)
				{
					notifyList.shift();
					notifyList.push(info);
					dispatchEvent(new NotifyEvent(NotifyEvent.ON_NOTIFY + info.notifyType, info.notifyName, info.data));
				}
				else
				{
					//可alert
					trace("消息类型", info.notifyType, "已满!");
				}
				return;
			}
			
			notifyList.push(info);
			notifyList.sort(sortByPriority);
			
			if (info.notifyType == NotifyType.NOTIFY_VIEW)
			{
				showNext();
			}
			else
			{
				dispatchEvent(new NotifyEvent(NotifyEvent.ON_NOTIFY + info.notifyType, info.notifyName, info.data));
			}
		}
		
		/**
		 * 优先级排序  排序次序 priority -> messageTimer 
		 * @param infoA
		 * @param infoB
		 * @return 
		 * 
		 */		
		private static function sortByPriority(infoA:NotifyInfo, infoB:NotifyInfo):int
		{
			if (infoA.priority > infoB.priority)
			{
				return -1;
			}
			else if (infoA.priority == infoB.priority)
			{
				if (infoA.messageTimer > infoB.messageTimer)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else
			{
				return 1;
			}
		}
		
		/**
		 * noticeView类型专用 
		 * 
		 */		
		public static function showNext(callName:String = null):void
		{
			if (callName)
			{
			 	dispatchEvent(new NotifyEvent(NotifyEvent.ON_NOTIFYVIEW_CLOSE, callName));
			}
			
			var notifyList:Vector.<NotifyInfo> = _notifyDic[NotifyType.NOTIFY_VIEW];
			if (!_currentNotify || _currentNotify.statue == ModuleStatue.HIDE)
			{
				if (notifyList.length > 0)
				{
					_currentNotify = notifyList.shift() as NotifyViewInfo;
					if (_currentNotify)
					{
						_currentNotify.showView();
						dispatchEvent(new NotifyEvent(NotifyEvent.ON_NOTIFYVIEW_SHOW + _currentNotify.notifyName, _currentNotify.notifyName, _currentNotify.notifyInstance));
					}
				}
			}
		}
		
		/**
		 * 获取某个类型的消息数量 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getNotifyLen(type:String, name:String = null):uint
		{
			var list:Vector.<NotifyInfo> = _notifyDic[type];
			if (!name)
			{
				return list.length;
			}
			else
			{
				var n:uint = 0;
				for each (var info:NotifyInfo in list)
				{
					if (info.notifyName == name)
					{
						n++;
					}
				}
				return n;
			}
		}
		
		/**
		 * 获取某个类型的消息列表 
		 * @param type
		 * @parm name 消息名称
		 * @return 
		 * 
		 */		
		public static function getNotifyList(type:String, name:String = null):Vector.<NotifyInfo>
		{
			var list:Vector.<NotifyInfo> = _notifyDic[type];
			if (!name)
			{
				return list;
			}
			else
			{
				var backList:Vector.<NotifyInfo> = new Vector.<NotifyInfo>();
				for (var i:uint = 0; i < list.length; i++)
				{
					if (list[i].notifyName == name)
					{
						backList.push(list[i]);
					}
				}
				return backList;
			}
		}
		
		/**
		 * 删除礼物消息 
		 * @param id
		 * 
		 */		
		public static function delNotifyByGiftID(id:Number):void
		{
			var list:Vector.<NotifyInfo> = getNotifyList(NotifyType.NOTIFY_MARK, NotifyDefined.GIFT_MARK_MESSAGE);
			for each (var info:NotifyInfo in list)
			{
				if (info.data is GiftDTO && GiftDTO(info.data).giftId == id)
				{
					deleteSingle(NotifyType.NOTIFY_MARK, info);
					return;
				}
			}
		}
		
		public static function delNotifyByCustom(id:*, key:String, type:String, name:String = null):void
		{
			var list:Vector.<NotifyInfo> = getNotifyList(type, name);
			for each (var info:NotifyInfo in list)
			{
				if (info.data[key] == id)
				{
					deleteSingle(type, info);
					return;
				}
			}
		}
		
		
		/**
		 * 清除指定类型的消息 
		 * @param type 消息类型
		 * @param name 消息名称
		 * 
		 */		
		public static function clearNotifyByTagAndName(type:String, name:String = null):void
		{
			var list:Vector.<NotifyInfo> = _notifyDic[type];
			if (list)
			{
				if (name)
				{
					for (var i:uint = 0; i < list.length; i++)
					{
						if (list[i].notifyName == name)
						{
							list.splice(list.indexOf(list[i]), 1);
							i--;
						}
					}
				}
				else
				{
					_notifyDic[type] = new Vector.<NotifyInfo>();
				}
				dispatchEvent(new NotifyEvent(NotifyEvent.ON_NOTIFY_DEL + type, name));
			}
		}
		
		private static function deleteSingle(type:String, info:NotifyInfo):void
		{
			var list:Vector.<NotifyInfo> = _notifyDic[type];
			for each (var note:NotifyInfo in list)
			{
				if (note == info && list.indexOf(info) != -1)
				{
					list.splice(list.indexOf(info), 1);
					dispatchEvent(new NotifyEvent(NotifyEvent.ON_NOTIFY_DEL + type, info.notifyName));
					return;
				}
			}
		}
		
		
		/**
		 * 从消息组里取一条消息 并删除记录 
		 * @param type 消息类型
		 * @return 
		 * 
		 */		
		public static function getSingleNotice(type:String):NotifyInfo
		{
			if (_notifyDic[type])
			{
				var delInfo:NotifyInfo = _notifyDic[type].shift();
				dispatchEvent(new NotifyEvent(NotifyEvent.ON_NOTIFY_DEL + delInfo.notifyName, delInfo.notifyType));
				return delInfo;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 清除所有消息 
		 * 
		 */		
		public static function clear():void
		{
			_currentNotify = null;
			initializa();
		}
		
		
		//=====================================================================
		
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:uint = 0, useWeakRef:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakRef);
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			eventDispatcher.removeEventListener(type, listener);
		}
		
		public static function dispatchEvent(evt:Event):void
		{
			if (hasEventListener(evt.type))
			{
				eventDispatcher.dispatchEvent(evt);
			}
		}
		
		private static function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
		
	}
}