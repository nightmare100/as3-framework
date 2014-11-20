package com.aspectgaming.event {
	import com.aspectgaming.event.base.BaseEvent;
	
	import flash.events.Event;
	
	/**
	 * 大厅事件 
	 * @author Mason.Li
	 */
	public class LobbyEvent extends BaseEvent
	{
		public static const LOBBY_REGISTER_USER_FIRST:String = "registerUserFirst";
		public static const LOBBY_START_INIT:String = "startInit";
		public static const LOBBY_ASSETS_LOADER_INIT:String = "assetsLoaderInit";
		public static const LOBBY_INIT_LEADERBOARD:String = "initleaderboard";
		public static const LOBBY_INIT_MESSAGE_CLASS:String = "initmessageClass";
		
		public static const LOBBY_GUIDE_SHOW_VIEW:String = "LOBBY_GUIDE_SHOW_VIEW";

		
		public static const LOBBY_GET_SENDER_IDS:String = "getSenderIDs";
		
		public static const LOBBY_INIT_LOBBY_UI:String = "initLobbyUI";
		public static const LOBBY_PROCESS_INVITE_INFO:String = "processInviteInfo";
		public static const LOBBY_PROCESS_GOOGLE_COUNT:String = "processGoogleCount";
		
		public static const LOBBY_AFTER_UI_CREATE:String = "afterUiCreate";
		
		/**
		 * 奖励处理完毕后 初始化 msgbox模块 
		 */		
		public static const LOBBY_INIT_MESSAGEBOX:String = "messageboxInited";
		
		/**
		 * 解锁游戏 
		 */		
		public static const LOBBY_UNLOCK_GAME:String = "unlockGame";
		
		/**
		 * 更新Balance 
		 */		
		public static const LOBBY_UPDATE_BALANCE:String = "updateBalance";
		
		
		/**
		 * 内容页面切换通知 (从goto或scrollingMessage等切换页面)
		 */		
		public static const CONTENT_PAGE_CHANGED:String = "contentPageChanged";
		
		/**
		 * 主动切换页面消息(从content内部按钮或back按钮切换页面) 
		 */		
		public static const BANNER_CHANGE_PAGE:String = "bannerPageChanged";
		
		/**
		 * 礼物赠送者发生变化
		 */
		public static const ON_GIFT_SEND_LIST_CHANGED:String = "onGiftSendListChanged";
		
		/**
		 * 大厅进入游戏 
		 */		
		public static const LOBBY_TO_GAME:String = "lobbyToGame";
		
		/**
		 * 游戏回到大厅 
		 */		
		public static const GAME_BACK_TO_LOBBY:String = "gameBackToLobby";
		
		/**
		 * 进入Tourament 
		 */		
		
		public static const INTO_TOURAMENT:String = "intoTourment";
		
		/**
		 * 推出Tourament (模块事件) 
		 */		
		
		public static const EXIT_TOURAMENT:String = "exitTourment";
		
		
		
		/**
		 * 打开商店
		 */
		public static const SHOW_STORE:String = "showStore";
		
		/**
		 * 游戏 => 大厅通信 
		 */		
		public static const GAME_TO_LOBBY:String = "gameToLobby";
		
		/**
		 * 销毁游戏命令
		 */		
		public static const DISPOSE_GAME:String = "disposeGame";
		
		/**
		 * 销毁游戏模块 
		 */		
		public static const DISPOSE_GAME_MODULE:String = "disposeGameModule";
		
		/**
		 * 用户等级提升 
		 */		
		public static const USER_LEVEL_UP:String = "userLevelUp";		
		
		
		/**
		 * 当前荣誉信息已更新(取得服务端数据)
		 */
		public static const LOYALTY_UPDATED:String = "loyalty_updated";
		
		/**
		 * 荣誉等级上升
		 */
		public static const LOYALTY_LEVEL_UP:String = "loyaltyLevelUp";		
		
		/**
		 * 荣誉等级下降
		 */
		public static const LOYALTY_LEVEL_DOWN:String = "loyaltyLevelDown";		
		
		
		
		/**
		 * 发送升级NewAcitivy协议 
		 */		
		public static const SEND_LEVEL_UPINFO:String = "sendLevelUpInfo";	
		
		/**
		 * 预加载 游戏图片 
		 */		
		public static const PRELOAD_LOBBY_PIC:String = "preloadLobbyPic";
		
		/**
		 * 更新Balance逻辑 由消息模块派发 
		 */		 
		public static const PLAY_STAR_ANIMATION:String = "msgUpdateBalance";	
		
		/**
		 * update myslot 
		 */		 
		public static const UPDATE_MY_SLOT:String = "msgUpdateMyslot";
		
		/**
		 * ScrollMessage重启 
		 */		 
		public static const RESTART_SCROLL_MESSAGE:String = "restartScrollMessage";
		
		/**
		 * LeaderBoard重定时 
		 */		
		public static const LEADER_BOARD_RETICK:String = "leaderBoardRetick";
		
		/**
		 * 更新用户Detail (BALANCE DRAG EXP) 
		 */		
		public static const UPDATE_USER_INFO:String = "updateUserInfo";
		
		/**
		 * like按钮点击 
		 */		
		public static const LIKE_GAME:String = "likeGame";
		
		public static const ON_FACEBOOK_BUYCHIPS_END:String = "onFaceBookBuyChipsEnd";
		
		public static const ON_FACEBOOK_BUYCHIPS_SUCCESS:String = "onFaceBookBuyChipsSuccess";
		
		public static const REFLUSH_TIME_REWARD:String = "reflushTimeReward";
		
		public static const TUTORIAL_CLOSED:String = "TutorialClosed";
		
		public static const REQUEST_PAYMENT:String = "requestPayment";
		
		public static const LOBBY_SHOW_LEADERBOARD:String = "lobbyShowLeaderBoard";
		
		public static const HIDE_SHOW_MSGBOX:String = "hideShowMsgbox";
		
		public static const RECONNECT_SHOW:String = "reconnectShow";
		
		public static const DISPOSE_BUY_CHIPS_VIEW:String = "diposeBuyChips";
		
		public static const BUNDLESALE_TIMECOUNT:String = "boundleSaleTime";
		
		/**
		 * 执行LoadBundleAssetCommand加载bundle sale素材
		 */
		public static const LOAD_BUNDLE_ASSET:String = "loadBundleAsset";
		/**
		 * bundle sale的美术素材加载完毕
		 */
		public static const BUNDLE_ASSET_LOADED:String = "bundleAssetLoaded";
		
		public static const LOAD_PROMO_ASSET:String = "loadPromoAsset";
		public static const PROMO_ASSET_LOADED:String = "promoAssetLoaded";
		
		/**
		 *refresh leaderboard
		 * jackpot 退出时候 直接切换到 jackpot页面 
		 */		
		public static const LOBBY_REFRESH_LEADERBOARD:String = "lobbyRefreshLeaderBoard";
		/**
		 * TIME BONUS 更新 
		 */		
		public static const ON_TIMEBONUS_UPDATE:String = "timebonusupdate";
		
		/**
		 * 新手引导结束
		 */
		public static const GUIDE_END:String = "guildEnd";
		
		/**
		 * 新手引导加载资源
		 */
		public static const GUIDE_LOAD_ASSET:String = "GUILD_LOAD_ASSET";
		
		
		/** 添加新手模块*/
	//	public static const ADD_NEW_PLAYER_INTRO:String = "addNewPlayerIntroduction";
		
		public function LobbyEvent(type:String, data:*=null, content:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new LobbyEvent(type, _data, _content);
		}
		
		
	}
	
}