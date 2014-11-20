package com.aspectgaming.data.configuration.vo 
{
	
	public class Language
	{
		public var currency:String;
		public var currencySymbol:String;
		
		public function Language(xml:XMLList) 
		{
			getData(xml);
		}
		
		private function getData(xml:XMLList):void
		{
			currency = xml[0].@currency;
			currencySymbol = xml[0].@currencySymbol;
		}
	}

}