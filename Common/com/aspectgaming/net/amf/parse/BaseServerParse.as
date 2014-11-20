package com.aspectgaming.net.amf.parse
{
	import com.aspectgaming.core.IParse;
	
	/**
	 * 服务器解析基类 
	 * @author mason.li
	 * 
	 */	
	public class BaseServerParse implements IParse
	{
		private var _parseMgr:ParseCommandManager;
		
		/**
		 * 注册解析命令 
		 * @return 
		 * 
		 */		
		public function get parseMgr():ParseCommandManager
		{
			if (!_parseMgr)
			{
				_parseMgr = new ParseCommandManager();
				registerCommand();
			}
			return _parseMgr;
		}
		
		protected function registerCommand():void
		{
			
		}
		
		public function BaseServerParse()
		{
		}
		
		/**
		 * 转换请求 适配器
		 * @param req
		 * @param data
		 * 
		 */	
		public function parseRequestData(req:String, data:Object=null):*
		{
			return parseMgr.transferDataFormat(req, data);
		}
		
		/**
		 * 处理响应
		 * @param req
		 * @param data
		 * 
		 */	
		public function parseResponse(req:String, data:*, parm:*=null):void
		{
			parseMgr.execute(req, data, parm);
		}
	}
}