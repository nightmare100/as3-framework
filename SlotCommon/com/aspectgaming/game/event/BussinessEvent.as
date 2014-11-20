package com.aspectgaming.game.event
{
	import com.aspectgaming.event.base.BaseEvent;
	
	/**
	 * 业务逻辑 
	 * @author mason.li
	 * 
	 */	
	public class BussinessEvent extends BaseEvent
	{
		public static const NOT_ENOUGH_MONEY:String = "notEnoughMoney";
		
		public function BussinessEvent(type:String, data:*=null, content:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
		}
	}
}