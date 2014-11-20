package com.aspectgaming.data.struct
{
	import flash.utils.Dictionary;

	public class HashSet
	{
		private var _dic:Dictionary;
		public function HashSet()
		{
			_dic = new Dictionary();
		}
		
		public function clear():void
		{
			for (var key:* in _dic)
			{
				delete _dic[key];
			}
		}
		
		public function get hashValue():Boolean
		{
			for (var key:* in _dic)
			{
				if (_dic[key])
				{
					return true;
				}
			}
			return false;
		}
		
		public function getHashByValue(arr:Array):Boolean
		{
			for (var i:uint = 0; i < arr.length; i++)
			{
				if (!_dic[arr[i]])
				{
					return false;
				}
			}
			return true;
		}
		
		public function setHash(key:*, value:Boolean):void
		{
			_dic[key] = value;
		}
		
		public function dispose():void
		{
			_dic = null;
		}
	}
}