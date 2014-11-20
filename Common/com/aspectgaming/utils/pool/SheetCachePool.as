package com.aspectgaming.utils.pool
{    
	import com.aspectgaming.animation.data.SheetVO;

	/**
	 * 位图帧缓存池 迭代器 
	 * @author mason.li
	 * 
	 */	
	public class SheetCachePool 
	{
        /**
         * 添加
         * @param	vo
         */
		public static function append(vo:SheetVO):void
		{
			_cache.push(vo);
            _currentSize += vo.memorySize;
			while (_currentSize > MaxSize)
			{
				var delVo:SheetVO = _cache.shift();
				_currentSize -= delVo.memorySize;
			}
		}
		
        /**
         * 是否在队列中存在
         * @param	keyName
         * @return
         */
		public static function hasVO(keyName:String):Boolean
		{
			for (var i:uint = 0; i < _cache.length; i++)
			{
				if (SheetVO(_cache[i]).resId == keyName)
				{
					return true;
				}
			}
			return false;
		}
		
        /**
         * 获取引用
         * @param	keyName
         * @return
         */
		public static function getVO(keyName:String):SheetVO
		{
			for (var i:uint = 0; i < _cache.length; i++)
			{
				if (SheetVO(_cache[i]).resId == keyName)
				{
					return _cache[i];
				}
			}
			return null;
		}
		
        /**
         * 移除
         * @param	keyName
         */
		public static function remove(keyName:String):void
		{
			for (var i:uint = 0; i < _cache.length; i++)
			{
				if (SheetVO(_cache[i]).resId == keyName)
				{
					_currentSize -= SheetVO(_cache[i]).memorySize;
					_cache.splice(i, 1);
					return;
				}
			}
			
		}
        
        public static function empty():void
        {
            _cache.length = 0;
        }
		
        /**
         * 缓存队列
         */
		private static var _cache:Array = [];
		
		/**
		 * 当前缓冲大小
		 */
		private static var _currentSize:Number = 0;
		
        /**
         * 缓冲最大内存数
		 * 50M
         */
        private static const MaxSize:Number = 0x3200000;
	}

}