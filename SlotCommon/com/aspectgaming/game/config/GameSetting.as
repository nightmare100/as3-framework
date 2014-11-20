package com.aspectgaming.game.config
{
	import com.aspectgaming.game.config.reel.ReelInfo;
	import com.aspectgaming.game.config.reel.SpeedInfo;
	import com.aspectgaming.game.config.reel.WinLine;
	import com.aspectgaming.game.config.text.MessageBarInfo;
	import com.aspectgaming.game.constant.SlotGameType;
	import com.aspectgaming.game.core.IReelSpeicalRule;
	import com.aspectgaming.game.core.ISlotXmlParse;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.reel.ReelAction;
	import com.aspectgaming.game.manager.GameManager;
	import com.netease.protobuf.Message;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 游戏设置 
	 * game.set.xml数据解析 
	 * reel配置 
	 * Meter时间配置
	 * @author mason.li
	 * 
	 */	
	public class GameSetting
	{
		public static var isWinshowLoop:Boolean;
		
		public static var useWinTrack:Boolean = true;
		
		public static var scatterSymbloNum:uint = 12;
		
		/**
		 * 游戏是否支持 retrigger 默认不支持 
		 */		
		public static var hasRetrigger:Boolean = false;
		
		// add by zy tournament slot 是否要执行显示线逻辑
		public static var hasWinLine:Boolean = true;
		
		/**
		 * 播放Progressive 动画的延时 
		 */		
		public static var progressAnimationDelay:uint = 2;
		/**
		 * 播放FREE INTRO/OUTRO 动画的延时 
		 */		
		public static var freeAnimationDelay:uint = 3;
		
		/**
		 * 定值 关系POWER PLAY消耗的龙币 
		 */		
		public static var chipValue:Number = 0.001;
		
		/**
		 * 定值 关系POWER PLAY消耗的龙币 
		 */		
		public static var dragonDollarValue:Number = 0.2;
		
		public static const AUTO_PLAY_WIN_DELAY:uint = 2;
		public static const AUTO_PLAY_LOST_DELAY:uint = 1;
		
		public static var powerPlayStops:String;
		public static var betTimes:Number = 1;
		
		/**
		 * King Kich 小女孩 
		 */		
		public static var showGirlTimes:uint = 50;
		
		/**
		 * Online 专有字段 表示是否弹出金钱控制界面(金钱不够) 
		 */		
		public static var isCashOn:Boolean;
		
		/**
		 * 是否允许GAMBLE 
		 */		
		public static var isGambleOn:Boolean;
		
		/**
		 * PowerPlay 金钱变量 
		 */		
		public static var priceVariable:Number;
		
		public static var speedLv:uint = 1;
		public static var reelPos:Point;
		public static var betLineFilter:Array;
		public static var winLine:WinLine;
		public static var messageBarInfo:MessageBarInfo;
		
	
		public static function set reelRule(value:IReelSpeicalRule):void
		{
			_reelRule = value;
		}
		
		public static function getRuleAction(stops:Array):Vector.<ReelAction>
		{
			if (_reelRule)
			{
				return _reelRule.getSpeical(stops);
			}
			else
			{
				return null;
			}
		}
		
		public static function get dragonPlayNum():uint
		{
			var gameMgr:GameManager = GameGlobalRef.gameManager;
			return Math.ceil( priceVariable * (gameMgr.currentEachLineCash * gameMgr.betLineMax) * chipValue / dragonDollarValue );
		}
		
		public static function init(xml:XML):void
		{
			processReelBase(xml.gameSetting.reelXml.reels[0]);
			processReelSpeedInfo(xml.gameSetting.reelXml.setting[0]);
			processReelDetail(xml.gameSetting.reelXml.refReelStrip.ref);
			processPayLineInfo(xml.gameSetting.reelXml.payLine[0]);
			processWinLine(xml.gameSetting.reelXml.winLine[0]);
			processMessageBarInfo(xml.gameSetting.messageBar[0]);
			processBetLineFilter(xml.gameSetting.betLineFilter[0]);
			powerPlayStops = String(xml.gameSetting.reelXml.powerPlayStops.@value);
			
			if (xmlParse)
			{
				xmlParse.init(xml);
			}
		}
		
		/**
		 * 获取轮子元件总数 
		 * @return 
		 * 
		 */		
		public static function get baseSymbloLen():int
		{
			var result:int;
			for (var key:String in _reelInfo)
			{
				result += ReelInfo(_reelInfo[key]).symbolNum;  
			}
			return result;
		}
		
		/**
		 * 获取用于判断的轮子列数 (不包括第六列特殊轮子)
		 * @return 
		 * 
		 */		
		public static function get reelColume():int
		{
			var result:int;
			for (var key:String in _reelInfo)
			{
				if (checkFormalReel(key))
				{
					result++;
				}
			}
			return result;
		}
		
		/**
		 * 取轮子信息 
		 * @param key
		 * @return 
		 * 
		 */		
		public static function getReelInfo(key:String):ReelInfo
		{
			return _reelInfo[key];
		}
		
		
		/**
		 * 取轮子信息 
		 * @param key
		 * @return 
		 * 
		 */		
		public static function getReelInfoList():Vector.<ReelInfo>
		{
			var result:Vector.<ReelInfo> = new Vector.<ReelInfo>();
			for (var key:String in _reelInfo)
			{
				result.push(_reelInfo[key]);
			}
			return result;
		}
		
		/**
		 * 取LINE 对应 的SYMBOL 位置信息 
		 * @param idx 线Idx
		 * @return 
		 * 
		 */		
		public static function getLineInfo(idx:uint):Array
		{
			if (_lineInfo[idx])
			{
				var info:String = _lineInfo[idx];
				var result:Array = info.split(",");
				for (var i:uint = 0; i < result.length; i++)
				{
					result[i] = uint(result[i]);
				}
				return result;
			}
			else
			{
				return null;
			}
		}
		
		public static function getSpeedInfo(lv:int = - 1):SpeedInfo
		{
			lv = lv == -1 ? speedLv : lv;
			if (_speedInfo[lv.toString()])
			{
				return _speedInfo[lv.toString()];
			}
			else
			{
				return _speedInfo["0"];
			}
		}
			
			
		private static function processReelBase(xml:XML):void
		{
			reelPos = new Point(Number(xml.@x), Number(xml.@y));
			_reelInfo = {};
			for each (var info:XML in xml.reel)
			{
				_reelInfo[String(info.@name)] = new ReelInfo(info);
			}
		}
		
	
		private static function processReelSpeedInfo(xml:XML):void
		{
			_speedInfo = new Dictionary();
			for each (var data:XML in xml.reelSpeed)
			{
				_speedInfo[uint(data.@speedLv)] = new SpeedInfo(data);
			}
		}
		
		private static function processReelDetail(sortList:XMLList):void
		{
			for each (var xml:XML in sortList)
			{
				var type:String = String(xml.@type);
				
				for each (var v:XML in xml.value)
				{
					if (_reelInfo[String(v.@name)])
					{
						ReelInfo(_reelInfo[String(v.@name)]).setGameSort(String(v), String(v.@defValue), type);
					}
				}
			}
		}
		
		private static function processPayLineInfo(payLine:XML):void
		{
			_lineInfo = new Dictionary();
			for each (var data:XML in payLine.line)
			{
				_lineInfo[uint(data.@index)] = String(data);
			}
		}
		
		private static function processWinLine(xml:XML):void
		{
			winLine = new WinLine();
			winLine.isOutSide = Boolean(uint(xml.@outSide));
			winLine.thickness = uint(xml.@thickness);
			winLine.width = uint(xml.@width);
			winLine.height = uint(xml.@height);
		}
		
		private static function processMessageBarInfo(xml:XML):void
		{
			messageBarInfo = new MessageBarInfo();
			messageBarInfo.x = Number(xml.@x);
			messageBarInfo.y = Number(xml.@y);
			messageBarInfo.width = Number(xml.@width);
			messageBarInfo.height = Number(xml.@height);
			messageBarInfo.align = String(xml.@align);
			messageBarInfo.color = uint(xml.@color);
		}
		
		private static function processBetLineFilter(xml:XML):void
		{
			if(xml){
				var str:String = xml.toString();
				var strArray:Array;
				var rangeStr:String;
				//var rangeArray:Array;
				betLineFilter = new Array();
				
				strArray = str.split(",");
				for(var i:int; i<strArray.length; i++){
					if(strArray[i].indexOf("-") == -1){
						betLineFilter.push(int(strArray[i]));
					}else{
						rangeStr = strArray[i];
						var arr:Array = rangeStrToArray(rangeStr);
						betLineFilter = betLineFilter.concat(arr);
					}
				}
			}
			trace("betLineFilter:"+betLineFilter);
		}

		private static function rangeStrToArray(rangeStr:String):Array
		{
			if(rangeStr){
				var rangeArray:Array = new Array();
				var tempArr:Array = rangeStr.split("-");
				var min:int = int(tempArr[0]);
				var max:int = int(tempArr[1]);
				
				for(var j:int=11; j<max+1; j++){
					rangeArray.push(j);
				}
				return rangeArray;
			}
			return null;
		}
		
		public static function getMeterSecond(times:Number, isFreeGame:Boolean):Number
		{
			var idx:uint = getSoundIdx(times);
			if (isFreeGame)
			{
				return soundDurtionFree[idx - 1];
			}
			else
			{
				return soundDurtion[idx - 1];
			}
		}
		
		public static function getSoundIdx(times:Number):Number
		{
			var idx:uint;
			if (times == 0)
			{
				return -1;
			}
			else if (times <= 0.5)
			{
				idx = 1;
			}
			else if (times <= 1)
			{
				idx = 2;
			}
			else if (times <= 1.5)
			{
				idx = 3;
			}
			else if (times <= 2)
			{
				idx = 4;
			}
			else if (times <= 4)
			{
				idx = 5;
			}
			else if (times <= 6)
			{
				idx = 6;
			}
			else if (times <= 9)
			{
				idx = 7;
			}
			else if (times <= 20)
			{
				idx = 8;
			}
			else
			{
				idx = 9;
			}
			
			return idx;
		}
		
		/**
		 * 对应Metre的9种倍率声音长度 
		 */		
		public static var soundDurtion:Array = [1, 2, 2, 3, 7, 7, 10, 13, 14];
		
		/**
		 * 对应Metre的9种倍率声音长度  Free Game
		 */		
		public static var soundDurtionFree:Array = [1, 2, 2, 3, 7, 7, 10, 13, 14];
		
		/**
		 * 检测轮子是否 为展示的轮子 
		 */		
		public static var checkFormalReel:Function;
		
		/**
		 * 最大线数 
		 */		
		public static var maxLineNum:uint;
		
		private static var _reelInfo:Object;
		private static var _speedInfo:Dictionary;
		private static var _lineInfo:Dictionary;
		
		private static var _reelRule:IReelSpeicalRule;
		
		public static var xmlParse:ISlotXmlParse;
		
		public static function clear():void
		{
			checkFormalReel = null;
			maxLineNum = 0;
			_reelInfo = null;
			_speedInfo = null;
			_lineInfo = null;
			_reelRule = null;
			xmlParse = null;
			
			scatterSymbloNum = 12;
			hasRetrigger = false;
			progressAnimationDelay = 2;
			freeAnimationDelay = 3;
			chipValue = 0.001;	
			dragonDollarValue = 0.2;
			
			powerPlayStops = null;
			
			speedLv = 1;
			reelPos = null;
			
			winLine = null;
			messageBarInfo = null;

			hasWinLine = true;			
			betTimes = 1;		//set default value
			isWinshowLoop = false;

		}
	}
}