package com.aspectgaming.data
{
	/**
	 * Makeliving User 信息
	 * @author mason.li
	 * 
	 */	
	public class MakeLivingUser
	{
		public var apiUrl:String;
		
		public var userID:uint;
		public var userName:String;
		private var _sex:String;
		public var key:String;
		public var headUrl:String;
		
		public var firstName:String;
		public var lastName:String;
		
		public var isDirectToGame:Boolean;
		
		private static var _instance:MakeLivingUser;
		
		public function get sex():String
		{
			return _sex;
		}

		public function set sex(value:String):void
		{
			if (value == "M")
			{
				_sex = "male";
			}
			else
			{
				_sex ="female";
			}
		}

		public static function getInstance():MakeLivingUser
		{
			if (!_instance)
			{
				_instance = new MakeLivingUser();
			}
			
			return _instance;
		}
		
		public function get isMale():Boolean
		{
			return sex == "male";
		}
		
		public function get apiHeadIconUrl():String
		{
			return apiUrl + "getUserIcon/";
		}
		
		public function init(o:Object):void
		{
			userID = o["userID"];
			key = o["key"];
			sex = o["sex"];
			headUrl = o["headUrl"];
			apiUrl = o["makeLivApiUrl"];
			firstName = o["firstName"];
			lastName = o["lastName"];
			isDirectToGame = o["directToMySlot"];
		}
	}
}