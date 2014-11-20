package com.aspectgaming.game.config.reel
{
	
	/**
	 * 速度信息 
	 * @author mason.li
	 * 
	 */	
	public class SpeedInfo
	{
		private const ALL_TAG:String = "all";
		
		/**
		 * Key 
		 */		
		public var level:uint;
		public var startDelay:uint;
		public var spinDelay:uint;
		public var stopDelay:uint;
		private var fullSpeedDur:uint;
		
		private var _singleReelSpeedInfo:Object;
		
		private var _sourceXml:XML;
		
		public function SpeedInfo(xml:XML)
		{
			level = uint(xml.@speedLv);	
			startDelay = uint(xml.@startDelay);	
			spinDelay = uint(xml.@spinDelay);	
			stopDelay = uint(xml.@stopDelay);	
			fullSpeedDur = uint(xml.@fullSpeedDur);
			
			fullReelSpeed(xml.singleReel);
			
			_sourceXml = xml;
		}
		
		public function clone():SpeedInfo
		{
			return new SpeedInfo(_sourceXml);
		}
		
		/**
		 * 递增速度 
		 * @param rate
		 * 
		 */		
		public function updateSpeed(rate:Number):void
		{
			for each (var info:ReelAcceleration in _singleReelSpeedInfo)
			{
				info.updateSpeed(rate);
			}
			
			startDelay = startDelay*(1 - rate);
			spinDelay = spinDelay*(1 - rate);
			stopDelay = stopDelay*(1 - rate);
			fullSpeedDur = fullSpeedDur*(1 - rate);			
		}
		
		public function get totalRunTime():uint
		{
			return spinDelay + fullSpeedDur;
		}
		
		public function getVelocityStart(type:String):Number
		{
			var accInfo:ReelAcceleration = getAccInfo(type);
			if (accInfo)
			{
				return accInfo.vStart;
			}
			else
			{
				return 0;
			}
		}
		
		public function getVelocityStop(type:String):Number
		{
			var accInfo:ReelAcceleration = getAccInfo(type);
			if (accInfo)
			{
				return accInfo.vStop;
			}
			else
			{
				return 0;
			}
		}
		
		public function useBlur(type:String):Boolean
		{
			var accInfo:ReelAcceleration = getAccInfo(type);
			if (accInfo)
			{
				return accInfo.useBlur;
			}
			else
			{
				return false;
			}
		}
		
		public function getVelocityMax(type:String):Number
		{
			var accInfo:ReelAcceleration = getAccInfo(type);
			if (accInfo)
			{
				return accInfo.vMax;
			}
			else
			{
				return 0;
			}
		}
		
		public function getAccInfo(type:String):ReelAcceleration
		{
			if (_singleReelSpeedInfo[type])
			{
				return _singleReelSpeedInfo[type];
			}
			else
			{
				return _singleReelSpeedInfo[ALL_TAG];
			}
		}
		
		private function fullReelSpeed(list:XMLList):void
		{
			_singleReelSpeedInfo = {};
			for each (var xml:XML in list)
			{
				_singleReelSpeedInfo[xml.@type] = new ReelAcceleration(xml);
			}
		}
	}
}