package com.aspectgaming.utils
{
	/**
	 * 日期转换 
	 * @author mason.li
	 * 
	 */	
	public class DateUtil
	{
		private static const ZERO_WORD:String = "0";
		
		public static function parseTickToString(tick:Number, tag:String = "-", timeTag:String = ":", isDateOnly:Boolean = false):String
		{
			var date:Date = new Date(tick);
			var year:String = getZeroFill(date.getFullYear(), 2);
			var month:String = getZeroFill(date.getMonth() + 1, 2);
			var dt:String = getZeroFill(date.getDate(), 2);
			
			if (isDateOnly)
			{
				return [year, month, dt].join(tag);
			}
			else
			{
				var hour:String = getZeroFill(date.getHours(), 2);
				var min:String = getZeroFill(date.getMinutes(), 2);
				var sec:String = getZeroFill(date.getSeconds(), 2);
				return [year, month, dt].join(tag) + " " + [hour, min, sec].join(timeTag);
			}
		}
		
		/**
		 * 数字加0操作  
		 * @param n
		 * @param len
		 * @param isLeft 是否从左面加
		 * @return 
		 * 
		 */		
		public static function getZeroFill(n:Number, len:uint, isLeft:Boolean = true):String
		{
			var s:String = n.toString();
			if (s.length >= len)
			{
				return s;
			}
			else
			{
				var zeroWord:String = "";
				var zeroNum:uint = len - s.length;
				for (var i:uint = 0; i < zeroNum; i++)
				{
					zeroWord += ZERO_WORD;	
				}
				
				return isLeft?(zeroWord + s):(s + zeroWord);
			}
		}
		
		public static function changeTag(d:String ,split:String = "-", tag:String = ""):String
		{
			var date:Array = d.split(split);
			var year:String = date[0];
			var month:String = date[1];
			var day:String = date[2];
			
			return [month, day, year].join(tag);
		}
		
		public static function changeDateToSec(d:String, split:String = "-"):Number
		{
			var date:Array = d.split(split);
			var month:Number = date[0];
			var day:Number = date[1];
			var year:Number = date[2];
			var millenium:Date = new Date(year, month, day);
		
			return millenium.time/10000;
		//	return year * 365 * 24 * 60 * 60 + 
		}
		
		public static function isEqual(dateA:Date, dateB:Date):Boolean
		{
			if (dateA == null || dateB == null)
			{
				return false;
			}

			if (dateA.time == dateB.time)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}