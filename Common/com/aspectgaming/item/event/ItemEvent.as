package com.aspectgaming.item.event
{
	import com.aspectgaming.event.base.BaseEvent;
	
	import flash.events.Event;

	public class ItemEvent extends BaseEvent
	{
		public static const ITEM_ADD:String = "ItemAdded";
		public static const ITEM_REMOVED:String = "ItemAdded";
		public static const ITEM_ACTION:String = "ItemAction";
		public static const ITEM_CHECK:String = "ItemCheck";
		
		public function ItemEvent(type:String, data:* = null,content:String = null)
		{
			super(type, data , content);
		}
		
		override public function clone():Event
		{
			return new ItemEvent(type, data, content);
		}
		
		
		
	}
}