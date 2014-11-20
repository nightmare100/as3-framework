package com.aspectgaming.globalization.managers 
{
	//import com.aspectgaming.core.IServer;
	/**
	 * ...
	 * @author zoe.jin
	 */
	public class ShopManager 
	{
		private static var _instance:ShopManager;
		private static var _masterId:Number;
		private static var _curPlayerId:Number;
		private static var _playerGifts:Array;
		
		public function ShopManager() 
		{
			if (!_instance)
			{
				_instance = new ShopManager();
			}
		}
		
		static public function get getInstance():ShopManager 
		{
			return _instance;
		}
		
		static public function get playerGifts():Array 
		{
			return _playerGifts;
		}
		
		static public function set playerGifts(value:Array):void 
		{
			_playerGifts = value;
		}
		
		static public function get curPlayerId():Number 
		{
			return _curPlayerId;
		}
		
		static public function set curPlayerId(value:Number):void 
		{
			_curPlayerId = value;
		}
		
		static public function get masterId():Number 
		{
			return _masterId;
		}
		
		static public function set masterId(value:Number):void 
		{
			_masterId = value;
		}
		
		
	}

}