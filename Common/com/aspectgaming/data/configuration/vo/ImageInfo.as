package com.aspectgaming.data.configuration.vo 
{
	
	public class ImageInfo 
	{
		public var freespinCompleted:String;
		public var bigWinPic:String;
		
		public function ImageInfo(xml:XMLList) 
		{
			getData(xml);
		}
		
		private function getData(xml:XMLList):void
		{
			freespinCompleted = xml.image.(@id == "freespinCompleted").@link;
			bigWinPic = xml.image.(@id=="bigWinPic").@link;
		}
	}

}