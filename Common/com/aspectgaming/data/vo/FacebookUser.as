package com.aspectgaming.data.vo 
{
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.net.vo.MissionDTO;
	import com.aspectgaming.utils.StringUtil;
	
	public class FacebookUser 
	{
		private static const USER_GROUP_C:int = 0;
		private static const USER_GROUP_A:int = 1;
		private static const USER_GROUP_B:int = 2;
		
		
		
		public var promoName:String;			//促销活动名称，即swf名称,(用户登录时)
		public var isDisplay:Boolean;			//是否显示促销活动
		public var code:int;
		public var responseCode:Boolean;
		public var facebookID:String;			//Facebook user ID, from webpage
		public var playerID:String;				//platform user ID
		public var sessionKey:String;
		public var message:String;
		public var IsGuest:Boolean;
		public var isAutoLogin:Boolean;
		public var leaderBoardRank:uint;		//LeaderBoard等级
		
		public var adType:String;
		public var adID:String;
		public var inviteID:String;
		public var userName:String;
		public var lastName:String;				//from FB json,will be send to platform when register FB user
		public var firstName:String;			//from FB json,will be send to platform when register FB user
		public var userEmail:String;
		public var userBirth:String;			//User birthday
		public var userSex:String;				//User gender,male/female
		public var userLocale:String;			//User language
		public var userAge:String;					
		
		public var hasLike:Boolean;
		public var unsuberlike:Boolean; 
		public var tutorialCompleted:Boolean;
		public var slotTournamentCompleted:Boolean;		//tournament 教程是否已完成
		public var severalLoginCount:int;				//continuous login days
		public var severalLoginReward:int;				//continuous login Amounts
		
		public var timelineBonus:Number = 0;				//timeline奖励(dollar)
		
		public var timelineCode:Number;
		public var timelineID:String;
		
		private var _groups:int;
		
		/**
		 * 是否为新注册用户 
		 */		
		public var isNewUser:Boolean;			
		/**
		 *是否需要新手引导 
		 */		
		private var _isShowTutorial:Boolean;
		/**
		 * 
		 * @param bl 服务器下发是否为新手
		 * 
		 */		
		public function set isShowTutorial(bl:Boolean):void{
			_isShowTutorial=bl;
		}
		
		
		/**
		 * 
		 * @return 是否 为新手，且指引列表内无数据
		 * 
		 */		
		public function get isShowTutorial():Boolean{		
		
			return _isShowTutorial;
		}
		
		
		public function get missId():int{			
			var missId:int = 0;
			var missons:Vector.<MissionDTO> = ClientManager.lobbyModel.missions;
			if(missons != null && missons.length > 0)
			{
				//服务器有保存数据
				missId = int(missons[missons.length-1].missionId)
			}else if(isShowTutorial && missId == 0){
				//是新手，服务器无步骤数据，置第一步
				missId = 1;				
			}			
			
			return missId;			
		}
		
		
		
		/**
		 *初始化 leaderboard tab 页签号 
		 */		
		public var initLeaderBoardTab:int;
		
		public function FacebookUser() 
		{
			
		}
		
		
		public function get isInviteUser():Boolean
		{
			return adID.length > 0 && adType.indexOf("invite") != -1;
		}
		
		
		/**
		 * 填充FACEBOOK信息 封装  
		 * @param info 
		 * 
		 */		
		public function fullUserInfo(info:Object):void
		{
			firstName = info.first_name;
			lastName = info.last_name;
			userName = info.name;
			
			userBirth = info.birthday;
			userSex = info.gender;
			userLocale = info.locale;
			
			if (info.email) 
			{
				if (StringUtil.isVaildEmail(info.email))
				{
					userEmail = info.email;
				}
				else 
				{
					userEmail = "";
				}
			}
			else 
			{
				userEmail = "";
			}
			trace("userEmail:", userEmail);
		}		
	
		
		public function set groups(val:int):void{
			_groups = val
		}
		
		/**
		 * 
		 * @return (0或1)&&(走完新手指引)为A类用户		 * 
		 */		
		public function get isAgroup():Boolean
		{
			var rBl:Boolean= (_groups == USER_GROUP_C || _groups == USER_GROUP_A) && !isShowTutorial;
			return rBl;
		}
		
		
		
	}

}