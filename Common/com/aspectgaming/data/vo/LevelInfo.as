package com.aspectgaming.data.vo 
{
	/**
	 * 用户等级信息 
	 * @author mason.li
	 * 
	 */	
	public class LevelInfo 
	{
		private var _prevLevel:uint;
		private var _currentLevel:uint=1;
		
		/**
		 * 当前的经验 
		 */		
		public var currentMemshipPoint:Number;
		
		/**
		 * 当前升级所需要的经验 
		 */		
		public var currentLevelUpMemshipPoint:Number;
		
		/**
		 * 当前等级的基础经验 
		 */		
		public var levelMemshipPoint:Number;
		
		public var levelUpAmount:Number;
		public var nextLevel:uint;
		
		public function LevelInfo() 
		{
			
		}
		
		public function get prevLevel():uint
		{
			return _prevLevel;
		}

		public function get currentLevel():uint
		{
			return _currentLevel;
		}

		public function set currentLevel(value:uint):void
		{
			_prevLevel = _currentLevel;
			_currentLevel = value;
		}
		
		public function get currentExp():Number
		{
			return currentMemshipPoint - levelMemshipPoint;
		}
		
		public function get levelUpExp():Number
		{
			return currentLevelUpMemshipPoint - levelMemshipPoint;
		}

		public function get isLevelUp():Boolean
		{
			return _prevLevel != 0 && currentLevel > _prevLevel;
		}
		
	}

}