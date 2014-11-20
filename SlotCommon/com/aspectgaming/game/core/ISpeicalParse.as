package com.aspectgaming.game.core
{
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.data.winshow.WinLineInfo;

	/**
	 * SLOT 游戏 数据特殊处理 接口  
	 * 在GAMEMANAGER 中引用
	 * @author mason.li
	 * 
	 */	
	public interface ISpeicalParse
	{
		/**
		 * 处理BASE GAME 的SPEICAL OBJECT 
		 * @param o
		 * 
		 */		
		function parseSpeicalBaseGame(o:*):void;
		
		/**
		 * 处理FREE GAME 的SPEICAL OBJECT 
		 * @param o
		 * 
		 */		
		function parseSpeicalFreeGame(o:*):void;
		
		
		/**
		 * 特殊处理STOPS数组 
		 * @param arr
		 * 
		 */		
		function parseSpeicalStops(arr:Array):Array;
		
		/**
		 * 在STOPS 数组中 填充特殊轮子 
		 * @param arr
		 * @return 
		 * 
		 */		
		function parseSpeicalReel(arr:Array):void;
		
		
		/**
		 * BaseGamePlay参数填充 
		 * @param o
		 * 
		 */		
		function fullSpeicalBaseGameData(o:Object):void;
		
		/**
		 * Power固定stops等 
		 * @param o
		 * 
		 */		
		function fullSpeicalPowerPlay(o:Object):void;
		
		/**
		 * 是否有scatterHIT规则 
		 * @return 
		 * 
		 */		
		function get hasScatterRule():Boolean;
		
		/**
		 * 检测scatter是否在中的范围 
		 * @return 
		 * 
		 */		
		function checkScatterHitted(currentScatterLen:uint, reelIndex:uint):Boolean;
		
		/**
		 * 判断元件是否为scattor 
		 * @param id
		 * @return 
		 * 
		 */		
		function isScatterSymble(id:String):Boolean;
		
		/**
		 * 获取 MeterSound名称
		 * @return 
		 * 
		 */		
		function getMeterSound():String;
		
		function parseLineInfo(lines:Vector.<LineInfo>):void
		
		
		/**
		 * 处理LINE 
		 * @param line
		 * @return 
		 * 
		 */		
		function processLineHack(line:Number):Number;
		
		/**
		 * 处理线 
		 * @param bet
		 * @return 
		 * 
		 */		
		function processBetHack(bet:Number):Number;
			
		
		function processBetMax(n:Number):Number;
		
		function saveSpeicalData(o:*):void;
		
		function getSpeicalData():*;
	}
}