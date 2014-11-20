package com.aspectgaming.net.data
{
	import flash.utils.Dictionary;
	
	/**
	 * Block信息管理 
	 * @author mason.li
	 * 
	 */	
	public class BlockInfoManager
	{
		private static var _blockInfo:Dictionary = new Dictionary();
		
		public static function addBlockInfo(req:String, msg:MessageInfo):void
		{
			if (!_blockInfo[req])
			{
				_blockInfo[req] = new Vector.<MessageInfo>();
			}
			
			_blockInfo[req].push(msg);
		}
		
		public static function releaseInfo(req:String):Vector.<MessageInfo>
		{
			var msglist:Vector.<MessageInfo> = _blockInfo[req];
			if (msglist)
			{
				delete msglist[req];
			}
			
			return msglist;
		}
		
	}
}