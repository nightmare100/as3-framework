package com.aspectgaming.data.configuration.vo
{
	public class DelcareInfo
	{
		public var termsInfo:String;
		public var privacy:String;
		public function DelcareInfo(xml:XML)
		{
			termsInfo = xml.en_US.terms;
			privacy = xml.en_US.privacy;
		}
	}
}