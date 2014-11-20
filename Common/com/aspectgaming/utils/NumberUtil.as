package com.aspectgaming.utils
{
	public class NumberUtil
	{
		public static const NUMBER_SOURCE:uint = 0;		//只显示原型
		public static const NUMBER_TOOGLE:uint = 1;		//简写
		public static const TAG_ADD:String = "+";
		public static const DOLLAR_TAG:String = "$";
		
		//private static const DOT_TAG:String = ".00";
		private static const MILLION_TAG:String = "M";
		private static const BILLION_TAG:String = "B";
		private static const KILO_TAG:String = "K";
		private static const KILO_NUM:uint = 3;
		private static const MILLION_NUM:uint = 6;
		private static const BILLION_NUM:uint = 9;
		
		
		public static function getNumByStyle(n:String, type:uint = 0, tag:String = null):String
		{
			n = Math.floor(Number(n)).toString();
			var result:String;
			if (type == NUMBER_SOURCE)
			{
				result = getSourceNumber(n);
				return (tag?(tag  + result):result);
			}
			else
			{	
				if (n.length > BILLION_NUM)
				{
					result = superFormatNumberWahahah(n,BILLION_NUM,BILLION_TAG)
				}
				else if (n.length > MILLION_NUM)
				{
					result = superFormatNumberWahahah(n,MILLION_NUM,MILLION_TAG)
				}
				else if(n.length > KILO_NUM && n.length <= MILLION_NUM)
				{
					result = superFormatNumberWahahah(n,KILO_NUM,KILO_TAG)
					
				}else {
					result = getSourceNumber(n);
					return (tag?(tag  + result):result);
				}
				
				return (result.length > 8)?result:(tag?(tag  + result):result);
			}
		}
		private static function superFormatNumberWahahah(n:String,lenNum:uint,tag:String):String {
			var arr:Array = n.split("");
			arr = arr.reverse();
			var result:Array = [];
			for (var i:uint = 0 ; i < arr.length; i++) {
					var c:String=arr[i] 
					if (c != "0" || result.length!=0 || i>lenNum-1) {
						if (i==lenNum && result.length!=0) {
							result.push(".");
						}
						result.push(c);
					}
			}
			var returnStr :String = result.reverse().join("") + tag
			
			if (returnStr.indexOf(".") != -1) {
				var  strL:Array = returnStr.split(".")
				var s:String=strL[1].substr(0,1)
				var  formatStr:String = strL[0] 
				if (strL[1].indexOf(tag) >= 0) {
					if (strL[1].indexOf(tag)==0 || s=="0") {
						formatStr += tag;
					}else {
						formatStr += "." + s +  tag;
					}
					
				}
				returnStr = formatStr
			//	strA = returnStr.substr(0, returnStr.indexOf(".") + 1);
			}
			return returnStr;
		}
		private static function getSourceNumber(n:String):String
		{
			var arr:Array = n.split("");
			arr = arr.reverse();
			var loop:uint =  uint((arr.length - 1) / 3);
			var num:uint = 0;
			for (var i:uint = 1; i <= loop; i++)
			{
				arr.splice(i * 3 + num, 0, ",");
				num++;
			}
			return arr.reverse().join("") ;
		}
		private static function getBillionNumber(n:String):String
		{
			var arr:Array = n.split("");
			arr = arr.reverse();
			
			var result:Array = [];
			for (var i:uint = 6; i < arr.length; i++)
			{
				if ((i - 6) % 3 == 0 && i != 6)
				{
					if (i <= BILLION_NUM)
					{
						result.push(".");
					}
					else
					{
						result.push(",");
					}
				}
				result.push(arr[i]);
			}
			return result.reverse().join("") + BILLION_TAG;
		}
		
		private static function getKiloNumber(n:String):String
		{
			var arr:Array = n.split("");
			arr = arr.reverse();
			var result:Array = [];
			if (arr.length == KILO_NUM) {
				for (var i:uint = 0 ; i < arr.length; i++) {
					var c:String=arr[i] 
					if (c != "0") {
						if (i==KILO_NUM) {
							result.push(".");
						}
						result.push(c);
					}
				}
			}else {
				
			}
			return result.reverse().join("") + KILO_TAG;
		}
		
		private static function getShortNumber(n:String):String
		{
			var arr:Array = n.split("");
			arr = arr.reverse();
			
			var result:Array = [];
			for (var i:uint = MILLION_NUM / 2; i < arr.length; i++)
			{
				if (i % 3 == 0 && i != MILLION_NUM / 2)
				{
					if (i <= MILLION_NUM)
					{
						result.push(".");
					}
					else
					{
						result.push(",");
					}
				}
				result.push(arr[i]);
			}
			return result.reverse().join("") + MILLION_TAG;
		}
		
		public static function centToDollar(n:Number):Number
		{
			return n / 100;
		}
		
		public static function dollarToCent(n:Number):Number
		{
			return n * 100;
		}
		
		public static function getRandomNumber(t:Number = int.MAX_VALUE, s:Number = 0):int
		{
			if (s >= t)
			{
				return 0;
			}
			else
			{
				var r:Number = s + Math.random() * (t - s);
				return int(r);
			}
		}
		
		/**
		 * 名次加上标 
		 * @return 
		 * 
		 */		
		public static function parseRank(n:Number):String
		{
			var tag:String = "th";
			if (n == 1)
			{
				tag = "st";
			}
			else if (n == 2)
			{
				tag = "nd";
			}
			else if (n == 3)
			{
				tag = "rd";
			}

			return tag;
		}
		
		public static  function getEmptyOrSource(source:Number):String
		{
			return (source <= 0)?"":source.toString();
		}
		
		public static function isEmptyNumber(n:Number):Boolean
		{
			return isNaN(n) || n == 0;
		}
		
		public static function proceeRank(rank:int):String
		{
			switch (rank)
			{
				case 1:
					return rank + "st";
					break;
				case 2:
					return rank + "nd";
					break;
				case 3:
					return rank + "rd";
					break;
				default:
					return rank + "th";
					break;
			}
		}
	}
}