package com.aspectgaming.globalization.managers 
{
	import com.aspectgaming.event.LobbyEvent;
	import com.aspectgaming.model.LoyaltyModel;
	import com.aspectgaming.notify.NotifyViewInfo;
	import com.aspectgaming.notify.constant.NotifyDefined;
	
	import flash.events.EventDispatcher;
	
	
	/**
	 * Loyalty system的单例管理器...
	 * @author 
	 */
	public class LoyaltyManager extends EventDispatcher
	{
		private static var _inst:LoyaltyManager;
		
		private var _loyaltyModel:LoyaltyModel;
		
		
		public function LoyaltyManager(singleForcer:SingleForcer) 
		{
			if (singleForcer == null) {
				throw new Error("Wrong way to create LoyaltyManager instance !");
			}
		}
		
		public static function get inst():LoyaltyManager 
		{
			if (_inst == null) {
				_inst = new LoyaltyManager(new SingleForcer());
				_inst._loyaltyModel = new LoyaltyModel();
				
			}
			return _inst;
		}
		
		public function get loyaltyModel():LoyaltyModel 
		{
			if (!_loyaltyModel.hasEventListener(LobbyEvent.LOYALTY_LEVEL_UP)) {
				_loyaltyModel.addEventListener(LobbyEvent.LOYALTY_LEVEL_UP, onLoyaltyLevelUp);
			}
			return _loyaltyModel;
		}
		
		private function onLoyaltyLevelUp(evt:LobbyEvent):void
		{
			showLoyalty(true);
		}
		
		public function showLoyalty(useList:Boolean = false):void
		{
			var notifyViewInfo:NotifyViewInfo = new NotifyViewInfo(NotifyDefined.LOYALTY_WINDOW, true);
			if (useList)
			{
				NotifyManager.addMessage(notifyViewInfo);
			}
			else
			{
				NotifyManager.addMessageViewDirect(notifyViewInfo);
			}
		}
		
	}

}





class SingleForcer {};	