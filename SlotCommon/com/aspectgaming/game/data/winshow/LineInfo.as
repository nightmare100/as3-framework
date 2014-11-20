package com.aspectgaming.game.data.winshow
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.reel.ReelInfo;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.config.text.LanguageReplaceTag;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * 单条线的信息 
	 * @author mason.li
	 * 
	 */	
	public class LineInfo
	{		
		//[Add by Kumo for Sticky Wild.*****]
		public static var IsStickyWildMode : Boolean;
		//[Add by Kumo for Sticky Wild.*****]
		public var lineIndex:uint;
		
		/**
		 * 原始该线元件分布 
		 */		
		public var sourceList:Array;
		
		/**
		 * 中奖的位置 
		 */			
		
		public var linePos:Array;
		public var lineWin:Number;
		
		public var lineWinTime:uint;
		
		public var isSpeical:Boolean;
		
		/**
		 * 是否为Scatter 
		 */		
		public var isScatter:Boolean;
		
		/**
		 * 当前线条实例 
		 */		
		public var instance:DisplayObject;
		
		public var symblos:Vector.<SymbloInfo>;
		
		private var _customMsg:String;
		
		/**同类型线的倍数 用于显示 234way
		 * add by zy
		 * */
		public var multipleLine:int = 1;
		
		public function get customMsg():String
		{			
			return _customMsg;
		}
		
		/**
		 * @private
		 */
		public function set customMsg(value:String):void
		{
			_customMsg = value;
			
			var symbloList:Array = [];
			var len:int =  maxReelIndex(symblos); // symblos.length>5?5:symblos.length;
			for (var i:uint = 0; i < len; i++)
			{
				symbloList.push("[" + GameAssetLibrary.symbolLibrary.getSymbloAdvName(symblos[i].name) + "]");
			}
			_customMsg = _customMsg.replace(LanguageReplaceTag.SYMBOL, symbloList.join(""));
			
			if (multipleLine>1)
			{
				var multipleTxt:String = "x " + multipleLine;
				_customMsg =  _customMsg.replace(LanguageReplaceTag.MULTIPLE, multipleTxt);
			}
			else
			{
				_customMsg =  _customMsg.replace(LanguageReplaceTag.MULTIPLE, "");	
			}
			_customMsg = _customMsg.replace(LanguageReplaceTag.CREDIT , lineWin * multipleLine);
		}
		
		/**返回symbol中最长的 reelIndex*/
		private function maxReelIndex(s:Vector.<SymbloInfo>):Number
		{
			var re:Number = 0;
			for each(var o:SymbloInfo in s )
			{
				o.reelIndex + 1 > re ? re = o.reelIndex + 1 : re;
			} 
			return re;
		}
		
		
		public function get symbloRects():Vector.<Rectangle>
		{
			var result:Vector.<Rectangle>;
			
			if (symblos)
			{
				result = new Vector.<Rectangle>(symblos.length);
				for (var i:uint = 0; i < symblos.length; i++)
				{
					result[i] = symblos[i].pos;
				}
			}
			
			return result;
		}
		
		public function showLine():void
		{
			if (symblos)
			{
				for each (var sym:SymbloInfo in symblos)
				{
					if (sym.displayObject)
					{
						sym.displayObject.visible = true;
					}
				}
			}
		}
		
		/**
		 * 确定中奖元素的 位置 和 名称
		 * @param arr stops数组
		 *  
		 */		
		public function setup(stops:Array):void
		{
			symblos = new Vector.<SymbloInfo>();
			var i:uint;
			
			//[Add by Kumo for Sticky Wild.*]
			var maskStr : String  = "";
			var nextMask : int = 0;
			//trace("GameGlobalRef.freeGameInfo.mathSpecificParams============>"+GameGlobalRef.freeGameInfo.mathSpecificParams);
			if (GameGlobalRef.freeGameInfo.mathSpecificParams)
			{
				nextMask = parseInt(GameGlobalRef.freeGameInfo.mathSpecificParams.NextFreeGameStickyWildMask);
				
				if (nextMask > 0)
				{
					maskStr = nextMask.toString(2);
					IsStickyWildMode = true;
				}
				else
				{
					IsStickyWildMode = false;
				}
				
				//for debug.
				//var maskArr : Array = (maskStr.split("")).reverse();
				//var traceStr : String = "";
				//for (var k : int = 0; k < maskArr.length; k++)
				//{
				//traceStr += maskArr[k] + "   ";
				//if (k != 0 && (k + 1) % 5 == 0) traceStr += "\n";
				//}
				//trace("=======================================================");
				//trace(traceStr);
				//trace("=======================================================");
			}
			else
			{
				IsStickyWildMode = false;
			}
			//[Add by Kumo for Sticky Wild.*]
			if (linePos.length <= GameSetting.reelColume)
			{
				//234way
				if (isScatter)
				{
					for (i = 0; i < linePos.length; i++)
					{
						if (linePos[i] == "1")
						{
							//[Add by Kumo for Sticky Wild.**]
							if (maskStr.length - 1 - i >= 0 && maskStr.charAt(maskStr.length - 1 - i) == "1")
							{
								symblos.push(getSymbloInfo(0, i));
							}
							else
							{
								symblos.push(getSymbloInfo(stops[i] , i));
							}
							//[Add by Kumo for Sticky Wild.**]
						}
					}
				}
				else
				{
					for (i = 0; i < sourceList.length; i++)
					{
						if (i < linePos.length && linePos[i] == "1")
						{
							//[Add by Kumo for Sticky Wild.***]
							if (maskStr.length - 1 - i >= 0 && maskStr.charAt(maskStr.length - 1 - i) == "1")
							{
								symblos.push(getSymbloInfo(0, i));
							}
							else
							{
								// changed by zy
								// 234 way 线解析 直接使用stop
								symblos.push(getSymbloInfo(stops[i], i));
								//symblos.push(getSymbloInfo(stops[sourceList[i]] , sourceList[i]));
							}
							//[Add by Kumo for Sticky Wild.***]
						}
					}
				}
			}
			else
			{
				//其他
				for (i = 0; i < linePos.length; i++)
				{
					if (linePos[i] == "1")
					{
						//[Add by Kumo for Sticky Wild.****]
						if (maskStr.length - 1 - i >= 0 && maskStr.charAt(maskStr.length - 1 - i) == "1")
						{
							symblos.push(getSymbloInfo(0, i));
						}
						else
						{
							symblos.push(getSymbloInfo(stops[i], i));
						}
						//[Add by Kumo for Sticky Wild.****]
					}
				}
			}
			symblos.sort(sortByReelIndex);
		}
		
		private function sortByReelIndex(s1:SymbloInfo, s2:SymbloInfo):int
		{
			if (s1.reelIndex > s2.reelIndex)
			{
				return 1;
			}
			else if (s1.reelIndex < s2.reelIndex)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		public function get symbloLength():uint
		{
			if (symblos)
			{
				return symblos.length;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * MessageWord 
		 * @return 
		 * 
		 */		
		public function get winMessageWord():String
		{
			if (_customMsg)
			{
				return _customMsg;
			}
			
			var msgWord:String;
			
			if (isScatter)
			{
				msgWord= GameLanguageTextConfig.getLangText(ConfigTextDefined.ONLY_SYMBOL_WIN);
			}
			else
			{
				msgWord= GameLanguageTextConfig.getLangText(ConfigTextDefined.SYMBOL_WIN);
			}
			
			var symbloList:Array = [];
			for (var i:uint = 0; i < symblos.length; i++)
			{
				symbloList.push("[" + GameAssetLibrary.symbolLibrary.getSymbloAdvName(symblos[i].name) + "]");
			}
			msgWord = msgWord.replace(LanguageReplaceTag.SYMBOL, symbloList.join(""));
			msgWord = msgWord.replace(LanguageReplaceTag.LINE, lineIndex);
			msgWord = msgWord.replace(LanguageReplaceTag.CREDIT , lineWin);
			
			return msgWord;
		}
		
		public function getSymbloInfo(sname:uint, idx:uint):SymbloInfo
		{
			var result:SymbloInfo = new SymbloInfo();
			result.name = sname.toString();
			result.reelName = "s" + (idx % GameSetting.reelColume + 1);
			result.idx = uint(idx / GameSetting.reelColume);
			
			var reelInfo:ReelInfo = GameSetting.getReelInfo(result.reelName);
			result.pos = reelInfo.getSymbloPosition(result.idx);
			result.pos.x += GameSetting.reelPos.x;
			result.pos.y += GameSetting.reelPos.y;
			
			return result;
		}
	}
}