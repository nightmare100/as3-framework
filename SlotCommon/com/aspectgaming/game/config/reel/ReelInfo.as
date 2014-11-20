package com.aspectgaming.game.config.reel
{
	import com.aspectgaming.game.constant.ReelStopType;
	import com.aspectgaming.game.constant.RollDirectionDefined;
	import com.aspectgaming.game.constant.SlotGameType;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.utils.NumberUtil;
	import com.aspectgaming.utils.StringUtil;
	
	import flash.geom.Rectangle;
	
	/**
	 * 轮子你妹的信息 
	 * @author mason.li
	 * 
	 */	
	public class ReelInfo
	{
		/**
		 * 轮子唯一标示 
		 */		
		public var name:String;
		
		public var x:Number;
		public var y:Number;
		
		public var symbolWidth:Number;
		public var symbolHeight:Number;
		
		public var direction:String;
		
		/**
		 * 元件上下间距 
		 */		
		public var symbolMarginTB:Number;
		
		/**
		 * 元件左右间距 
		 */		
		public var symbolMarginLR:Number;
		
		/**
		 * 一屏显示的元件数量 
		 */		
		public var symbolNum:Number;
		
		public var reelStopType:String;
		
		
		private var _showSortBaseGame:Array;
		private var _showSortFreeGame:Array;
		private var _showSortPropGame:Array;
		
		private var _defaultBaseSymbol:Array;
		private var _defaultFreeSymbol:Array;
		
		public function ReelInfo(xml:XML)
		{
			name = String(xml.@name);
			x = Number(xml.@x);
			y = Number(xml.@y);
			symbolWidth = Number(xml.@symbolWidth);
			symbolHeight = Number(xml.@symbolHeight);
			
			symbolMarginTB = Number(xml.@symbolDicTB);
			symbolMarginLR = Number(xml.@symbolDicLR);
			
			reelStopType = String(xml.@reelStopType) ? String(xml.@reelStopType) : ReelStopType.NORMAL;
//			reelStopType = ReelStopType.HALF;
			
			symbolNum = Number(xml.@rellsNum);
			direction = StringUtil.isEmptyString(String(xml.@dir)) ? RollDirectionDefined.ROLL_TOP_TO_BOTTOM : String(xml.@dir);
		}
		
		public function get reelIndex():uint
		{
			return uint(name.substr(name.length - 1));
		}
		
		public function getDefaultSymbol():Array
		{
			if (GameGlobalRef.gameManager.isBaseGame)
			{
				return _defaultBaseSymbol;
			}
			else
			{
				return _defaultFreeSymbol;
			}
		}
		
		public function get showSortList():Array
		{
			if (GameGlobalRef.gameManager.isBaseGame)
			{
				return _showSortBaseGame;
			}
			else if(GameGlobalRef.gameManager.isFreeGame)
			{
				return _showSortFreeGame;
			}
			else
			{
				return _showSortPropGame;
			}
		}

		public function getSortIdx(idx:uint, type:String = "basegame"):uint
		{
			var sortArr:Array;
			if (type == SlotGameType.BASE_GAME)
			{
				sortArr = _showSortBaseGame;
			}
			else if(type == SlotGameType.FREE_GAME)
			{
				sortArr = _showSortFreeGame;
			}
			else
			{
				sortArr = _showSortPropGame;
			}
			return (idx >= sortArr.length) ? sortArr[0] : sortArr[idx];
		}
		
		public function getSortLength(type:String = "basegame"):uint
		{
			if (type == SlotGameType.BASE_GAME)
			{
				return _showSortBaseGame.length;
			}
			else if(type == SlotGameType.FREE_GAME)
			{
				return _showSortFreeGame.length;
			}
			else
			{
				return _showSortPropGame.length;
			}
		}
		
		public function getSymbloPosition(id:uint):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			rect.x = x + symbolMarginLR;
			rect.y = y + (symbolHeight + symbolMarginTB * 2) * id + symbolMarginTB;
			rect.width = symbolWidth;
			rect.height = symbolHeight;
			
			return rect;
		}
		
		public function setGameSort(str:String, defValue:String, type:String):void
		{
			if (type == SlotGameType.BASE_GAME)
			{
				_showSortBaseGame = str.split(",");
				_defaultBaseSymbol = StringUtil.isEmptyString(defValue) ? null : defValue.split(",");
			}
			else if(type==SlotGameType.FREE_GAME)
			{
				_showSortFreeGame = str.split(",");
				_defaultFreeSymbol = StringUtil.isEmptyString(defValue) ? null : defValue.split(",");
			}
			else
			{
				_showSortPropGame = str.split(",");
			}
		}
	}
}