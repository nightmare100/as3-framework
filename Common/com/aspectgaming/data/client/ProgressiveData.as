package com.aspectgaming.data.client
{
	import com.aspectgaming.constant.ProgressiveDefine;
	import com.aspectgaming.net.vo.ProgressiveLevelDTO;
	
	/**
	 * ...
	 * @author zoe.jin
	 */
	
	public class ProgressiveData 
	{
		public var infos:Array;
		private var _currentInfo:Object;
		
		public function ProgressiveData()
		{	
			_currentInfo = {};
			_currentInfo[ProgressiveDefine.Minor] = 0;
			_currentInfo[ProgressiveDefine.Major] = 0;
			_currentInfo[ProgressiveDefine.Grand] = 0;
			_currentInfo[ProgressiveDefine.Mini] = 0;
		}
		
		public function get progresvTotalReward():Number 
		{
			if (!infos || infos.length <= 0)
			{
				return 0;
			}
			else
			{
				var total:Number = 0 ;
				for each (var dto:ProgressiveLevelDTO in infos)
				{
					total += dto.progressiveAmount;
				}
				return total;
			} 
		}
		
		public function setData(type:String, cur:Number):void
		{
			_currentInfo[type] = cur;
		}
		
		public function getData(type:String):Number
		{
			return isNaN(_currentInfo[type])? 0 : _currentInfo[type];
		}
		
	}
}