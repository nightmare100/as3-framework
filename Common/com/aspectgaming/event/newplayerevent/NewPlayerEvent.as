package com.aspectgaming.event.newplayerevent
{
	import com.aspectgaming.event.base.BaseEvent;
	
	public class NewPlayerEvent extends BaseEvent
	{
		
		/**
		 * 触发一个指引 
		 */		
		public static const TRIGGER_GUIDE:String = "triggerGuide";
		/**
		 * 指引配置假UI显示 
		 */		
		public static const GUIDE_UPDATE_UI:String = "guideUpdateUI";
		
		/** 当前小步骤 step完成*/
		public static const CURRENT_STEP_COMPLETE:String = "currentStepComplete"; 
		/** 当前大步骤 steplist完成*/
		public static const CURRENT_STEPLIST_COMPLETE:String = "currentStepListComlete";
		/** 当前大步骤 steplist开始*/
		public static const CURRENT_STEPLIST_START:String = "currentStepListStart";
		/** 销毁指引模块 */
		public static const DEPOSE_GUIDE:String="DEPOSE_GUIDE";
		
		/** 新手指导 结束*/
		public static const INTRO_COMPLETE:String = "newPlayerIntroComplete";
		/** 执行XML 里 action操作
		 * 
		 *  data
		 * 	obj.completeType = "click";
		 *	obj.e = e;
		 *652	obj.currentStepInfo = getCurrentStepInfo(); 
		 * */
		public static const TAKE_ACTION:String = "takeAction";
		
		public function NewPlayerEvent(type:String, data:*=null, content:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
		}
	}
}