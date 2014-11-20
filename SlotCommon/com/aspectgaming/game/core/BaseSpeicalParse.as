package com.aspectgaming.game.core
{
	import com.aspectgaming.game.data.winshow.LineInfo;
	
	public class BaseSpeicalParse implements ISpeicalParse
	{
		public function BaseSpeicalParse()
		{
		}
		
		public function parseSpeicalBaseGame(o:*):void
		{
		}
		
		public function parseSpeicalFreeGame(o:*):void
		{
		}
		
		public function parseSpeicalStops(arr:Array):Array
		{
			return arr;
		}
		
		public function parseSpeicalReel(arr:Array):void
		{
		}
		
		public function fullSpeicalBaseGameData(o:Object):void
		{
		}
		
		public function fullSpeicalPowerPlay(o:Object):void
		{
		}
		
		public function get hasScatterRule():Boolean
		{
			return false;
		}
		
		public function checkScatterHitted(currentScatterLen:uint, reelIndex:uint):Boolean
		{
			return false;
		}
		
		public function isScatterSymble(id:String):Boolean
		{
			return false;
		}
		
		public function getMeterSound():String
		{
			return null;
		}
		
		public function parseLineInfo(lines:Vector.<LineInfo>):void
		{
		}
		
		/**
		 * 处理LINE 
		 * @param line
		 * @return 
		 * 
		 */		
		public function processLineHack(line:Number):Number
		{
			return line;
		}
		
		/**
		 * 处理线 
		 * @param bet
		 * @return 
		 * 
		 */		
		public function processBetHack(bet:Number):Number
		{
			return bet;
		}
		
		public function processBetMax(n:Number):Number
		{
			return n;
		}
		
		private var _speicalData:*;
		
		public function saveSpeicalData(o:*):void
		{
			_speicalData = o;
		}
		
		public function getSpeicalData():*
		{
			return _speicalData;
		}
	}
}