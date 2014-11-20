package com.aspectgaming.net.facebook.data
{
	import com.aspectgaming.net.facebook.constant.FaceBookMethod;

	/**
	 * FaceBook数据模拟 
	 * @author mason.li
	 * 
	 */	
	public class FaceBookDataSimulation
	{
		/**
		 * 邀请好友数据模拟 
		 * @param method
		 * @return 
		 * 
		 */
		public function getDataByType(method:String):Object
		{
			switch (method)
			{
				
				case FaceBookMethod.GetFriendList:
					return {data:[
						{
							"uid": 1222642450,
							"name": "Allegro Tao",
							"first_name": "Allegro",
							"is_app_user": false
						},
						{
							"uid": 1275958259,
							"name": "William Wu",
							"first_name": "William",
							"is_app_user": false
						},
						{
							"uid": 1309401083,
							"name": "Evan Chen",
							"first_name": "Evan",
							"is_app_user": false
						},
						{
							"uid": 100000738632612,
							"name": "Kevin Sun",
							"first_name": "Kevin",
							"is_app_user": false
						},
						{
							"uid": 1275958259,
							"name": "Ailliam Wu",
							"first_name": "William",
							"is_app_user": true
						},
						{
							"uid": 1309401083,
							"name": "Advan Chen",
							"first_name": "Evan",
							"is_app_user": true
						},
						{
							"uid": 100000738632612,
							"name": "AEevin Sun",
							"first_name": "Kevin",
							"is_app_user": true
						},
						{
							"uid": 100000738632612,
							"name": "AFevin Sun",
							"first_name": "Kevin",
							"is_app_user": true
						},
						{
							"uid": 1275958259,
							"name": "AGilliam Wu",
							"first_name": "William",
							"is_app_user": true
						},
						{
							"uid": 1309401083,
							"name": "AHdvan Chen",
							"first_name": "Evan",
							"is_app_user": true
						},
						{
							"uid": 100000738632612,
							"name": "ABevin Sun",
							"first_name": "Kevin",
							"is_app_user": true
						}]};
				
				case FaceBookMethod.InviteFriends:
				case FaceBookMethod.SendGiftToSelectFriend:
					return {
					to:[1222642450, 1275958259, 1309401083, 100000738632612,111,222,333,444,555,666,777,888,999,101010,100004341013046, 100003723899104, 1222642450, 100004525894816, 1066105505, 1526447876]
				};
			}
			return null;
		}
	}
}