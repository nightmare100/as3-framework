package com.aspectgaming.net.amf.parse
{
	import com.aspectgaming.net.amf.parse.cmd.ICommand;
	
	import flash.utils.Dictionary;
	
	/**
	 * 解析器 命令 
	 * @author mason.li
	 * 
	 */	
	public class ParseCommandManager
	{
		private var _parseDic:Dictionary;
		
		public function ParseCommandManager()
		{
			_parseDic = new Dictionary();
		}
		
		public function addParseCommand(cmd:String, cmdParse:Class):void
		{
			_parseDic[cmd] = cmdParse;
		}

		/**
		 * 处理响应 
		 * @param type 
		 * @param req
		 * @param data
		 * 
		 */		
		public function execute(req:String, data:* = null, requestData:* = null):void
		{
			var cmd:ICommand = getCommand(req);
			if (cmd)
			{
				cmd.execute(data, requestData);
			}
		}
		
		/**
		 * 转换请求包 
		 * @param req
		 * @param data
		 * @return 
		 * 
		 */		
		public function transferDataFormat(req:String, data:Object = null):*
		{
			var cmd:ICommand = getCommand(req);
			if (cmd)
			{
				return cmd.parse(req, data);
			}
			
			return data;
		}
		
		private function getCommand(req:String):ICommand
		{
			if (_parseDic[req])
			{
				if (_parseDic[req] is Class)
				{
					_parseDic[req] = new _parseDic[req]();
				}
				return _parseDic[req] as ICommand;
			}
			
			return null;
		}
	}
}