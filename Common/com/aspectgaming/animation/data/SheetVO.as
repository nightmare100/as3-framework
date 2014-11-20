package com.aspectgaming.animation.data
{
	public class SheetVO
	{
		public function SheetVO()
		{
			framesSet  = new Vector.<FramesVO>;
		}
		
		/**
		 * 资源ID
		 */
		public var resId:String;
		
		/**
		 * 使用次数
		 */
		public var useNum:int = 0;
		/**
		 * 动画帧序列
		 */
		public var framesSet:Vector.<FramesVO>;
		
		/**
		 * 内存大小
		 */
		public var memorySize:int;
		
		/**
		 * 帧长度
		 */
		public function get frameLength():int
		{
			if (framesSet)
			{
				return framesSet.length
			}
			else
			{
				return 0;
			}
		}
	}
}