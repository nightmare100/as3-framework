package com.aspectgaming.data.configuration.vo
{
	/**
	 * 广告图片列表 
	 * @author mason.li
	 * 
	 */	
	public class AdvertisList
	{
		private var _scrollDelay:uint;
		
		private var _dataList:Array;
		private var _index:int = -1;
		
		public function AdvertisList(xml:XMLList)
		{
			readMessageAreaXML(xml);
		}
		
		private function readMessageAreaXML(xml:XMLList):void
		{
			_scrollDelay = uint(xml.@["delay"]);
			
			var msgList:XMLList = xml["message"];
			var xmlLen:uint = msgList.length();
			
			_dataList = [];
			for(var i:uint = 0; i < xmlLen; i++)
			{
				_dataList.push({url:String(msgList[i].@imgURL), isMovieClip:Boolean(uint(msgList[i].@isMovieClip)), x:int(msgList[i].@x), y:int(msgList[i].@y), banMask:Boolean(uint(msgList[i].@banMask)), pageName:String(msgList[i].@pageName), gameID:String(msgList[i].@gameID), tag:String(msgList[i].@tag)});
			}
		}
		
		public function get scrollDelay():uint
		{
			return _scrollDelay;
		}
		
		public function getNextImgUrl():Object
		{
			if(_dataList == null)
			{
				return null;
			}
			
			if(_index + 1 >= _dataList.length)
			{
				_index = 0;
			}
			else
			{
				_index += 1;
			}
			
			return _dataList[_index];
		}
	}
}