package com.aspectgaming.data.configuration
{
	import com.aspectgaming.constant.PromotionMode;
	import com.aspectgaming.globalization.managers.SharedObjectManager;
	
	import flash.net.SharedObject;
	
	/**
	 * 促销设置 
	 * @author mason.li
	 * 
	 */	
	public class PromotionSetting
	{
		private var _mode:uint;
		
		private var _perTime:uint;
		
		private var _onlyTime:uint;
		
		public function PromotionSetting(mode:uint, perTime:uint, onlyTime:uint)
		{
			_mode = mode;
			_perTime = perTime;
			_onlyTime = onlyTime;
		}
		
		public function get canProPopUp():Boolean
		{
			var sharedObject:SharedObject = SharedObjectManager.getCommonSharedObject("promotion");
			switch(_mode)
			{
				case PromotionMode.NONE:
					return true;
					break;
				case PromotionMode.PER_MODE:
					if (!isNaN(sharedObject.data.perTimes))
					{
						sharedObject.data.perTimes += 1;
					}
					else
					{
						sharedObject.data.perTimes = 1;
					}
					SharedObjectManager.flush(sharedObject);
					
					return (sharedObject.data.perTimes - 1) % _perTime == 0;
					break;
				case PromotionMode.ONLY_MODE:
					if (!isNaN(sharedObject.data.onlyTimes))
					{
						sharedObject.data.onlyTimes += 1;
					}
					else
					{
						sharedObject.data.onlyTimes = 1;
					}
					SharedObjectManager.flush(sharedObject);
					return sharedObject.data.onlyTimes <= _onlyTime;
					break;
			}
			return true;
		}
		
	}
}