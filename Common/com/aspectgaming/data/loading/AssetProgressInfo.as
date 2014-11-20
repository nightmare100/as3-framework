package com.aspectgaming.data.loading 
{
	
	/**
	 * 加载进度信息
	 * @author mason.li
	 * 
	 */	
	public class AssetProgressInfo
	{
		public var bytesTotal:uint;
		public var bytesLoaded:uint;
		public var speed:Number;
		public var progress:Number;
		public var averageSpeed:Number;
		public var id:String
		public function AssetProgressInfo()
		{
			
		}
		
	}
	
}