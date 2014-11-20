package com.aspectgaming.globalization.managers
{
	//import com.aspectgaming.constant.CoinType;
	import com.aspectgaming.constant.GuideConfig;
	import com.aspectgaming.constant.JSMethodType;
	import com.aspectgaming.constant.TrackPath;
	import com.aspectgaming.data.configuration.vo.NewPlayerIntroduction;
	import com.aspectgaming.data.newplayerguide.StepInfo;
	import com.aspectgaming.data.newplayerguide.StepListInfo;
	import com.aspectgaming.event.LobbyEvent;
	import com.aspectgaming.event.newplayerevent.NewPlayerEvent;
	import com.aspectgaming.globalization.module.ModuleDefine;
	import com.aspectgaming.net.vo.MissionDTO;
	import com.aspectgaming.net.vo.PlayerDTO;
	import com.aspectgaming.notify.constant.NotifyType;
	import com.aspectgaming.utils.ExternalUtil;
	import com.aspectgaming.utils.NumberUtil;
	import com.aspectgaming.utils.tick.FrameRender;
	import com.aspectgaming.utils.tick.Tick;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	
	
	[Event(name="currentStepComplete",type="com.aspectgaming.event.newplayerevent.NewPlayerEvent")]
	[Event(name="currentStepListComlete",type="com.aspectgaming.event.newplayerevent.NewPlayerEvent")]
	[Event(name="newPlayerIntroComplete",type="com.aspectgaming.event.newplayerevent.NewPlayerEvent")]
	/**
	 * 新手引导管理 
	 * @author anson
	 * 
	 */	
	public class NewPlayerGuidManager
	{
		
		private static var INIT_ID:int;
		/**新手引导配置*/
		private static var _newIntroduction:NewPlayerIntroduction;

		private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
		/** xml 配置 step id 从 0*/
		private static var _currentStep : int;
		/**taskDic 从 0  开始*/
		private static var _currentGuideId : int;		

		private static var _isNewPlayer:Boolean;
		
		private static var _currentStepInfo:StepInfo;
		
		public function NewPlayerGuidManager()
		{
			
		}
		/**
		 * 
		 * @return 主要针对UI操作
		 * 
		 */		
		public static function get isInGuild():Boolean
		{			
			return ModuleManager.isModuleInShow(ModuleDefine.GuildModule);
		}
		/**
		 * 
		 * @return 主要针对新手玩家的特殊数据处理
		 * 
		 */		
		public static function get isInNewPlayerGuide():Boolean{
			return _isNewPlayer;
		}
		
		/**
		 * 
		 * @param $currentGuideId
		 * 
		 * 需要指引的玩家初始
		 * 
		 */		
		public static function init($currentGuideId:int):void{
			_currentGuideId = $currentGuideId;			
			if ( _currentGuideId < GuideConfig.STEP_4)
			{	
				_isNewPlayer = true;
			}
			_eventDispatcher.addEventListener(NewPlayerEvent.TRIGGER_GUIDE, onGuideTrigger);					
		}
		
		

		/** 记录新手引导开始*/
		public static function start($id:int, $step:int=0):void
		{

			INIT_ID			= $id;
			_currentGuideId 	= $id;
			_currentStep 	= $step;
				
			TrackManager.path = TrackPath.FTUE;				
			LayerManager.stage.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			LayerManager.stage.addEventListener(MouseEvent.MOUSE_OVER, mouseClickHandler);
			initUI();				
			nextStep();				
			ExternalUtil.call(JSMethodType.SHOW_FOOT, false);

	
		}
		
		private static function onGuideTrigger(evt:NewPlayerEvent):void{

			if(evt.data == _currentGuideId)
			{
				if (ClientManager.lobbyModel.isInit)
				{
					doGuildStep();
				}
				else
				{
					//先走 奖励流程 走完 之后 走引导
					FrameRender.addRender(waittingForPopUp);
				}
			}			
			
			function waittingForPopUp():void
			{
				if (NotifyManager.getNotifyLen(NotifyType.NOTIFY_VIEW) == 0)
				{
					FrameRender.removeRender(waittingForPopUp);
					doGuildStep();
				}
			}
			
			function doGuildStep():void
			{
				ModuleManager.showModule(ModuleDefine.GuildModule, LayerManager.topLayer);
				NewPlayerGuidManager.start(_currentGuideId);
			}
		}		
		
		
		
		private static function initUI():void{
			if(getStepListInfo(_currentGuideId)!=null){
				var tmpPDTO:PlayerDTO=getStepListInfo(_currentGuideId).playerDTO;			
			}			
			
			dispatchEvent(new LobbyEvent(LobbyEvent.LOBBY_GUIDE_SHOW_VIEW));
			dispatchEvent(new NewPlayerEvent(NewPlayerEvent.GUIDE_UPDATE_UI,tmpPDTO));
		}		

		
		
		/** 引导结束*/
		public static function end():void
		{
			TrackManager.sendTrackPath(TrackManager.path + TrackPath.FTUE_FINISH);
			LayerManager.stage.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			ClientManager.lobbyModel.facebookUser.isShowTutorial = false;			
			ExternalUtil.call(JSMethodType.SHOW_FOOT, true);
		}

		public static function isInStepList(name:String, idx:int = -1):Boolean
		{
			var stepList:StepListInfo = getStepListInfo(_currentGuideId);
			if (stepList.listName == name)
			{
				if (idx == -1)
				{
					return true;
				}
				else
				{
					return idx == _currentStep;
				}
			}
			
			return false;
		}
		
		/** 鼠标点击监听
		 *  dispatch 事件对象。 当前步骤
		 * */	
		private static function mouseClickHandler(e:MouseEvent = null):void
		{
			var obj:Object = {};
			obj.actionEventTarget = e;
			obj.currentStepInfo = _currentStepInfo; 			
			
			trace(e.target.name);
			if(_currentStepInfo != null)
			{				
				dispatchEvent(new NewPlayerEvent(NewPlayerEvent.TAKE_ACTION, obj,e.type));								

			}
		}
				
		/**
		 * 查询下一部 是否存在 nextStep 跳步 
		 * 
		 */		
		public static function checkWaitStep():void
		{

		}
		
	
		
	
		
		
		
		
		/**
		 * @return 返回当前的指引大步骤
		 */		
		public static function get currentGuideId():int{
			return _currentGuideId;
		}
		
	
		
		
		/** 
		 * 
		 * 指引显示
		 * 
		 * */
		public static function nextStep():void
		{			
			
			// 下一step 小步骤		
			/*if (_isInGuild) // 不是第一次
			{
				sendStepTrack();
			}*/
			
			_currentStepInfo=_newIntroduction.getStepInfo(_currentStep, _currentGuideId);		
			
			if(_currentStepInfo!=null&&depend){
				dispatchEvent(new NewPlayerEvent(NewPlayerEvent.CURRENT_STEP_COMPLETE, _currentStepInfo)); 
			}else{
				//如果新打开步骤，未满足数据条件，销毁模块，下将进游戏再从保存步骤启动
				dispatchEvent(new NewPlayerEvent(NewPlayerEvent.DEPOSE_GUIDE));
				end();
			}
				
		}
		
		
		
		/**
		 * 指引满足条件，修改数据
		 * 
		 */		
		public static function stepComplete():void{
			
			if (currendStepIsEnd)
			{
				dispatchEvent(new NewPlayerEvent(NewPlayerEvent.CURRENT_STEPLIST_COMPLETE));
				_currentGuideId = getStepListInfo(_currentGuideId).openId;
				_currentStep = 0;
			}
			else
			{				
				_currentStep++;		
			}
			
			
			if (_currentStep==0){
				//大步骤开始，让服务器记录新的任务
				if(_currentGuideId!=INIT_ID){
					var missionDTO:MissionDTO=new MissionDTO();
					missionDTO.missionId=_currentGuideId.toString();
					missionDTO.subMissionId=_currentStep.toString();				
				}				

				if(getStepListInfo(_currentGuideId)!=null){
					var tmpPDTO:PlayerDTO=getStepListInfo(_currentGuideId).playerDTO;	
					dispatchEvent(new NewPlayerEvent(NewPlayerEvent.GUIDE_UPDATE_UI,tmpPDTO));
				}			
				dispatchEvent(new NewPlayerEvent(NewPlayerEvent.CURRENT_STEPLIST_START,missionDTO));
				
				if (hasUndoneNewPlayerTask)
				{			
					//如果已过新手任务，则提交服务器
					dispatchEvent(new NewPlayerEvent(NewPlayerEvent.INTRO_COMPLETE));
					_isNewPlayer=false;

				}
			}
			
			/*if(_currentGuideId == 0){
				trace("任务结束");
				dispatchEvent(new NewPlayerEvent(NewPlayerEvent.DEPOSE_GUIDE));
				_eventDispatcher.removeEventListener(NewPlayerEvent.TRIGGER_GUIDE,onGuideTrigger);		

			}*/
			nextStep();
			
		}
		
		
		private static function get currendStepIsEnd():Boolean{
			var stepListLength:int = getStepListLength(_currentGuideId)-1;
			return _currentStep >=　stepListLength;
			
		}
		
		
		
		private static function get depend():Boolean{
			
			var dependModule:String=getStepListInfo(_currentGuideId).dependAtModule;
			if(dependModule==""){
				return true;
			}else{
				return ModuleManager.isModuleInShow(dependModule) && getGuideDependData()
			}
			
			//返回条件步骤条件依赖
			function getGuideDependData():Boolean{
				
				switch(_currentGuideId){
					case GuideConfig.STEP_4:{
						return GuideConfig.STEP_4_DEPEND;
					}break;
					
					case GuideConfig.STEP_5:{
						//龙币足够解锁
						return true;
					}break;
					
				}
				return false;				
			}
		}
		
		
		/**
		 * 
		 * @return 当前操作后还有下一步要触发
		 * 
		 */		
		private static function get hasUndoneTask():Boolean{
			
			if(getStepListInfo(_currentGuideId)!=null&&getStepInfo(_currentGuideId,_currentStep)!=null){
				return true
			}else{
				return false;
			}
		}
		
		/**
		 * 
		 * @return 新手任务未完成
		 * 
		 */		
		private static function get hasUndoneNewPlayerTask():Boolean{
			
			return _currentGuideId == GuideConfig.STEP_4;//getStepListInfo(currentTaskId).listName=="4"/*&&!ClientManager.lobbyModel.facebookUser.isShowTutorial*/;
			
		}
		
		
		public static function parseNewPlayer(xml:XML):void
		{
			var newIntroXML:XMLList = xml.NewIntroduction;
			
			_newIntroduction = new NewPlayerIntroduction(newIntroXML);
		}
		
		/** 获取当前step*/
		public static function getCurrentStepInfo():StepInfo
		{			
			return _currentStepInfo;
		}
		
		/** 获取下个step*/
		private static function getNextStepInfo():StepInfo
		{
			return _newIntroduction.getStepInfo(_currentStep, _currentGuideId+1);
		}
		
		/** 获取指定的step信息*/
		private static function getStepInfo(stepListName:int, stepId:int):StepInfo
		{
			return _newIntroduction.getStepInfo(stepId, stepListName);
		}
		
		/** 获取指定的 steplist*/
		private static function getStepListInfo(taskId:int):StepListInfo
		{
			return _newIntroduction.getStepListInfo(taskId);
		}
		
		/** 获取当前steplist 的step步骤长度*/
		private static function getStepListLength(stepListName:int):int
		{
			return _newIntroduction.getStepListLength(stepListName);
		}
		
		
		/**
		 * 设置进度 
		 * @param stepListName 进度名称
		 * @param stepId 当前进度中的 步骤
		 * 
		 */		
		private static function setTaskProgress(stepListId:int, stepId:int):void
		{
			_currentStep = stepId;
			_currentGuideId = stepListId;
		}
		
		
		
		
		
		/**事件收发器 任务步骤*/
		public static function addEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.addEventListener(type, listener);
		}
		
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			_eventDispatcher.removeEventListener(type, listener);
		}
		
		public static function dispatchEvent(evt:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(evt);
		}
		
		private static function sendStepTrack():void
		{
			var stepInfo:StepInfo = getCurrentStepInfo();
			if (stepInfo.trackpath == TrackPath.FTUE_PLAYTOTRIGGERBONUS)
			{
				TrackManager.sendTrackPath(TrackManager.path + TrackPath.FTUE_PLAYTOTRIGGERBONUS);
				TrackManager.sendTrackPath(TrackManager.path + TrackPath.FTUE_BONUSGAME);
			}
			else if (stepInfo.trackpath == TrackPath.FTUE_SKIP)
			{
				TrackManager.sendTrackPath(TrackManager.path + TrackPath.FTUE_SKIP);
	
			}
			else if (stepInfo.trackpath.length > 0)
			{
				TrackManager.sendTrackPath(TrackManager.path + stepInfo.trackpath);
			}			
		}
		
		
		/**
		 * 
		 * @return 返回当前步骤开始需要加载的资源
		 * 
		 */		
		static public function getResList():Array{			
			return _newIntroduction.getResList(_currentGuideId);
		}
				
		
		
	}
}