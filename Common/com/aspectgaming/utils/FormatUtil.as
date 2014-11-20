package com.aspectgaming.utils
{
	import flash.globalization.NumberFormatter;
	import flash.globalization.CurrencyFormatter;
	import flash.globalization.DateTimeFormatter;
	
	/**
	 * 格式辅助 
	 * @author mason.li
	 * 
	 */	
	public class FormatUtil 
	{
		public static function numFormate(num:Number,isInt:Boolean):String 
		{			//数值加千位分隔符
			var numberFormat:NumberFormatter = new NumberFormatter( "en_US" );
			var str:String = numberFormat.formatNumber(num);
			
			//mac os fixed
			if (str.indexOf(".00") == -1) 
			{
				str += ".00";
			}
			
			
			var len:int = str.length;
			
			if (isInt) 
			{
				str = str.substring(0, len - 3);
			}
			
			return str;
		}
		
		public static function accountFormat(num:Number, isInt:Boolean = false):String 
		{						//会计记数格式
			//trace("accountFormat",num)
			var str:String = num.toFixed(2);
			var len:int = str.length;
			var charArray1:Array = [];
			var charArray2:Array = [];
			
			for(var i:int=len;i>0;i--)
			{
				var char:String = str.substr(i - 1, 1);
				charArray1.push(char);
			}
			
			for(i=0;i<len;i++)
			{
				charArray2.push(charArray1[i]);
				if(i%3==2 && (i>3 && i!=len-1)){
					charArray2.push(",");
				}
			}
			
			charArray2 = charArray2.reverse();
			str = charArray2.join("");
			str = str.replace("-,", "-");
			if(isInt)
			{
				str = str.slice(0, str.length - 3);
			}
			
			return str;
		}

	}

}