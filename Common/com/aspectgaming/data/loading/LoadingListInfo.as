package com.aspectgaming.data.loading
{
	import flash.utils.Dictionary;

	public class LoadingListInfo
	{
		private var _currentProgress:Number = 0;
		private var _progressDic:Dictionary;
		private var _dataDic:Dictionary;
		public var completeFunc:Function;
		public var progressFunc:Function;
		public var needCache:Boolean;
		
		public function LoadingListInfo(func:Function = null, progress:Function = null, isCache:Boolean = false)
		{
			_dataDic = new Dictionary();
			_progressDic = new Dictionary();
			completeFunc = func;
			progressFunc = progress;
			this.needCache = isCache;
		}
		
		public function addLoadDatas(...arg):void
		{
			for (var i:uint = 0; i < arg.length; i++)
			{
				_dataDic[LoadingDataInfo(arg[i]).id] = arg[i];
			}
		}
		
		public function get vec():Vector.<LoadingDataInfo>
		{
			var vector:Vector.<LoadingDataInfo> = new Vector.<LoadingDataInfo>();
			for (var key:String in _dataDic)
			{
				vector.push(_dataDic[key]);
			}
			return vector;
		}
		
		/**
		 * 该组资源是否加载完成 
		 * @return 
		 * 
		 */		
		public function get isComplete():Boolean
		{
			for (var key:String in _dataDic)
			{
				if (!LoadingDataInfo(_dataDic[key]).isComplete)
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 判断资源ID是否在资源列表中 
		 * @param id
		 * @return 
		 * 
		 */		
		public function isInList(id:String):Boolean
		{
			if (id in _dataDic)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 设置资源为加载完成状态 
		 * @param id
		 * 
		 */		
		public function setComplete(id:String):void
		{
			if (_dataDic[id])
			{
				_progressDic[id] = 1;
				LoadingDataInfo(_dataDic[id]).isComplete = true;
			}
		}
		
		/**
		 * 获取整个文件组的加载进度 
		 * @param singleFileProgress 单个文件的加载百分比
		 * @return 
		 * 
		 */		
		public function getCompletePrefect(singleFileProgress:Number, id:String):Number
		{
			var completeLen:Number = 0;
			for (var key:String in _dataDic)
			{
				if (LoadingDataInfo(_dataDic[key]).isComplete)
				{
					completeLen++;
				}
				else
				{
					var singleProgress:Number = _progressDic[key] ? _progressDic[key]  : 0;
					if (key == id)
					{
						_progressDic[id] = singleFileProgress;
						singleProgress = singleFileProgress;
					}
					
					completeLen += singleProgress;
				}
			}
			var progress:Number = completeLen / vec.length * 100;
			if (progress > _currentProgress)
			{
				_currentProgress = progress;
			}
			return _currentProgress;
		}
	}
}