package com.aspectgaming.utils
{
	import flash.net.LocalConnection;

	/**
	 * 系统类辅助 
	 * @author mason.li
	 * 
	 */	
	public class SystemUtil
	{
		/**
		 * 形成一次回收  
		 * 
		 */		
		public static function gc():void
		{
			try
			{
				var lc1:LocalConnection = new LocalConnection();
				var lc2:LocalConnection = new LocalConnection();
				lc1.connect("gcAspectgaming");
				lc2.connect("gcAspectgaming");
			}
			catch (e:Error)
			{
				
			}
		}
	}
}