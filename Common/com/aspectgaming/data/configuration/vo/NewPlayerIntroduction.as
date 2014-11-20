package com.aspectgaming.data.configuration.vo
{
	import com.aspectgaming.data.newplayerguide.StepInfo;
	import com.aspectgaming.data.newplayerguide.StepListInfo;
	import com.aspectgaming.utils.URLUtil;
	
	import flash.utils.Dictionary;

	public class NewPlayerIntroduction
	{
		private var _taskDic:Dictionary;
		/** 总共任务数*/
		private var _taskLen:int;
		
		public function NewPlayerIntroduction(xml:XMLList) 
		{
			_taskDic = new Dictionary;
			parseData(xml);
		}
		
		public function parseData(xml:XMLList):void
		{
			// 存储大步骤  字典从 0 开始
			for (var i:uint = 0; i < xml.stepList.length(); i++ )
			{
				var stepList:StepListInfo = new StepListInfo(xml.stepList[i])
				
				_taskDic[stepList.listName] =stepList ;		 	
			}
			_taskLen = xml.stepList.length();
			//trace(taskDic["task1"]);
		}
		/** 验证配置StepList是否有此任务*/
		public function hasTaskStepList(name:int):Boolean
		{
			return _taskDic[name] ? true:false;
		}
		
		/** 获取每个任务stepList长度  即当前steplist 的 step 步数*/	
		public function getStepListLength(name:int):int
		{
			return hasTaskStepList(name) ? (_taskDic[name] as StepListInfo).stepVec.length : 0; 
		}
		
		/** 获取stepList*/
		public function getStepListInfo(name:int):StepListInfo
		{
			return hasTaskStepList(name) ? _taskDic[name] : null;
		}
		
		/** 获取当前step 信息*/
		public function getStepInfo(stepId:int, stepListName:int):StepInfo
		{
			// 查询
			if (!hasTaskStepList(stepListName))
			{
				return null;
			}
			for (var i:uint = 0; i < getStepListLength(stepListName); i++)
			{
				if ((_taskDic[stepListName] as StepListInfo).stepVec[i].id == stepId )
				{
					return (_taskDic[stepListName] as StepListInfo).stepVec[i];
				}
			}						
			return null;
		}
		
		/**
		 * @return 返回当前步骤开始所需的资源
		 */		
		public function getResList(currentStep:int=0):Array
		{
			var resList:Array=[];
			for each(var list:StepListInfo in _taskDic)
			{
				var url:String = URLUtil.getGuideSwf(list.listRes);
				if(resList.indexOf(url) < 0 && list.listRes != ""){
					resList.push(url);
				}			
			}
			return resList;
		}
				
	}
}