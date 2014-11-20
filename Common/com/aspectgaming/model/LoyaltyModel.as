package com.aspectgaming.model 
{
	import com.aspectgaming.data.configuration.LevelsRuinConfiguration;
	import com.aspectgaming.event.LobbyEvent;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.NotifyManager;
	import com.aspectgaming.net.vo.LoyaltyDTO;
	import com.aspectgaming.net.vo.LoyaltyLevelInfoDTO;
	import com.aspectgaming.notify.constant.NotifyDefined;
	import com.aspectgaming.notify.NotifyViewInfo;
	import com.aspectgaming.utils.NumberUtil;
	
	import flash.events.EventDispatcher;

	/**
	 * loyalty system数据模型...
	 * @author Will Jiang
	 */
	public class LoyaltyModel extends EventDispatcher
	{
		private var _currLoyalty:LoyaltyDTO;			//当前等级的loyalty数据
		private var _loyaltyLevelInfo:Array;			//各等级loyalty的相关配置数据
		
		
		public function LoyaltyModel() 
		{
			
		}
		
		public function get currLoyalty():LoyaltyDTO 
		{
			if (!_currLoyalty) {
				_currLoyalty = new LoyaltyDTO();
			}
			return _currLoyalty;
		}
		
		/**
		 * parsePlayerinfoCommand 和 registerPlayerCommand 调用 设置loyalty等级
		 * @param value
		 * 
		 */		
		public function set currLoyalty(value:LoyaltyDTO):void 
		{
			_currLoyalty = value;
			convertDayHours();
			
			// 升降级
			checkLevelChange(value.message);
			//更新 timereward
			LevelsRuinConfiguration.updateLevel(value.playerLevel);
			
			dispatchEvent(new LobbyEvent(LobbyEvent.LOYALTY_UPDATED));
		}
		
		private function convertDayHours():void
		{
			_currLoyalty.days = int(Math.abs(_currLoyalty.seconds / 86400));
			_currLoyalty.hours = int((Math.abs(_currLoyalty.seconds) - _currLoyalty.days * 86400) / 3600);
			
			if (_currLoyalty.hours == 0) {
				_currLoyalty.hours = 1;
			}
		}
		
		public function set loyaltyLevelInfo(value:Array):void 
		{
			_loyaltyLevelInfo = value;
		}
		
		public function get loyaltyLevelInfo():Array 
		{
			return _loyaltyLevelInfo;
		}
		
		/**
		 * 获取指定等级的loyalty数据
		 * @param	levelName
		 * @return
		 */
		public function getLoyaltyInfo(levelName:String):LoyaltyLevelInfoDTO
		{
			for each(var item:LoyaltyLevelInfoDTO in _loyaltyLevelInfo) {
				if (item.levelName == levelName) {
					return item;
				}
			}
			return null;
		}
		
		private function checkLevelChange(message:String):void
		{
			if (message && message != "") 
			{
				if (message.indexOf("beforeLevelUP") >= 0) 
				{
					_currLoyalty.tierUp = 1;
					dispatchEvent(new LobbyEvent(LobbyEvent.LOYALTY_LEVEL_UP, null, message));
				}
				else if (message.indexOf("downto") >= 0)
				{
					_currLoyalty.tierUp = -1;
					dispatchEvent(new LobbyEvent(LobbyEvent.LOYALTY_LEVEL_DOWN, null, message));
				}
			}else {
				_currLoyalty.tierUp = 0;
			}
		}
		
		
		
	}

	
	
	
	
	
	
}

