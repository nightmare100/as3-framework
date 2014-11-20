package com.aspectgaming.utils.pool
{
	import flash.utils.Dictionary;

	/**
	 * UI对象池 
	 * @author mason.li
	 * 
	 */	
	public class UIPool
	{
		public var maxCount:uint;
		private var _cls:Class;
		private var _arr:Array = [];
		private var _callback:Dictionary = new Dictionary();
		
		public function UIPool(cls:Class, maxCount:uint = 10)
		{
			_cls = cls;
			maxCount = maxCount;
		}
		
		public function addCallBack(type:String, func:Function):void
		{
			_callback[type] = func;
		}
		
		public function checkOut():*
		{
			if (_arr.length > 0)
			{
				return _arr.pop();
			}
			
			if (_cls)
			{
				var o:* = new _cls();
				if (o.addEventListener)
				{
					for (var key:String in _callback)
					{
						o.addEventListener(key, _callback[key]);
					}
				}
				
				return o;
			}
			return null;
		}
		
		public function checkIn(o:*):Boolean
		{
			if (_arr.length < maxCount)
			{
				if (_arr.indexOf(o) != -1)
				{
					_arr.push(o);
					return true;
				}
			}

			return false;
		}
		
		public function dispose():void
		{
			for each (var o:* in _arr)
			{
				if (o.dispose != null && o.dispose != undefined)
				{
					o.dispose();
					if (o.removeEventListener)
					{
						for (var key:String in _callback)
						{
							o.removeEventListener(key, _callback[key]);
						}
					}
				}
			}
			_cls = null;
			_arr = null;
			_callback = null;
		}
	}
}