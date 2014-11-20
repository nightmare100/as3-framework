package com.aspectgaming.data.newplayerguide
{

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * author zy
	 * 用于存储 新手任务 stepList 下 的每一个 step 信息
	 * 
	 * */
	public class StepInfo
	{
		/** step id*/
		public var id:Number;
		/** 是否用遮罩*/
		public var useMask:Boolean;
		/** 原件列表*/
		public var symbolList:Vector.<GuildSymbolInfo>;
		/** 显示可点击矩形区域*/
		public var showAreaPosList:Vector.<GuildAreaInfo>;
		
		public var targetName:String;
		
		public var targetClass:Array;
		
		public var action:String;
		
		public var completeType:String;
		
		public var actionParms:String;
		
		public var actionNum:Number;
		
		public var jsonData:Object;
		
		public var trackpath:String;
		
		private var skips:Array = [];
		
		public var nextStep:int ;
		
		public function StepInfo(xml:XML, sid:Number)
		{
			id = sid;//xml.@id;	
			showAreaPosList = new Vector.<GuildAreaInfo>;
			symbolList = new Vector.<GuildSymbolInfo>;
			
			
			targetName = String(xml.@target);
			targetClass = String(xml.@cls) == null ? [] : String(xml.@cls).split(",");//[] 
			
			useMask = String(xml.@useMask) == "true" ? true : false;
			
			action = String(xml.@action);
			completeType = String(xml.@complete);
			actionParms = String(xml.@actionparms);
			actionNum = Number(xml.@actionNum);
			
			nextStep = Number(xml.@nextStep);
			
			skips=String(xml.@skip).split(",");
			trackpath = String(xml.@trackpath);
			
			for (var i:int = 0; i < xml.showAreaPosList.showAreaPos.length(); i++ )
			{
				showAreaPosList.push(new GuildAreaInfo(xml.showAreaPosList.showAreaPos[i]));
			}
			
			for (var j:int = 0; j < xml.symbolList.symbol.length(); j++)
			{
				symbolList.push(new GuildSymbolInfo(xml.symbolList.symbol[j]));
			}
			
			if (xml.jsonData && xml.jsonData[0])
			{
				trace(String(xml.jsonData[0]));
				jsonData = JSON.parse(String(xml.jsonData[0]));
			}
		}
		
		/** 判断是否完成当前这个 step*/
		public function isTargetHandler(target:Object):Boolean
		{
			return targetName == target.name || isEquipClass(getQualifiedClassName(target));
		}
		
		private function isEquipClass(clsName:String):Boolean
		{
			if (targetClass)
			{
				for each (var cls:String in targetClass)
				{
					if (cls && clsName.indexOf(cls) != -1)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 
		 * @return 步骤中有跳转的需求，( skip="okBtn,slotlobby,3") 
		 * 
		 * okBtn：触发对象名,slotlobby：指引列表，3：列表内步骤
		 * 
		 */		
		public function get skipInfo():Array{
			return skips!=null?skips:[];
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}