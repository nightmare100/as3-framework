package com.aspectgaming.data.configuration.vo
{
	import com.aspectgaming.utils.StringUtil;
	
	
	public class AssetsPath 
	{
		public var label:String;
		public var promotion:String;
		
		public function AssetsPath(xml:XMLList) 
		{
			getData(xml);
		}
		
		private function getData(xml:XMLList):void
		{
			label = xml.label.@path;
			promotion = StringUtil.formatUrl(xml.promotion.@path);
		//	trace("promotion="+promotion);
		}
		
	}

}