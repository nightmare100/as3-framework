package com.aspectgaming.utils.tick
{
	import com.aspectgaming.utils.DateUtil;

	/**
	 * Tick时间解析器
	 * @author mason.li
	 * 
	 */	
	public class DateParse
	{
		private var _totalSeconds:Number;

		private var _hours:Number;
		private var _seconds:Number;
		private var _minutes:Number;
		private var _days:Number;
		
		public function DateParse(timer:Number = 0)
		{
			totalSeconds = timer;
		}
		
		public function set totalSeconds(value:Number):void
		{
			_totalSeconds = value;
			parseTime();
		}

		private function parseTime():void
		{
			_days = Math.floor(_totalSeconds / 86400);
			_hours = Math.floor((_totalSeconds - _days * 86400) / 3600);
			_minutes = Math.floor((_totalSeconds - _days * 86400 - _hours * 3600) / 60);
			_seconds = Math.floor(_totalSeconds - _days * 86400 - _hours * 3600 - _minutes * 60);
			
			
		}
		
		public function get days():Number
		{
			return _days;
		}
		
		public function get dayString():String
		{
			return DateUtil.getZeroFill(_days, 2);
		}

		public function get minutes():Number
		{
			return _minutes;
		}
		
		public function get minutesString():String
		{
			return DateUtil.getZeroFill(_minutes, 2);
		}

		public function get seconds():Number
		{
			return _seconds;
		}
		
		public function get secondsString():String
		{
			return DateUtil.getZeroFill(_seconds, 2);
		}

		public function get hours():Number
		{
			return _hours;
		}
		
		public function get hourString():String
		{
			return DateUtil.getZeroFill(_hours, 2);
		}

		/**
		 * 返回剩余秒数 
		 * @return 
		 * 
		 */		
		public function get totalSeconds():Number
		{
			return _totalSeconds;
		}

	}
}