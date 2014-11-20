package com.aspectgaming.utils
{
	import flash.utils.ByteArray;
	
	public class StringUtil 
	{
		/**
		 * 是否为空字符串 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function isEmptyString(str:String):Boolean
		{
			return str == null || str == "";
		}
		
		public static function formatUrl(url:String):String 
		{
			if (url == null) { return null; }
			
			if (url.length > 0 && url.charAt(url.length - 1) != "/") {
				url += "/";
			}
			return url;
		}
		
		public static function trim(char:String):String
		{
			if(char == null){
				return null;
			}
			var pattern:RegExp = /\s+/; 
			return char.replace(pattern,"");
		}
		
		public static function isLatin(str:String):Boolean 
		{
			var isLatin:Boolean = true;
			
			for(var i:int=0; i<str.length; i++)
			{
				if(str.charCodeAt(i)>127)
				{
					isLatin = false;
					break;
				}
			}
			
			return isLatin;
		}
		
		public static function isVaildEmail(email:String):Boolean
		{
			var pattern:RegExp = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+(w+([.-]\w+))*/;
			return pattern.test(email); 
		}
		
		/**
		 * 字符串转译成ASCII码 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function transferCharCode(str:String):String
		{			
			var arr:Array = [];
			
			for(var i:int=0; i < str.length; i++)
			{
				arr.push( "&#" + str.charCodeAt(i) + ";");
			}
			
			return arr.join("");
		}
		
		public static function getStringBytesLength(str:String, charSet:String = "utf-8"):int
		{
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeMultiByte(str, charSet);
			bytes.position = 0;
			return bytes.length;
		}
	}
}