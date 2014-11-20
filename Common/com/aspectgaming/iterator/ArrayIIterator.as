package com.aspectgaming.iterator
{
	
	/**
	 * 数组迭代器  
	 * @author mason.li
	 * 
	 */	
	public class ArrayIIterator implements IIterator
	{
		private var _arr:Array;
		private var _currentIdx:uint;
		
		public function ArrayIIterator()
		{
			_arr = [];
		}
		
		public function hasNext():Boolean
		{
			return _currentIdx + 1 < _arr.length;
		}
		
		public function getItem(key:*):*
		{
			return null;
		}
		
		public function get current():*
		{
			if (_currentIdx < _arr.length)
			{
				return _arr[_currentIdx];
			}
			else
			{
				return null;
			}
		}
		
		public function replaceItem(oldItem:*, newItem:*):void
		{
			for (var i:uint = 0; i < _arr.length; i++)
			{
				if (_arr[i] == oldItem)
				{
					_arr[i] = newItem;
				}
			}
		}
		
		public function get currentIdx():uint
		{
			return _currentIdx;
		}
		
		public function moveNext():void
		{
			_currentIdx = _currentIdx + 1;
			checkIndex();
		}
		
		private function checkIndex():void
		{
			_currentIdx = _currentIdx >= _arr.length ? 0 : _currentIdx;
		}
		
		public function moveTo(idx:uint):void
		{
			_currentIdx = idx;
			checkIndex();
		}
		
		public function addItem(vo:*):void
		{
			if (!isItemExist(vo))
			{
				_arr.push(vo);
			}
		}
		
		private function isItemExist(o:*):Boolean
		{
			for each (var obj:* in _arr)
			{
				if (obj == o)
				{
					return true;
				}
			}
			return false;
		}
		
		public function removeCurrentItem():void
		{
			if (current)
			{
				_arr.splice(_arr.indexOf(current), 1);
				checkIndex();
			}
		}
		
		public function removeItem(vo:*):void
		{
			_arr.splice(_arr.indexOf(vo), 1);
			checkIndex();
		}
		
		public function isItemExistByAttr(attr:String, key:*):Boolean
		{
			for (var i:uint = 0; i < _arr.length; i++)
			{
				var o:Object = _arr[i];
				if (o.hasOwnProperty(attr) && o[attr] == key)
				{
					return true;
				}
			}
			return false;
		}
		
		public function getItemByAttribute(attr:String, key:*):*
		{
			for (var i:uint = 0; i < _arr.length; i++)
			{
				var o:Object = _arr[i];
				if (o.hasOwnProperty(attr) && o[attr] == key)
				{
					return o;
				}
			}
			return null;
		}
		
		public function removeItemByAttribute(attr:String, key:*):Boolean
		{
			for (var i:uint = 0; i < _arr.length; i++)
			{
				var o:Object = _arr[i];
				if (o.hasOwnProperty(attr) && o[attr] == key)
				{
					_arr.splice(i, 1);
					checkIndex();
					return true;
				}
			}
			return false;
		}
		
		public function get itemList():Array
		{
			return _arr;
		}
		
		public function get totalItemNum():uint
		{
			return _arr.length;
		}
		
		public function set itemList(list:*):void
		{
			_arr = list as Array;
			_currentIdx = 0;
		}
	}
}