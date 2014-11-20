package com.aspectgaming.model 
{
	import com.aspectgaming.constant.global.LobbyGameConstant;
	import com.aspectgaming.data.client.ProgressiveData;
	import com.aspectgaming.data.configuration.Configuration;
	import com.aspectgaming.data.configuration.LevelsRuinConfiguration;
	import com.aspectgaming.data.configuration.game.GameCellInfo;
	import com.aspectgaming.data.configuration.game.PageInfo;
	import com.aspectgaming.data.configuration.game.constant.PageDefined;
	import com.aspectgaming.data.vo.FacebookUser;
	import com.aspectgaming.data.vo.LevelInfo;
	import com.aspectgaming.data.vo.SlotCustomized;
	import com.aspectgaming.data.vo.TimeReward;
	import com.aspectgaming.data.vo.TotalBalance;
	import com.aspectgaming.event.LobbyEvent;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.net.vo.MissionDTO;
	import com.aspectgaming.utils.constant.TickConstant;
	import com.aspectgaming.utils.tick.Tick;
	
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleActor;
	
	/**
	 * 用户大厅信息
	 * @author Mason.Li
	 */
	public class LobbyModel extends ModuleActor 
	{
		public var isInit:Boolean;				//login时弹出窗口队列处理完毕
		public var isGameLoading:Boolean;
		
		/**
		 *  个人信息
		 */		
		public var facebookUser:FacebookUser;		
		
		/**
		 *  Balance信息
		 */		
		public var totalBalance:TotalBalance;			
		
		/**
		 * 等级信息
		 */		
		public var levelInfo:LevelInfo;	
		
		/**
		 * 玩家身上的任务列表 
		 */		
		public var missions:Vector.<MissionDTO>;
		
		
		
		/**
		 * Progressive 信息 
		 */		
		public var progressiveData:ProgressiveData;

		public var currentLeaderBoardDate:Date;
		public var lastLeaderBoardDate:Date;
		
		public var paymentId:Number;
		public var promoAssetDomain:ApplicationDomain;	//当前商店素材程序域
		public var promoAssetLoaded:Boolean;
		/**
		 * CollectTime Reward信息 
		 */		
		public var timeReward:TimeReward;
		//public var leaderBoardRank:LeaderBoardRank;
		
		//记录好友 礼物发送的发送状态
		private var _hasSendList:Array = [];
		//自定义SlotData
		public var slotCustomizedData:SlotCustomized;
		
		
		
		private var _playGameIds:Array;	

		
		public var bundleAssetLoadStarted:Boolean;
		public var bundleAssetLoaded:Boolean;
		public var hasLevelModule:Boolean
		/**
		 *bundle 销售剩余时间 
		 */		
		private var _bundleType:String;
		private var _bundleLeftTime:Number;
		private var _bundleInfo:Array;
		
		private var _tournamentLeftTime:Number = 0;
		
		public function LobbyModel() 
		{
			init();
		}

		/**
		 * 玩过的游戏ID 
		 */
		public function get playGameIds():Array
		{
			
			return _playGameIds;
		}

		/**
		 * @private
		 */
		public function set playGameIds(value:Array):void
		{
			_playGameIds = Configuration.gameListConf.filterSlotGameIDs(value);
			filterLockGameIDs();
		}
		
		/**
		 * 过滤所有锁住的游戏 
		 * 
		 */		
		private function filterLockGameIDs():void
		{
			var lockedIds:Array = lockGameIds;
			for (var i:uint = 0; i < _playGameIds.length; i++)
			{
				if (lockedIds.indexOf(int(_playGameIds[i])) != -1)
				{
					_playGameIds.splice(i--, 1);
				}
			}
		}

		/**
		 * 锁住的游戏ID 
		 */
		public function get lockGameIds():Array
		{
			var pageInfo:PageInfo = Configuration.gameListConf.getPageInfoByName(PageDefined.Slots_Page);
			var result:Array = [];
			for (var i:uint = 0; i < pageInfo.gameInfos.length; i++)
			{
				var gameCell:GameCellInfo = pageInfo.gameInfos[i];
				if (gameCell.isLocked)
				{
					result.push(int(gameCell.normalGameID));
				}
			}
			
			return result;
		}

		/**
		 *bundle 3 个 item 信息 
		 */
		public function get bundleInfo():Array
		{
			return _bundleInfo;
		}

		/**
		 * @private
		 */
		public function set bundleInfo(value:Array):void
		{
			_bundleInfo = value;
		}

		/**
		 *捆绑销售剩余时间 
		 */
		public function get bundleLeftTime():Number
		{
			return _bundleLeftTime;
		}

		/**
		 * @private
		 */
		public function set bundleLeftTime(value:Number):void
		{
			_bundleLeftTime = value;
			
			if (_bundleLeftTime > 0)
			{
				Tick.addTimeInterval(function():void{
					if (--_bundleLeftTime < 0)
					{
						Tick.removeTimeInterval(TickConstant.BUNDLE_LEFTTIME);
					}
					dispatchToModules(new LobbyEvent(LobbyEvent.BUNDLESALE_TIMECOUNT,_bundleLeftTime));
				}, 1, TickConstant.BUNDLE_LEFTTIME);
			}
			
		}

		/**
		 * 设置TIMEBONUS  
		 * @param value
		 * 
		 */		
		public function set timeBonus(value:Number):void
		{
			timeReward.rewardAmount = value;
			dispatchToModules(new LobbyEvent(LobbyEvent.ON_TIMEBONUS_UPDATE));
		}
		
		public function set tournamentLeftTime(value:Number):void
		{
			_tournamentLeftTime = value;
			if (_tournamentLeftTime > 0)
			{
				Tick.addTimeInterval(function():void{
					if (--_tournamentLeftTime < 0)
					{
						Tick.removeTimeInterval(TickConstant.TOURAMENT_LEFTTIME);
					}
				}, 1, TickConstant.TOURAMENT_LEFTTIME);
			}
		}
		
		/**
		 *当为true 时候 是 79 83 84  正常的 给钱
		 *当为false 时候 是给时间
		 * @return 
		 * 
		 */		
		public function get isNormalTouramentID():Boolean
		{
			return _tournamentLeftTime < 0;
		}

		public function saveSendList(arr:Array, isClearOld:Boolean = false):void
		{
			var changedNum:uint = 0;
			for (var i:uint = 0 ; i < arr.length; i++ )
			{
				if (_hasSendList.indexOf(String(arr[i])) == -1)
				{
					_hasSendList.push(String(arr[i]));
					changedNum++;
				}
			}
			
			if (isClearOld)
			{
				for (var j:uint = 0; j < _hasSendList.length; j++)
				{
					if (arr.indexOf(Number(_hasSendList[j])) == -1 && arr.indexOf(_hasSendList[j]) == -1)
					{
						_hasSendList.splice(j, 1);
						j--;
						changedNum++;
					}
				}
			}
			
			if (changedNum > 0)
			{
				dispatchToModules(new LobbyEvent(LobbyEvent.ON_GIFT_SEND_LIST_CHANGED));
			}
		}
		
		public function getSendList():Array
		{
			return _hasSendList;
		}
		
		/**
		 * 是否为低balance 
		 * @return 
		 * 
		 */		
		public function get isLowerBalance():Boolean
		{
			return Configuration.general.balanceLimit > 0 && totalBalance.totalBalance <= Configuration.general.balanceLimit;
		}
		/**
		 *hight limit 新规则 根据 vip等级  或 钱
		 * @return 
		 * 
		 */		
		public function get canIntoHighLimit():Boolean
		{
			return LevelsRuinConfiguration.enterHighLimits || totalBalance.totalBalance >= Configuration.general.highLimit;
		}
		
		public function get bundleType():String 
		{
			return _bundleType;
		}
		
		public function set bundleType(value:String):void 
		{
			_bundleType = value;
		}
		
		/**
		 * 是否超过拥有指定数量的龙币 
		 * @param dollar
		 * @return 
		 * 
		 */		
		public function isMoreThanDragDollars(dollar:Number):Boolean
		{
			return totalBalance.dragonDollars >= dollar;
		}
		
		public function checkIsSend(uid:String):Boolean
		{
			return _hasSendList.indexOf(uid) != -1;
		}
		
		/**
		 * 把玩过的游戏插入到最前 
		 * @param id
		 * 
		 */		
		public function parsePlayGameIds(id:String):void
		{
			if (playGameIds.indexOf(id) != -1)
			{
				playGameIds.splice(playGameIds.indexOf(id) , 1);
				playGameIds.unshift(id); 	
			}
			else
			{
				playGameIds.unshift(id);
			}
		}
		
		private function init():void 
		{
			facebookUser = new FacebookUser();
			totalBalance = new TotalBalance();
			//	dailyBonus = new DailyBonus();
			levelInfo = new LevelInfo();
			timeReward = new TimeReward();
			//leaderBoardRank = new LeaderBoardRank();
			
			progressiveData = new ProgressiveData();
			slotCustomizedData = new SlotCustomized();
		}
		
		public function unLockGame(gid:Array, amount:Number, dragons:Number):void
		{
			totalBalance.totalBalance = amount;
			totalBalance.dragonDollars = dragons;
			
			//model解锁
			Configuration.gameListConf.unlockGame(gid[0]);
			
			//界面解锁
			dispatchToModules(new LobbyEvent(LobbyEvent.LOBBY_UNLOCK_GAME, null, gid[0]));
			
			//Balance更新
			dispatchToModules(new LobbyEvent(LobbyEvent.UPDATE_USER_INFO));
		}
	}
}