package com.aspectgaming.game.data
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.net.vo.dto.SlotFreeGameDTO;
	import com.aspectgaming.game.utils.SlotUtil;
	import com.aspectgaming.utils.StringUtil;
	
	import flash.utils.flash_proxy;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * FreeGame信息 
	 * @author mason.li
	 * 
	 */	
	public class FreeGameModel extends Actor
	{
		[Inject]
		public var gameData:GameData;
		
		[Inject]
		public var gameMgr:GameManager;
		
		/**
		 * FREE GAME 总共次数 
		 */		
		public var totalTimes:int;
		
		public var freeGameIndex:int;
		
		public var isShowGirl:Boolean;
		
		public var currentWon:Number = 0;
		public var totalWon:Number = 0;
		
		//[Add by Kumo for Sticky Wild func.*]
		public var mathSpecificParams:Object;
		//[Add by Kumo for Sticky Wild func.*]
		
		/**
		 * 是否要播放串场动画 
		 */		
		public var needAniMovie:Boolean;
		
		private var _freeGameStops:Array;
		
		public function FreeGameModel()
		{
			super();
		}
		
		public function get freeGameStops():Array
		{
			if (_freeGameStops)
			{
				return SlotUtil.processStops(_freeGameStops);	
			}
			return _freeGameStops;
		}
		
		public function get totalWinAddBase():Number
		{
			return totalWon + GameGlobalRef.gameData.totalWin;
		}

		public function get remainTimes():int
		{
			return totalTimes - freeGameIndex;
		}
		
		public function get isCurrentWin():Boolean
		{
			return currentWon > 0;
		}
		
		public function checkRetrigger(cmd:String, total:Number):void
		{
			if (GameSetting.hasRetrigger && (cmd == SlotAmfCommand.CMD_FREEGAME_PLAY ||
				cmd == SlotAmfCommand.CMD_GAME_FREESPIN_PLAY))
			{
				needAniMovie = totalTimes < total;
			}
		}
		
		public function parse(freeGame:SlotFreeGameDTO, cmd:String):void
		{
			freeGameIndex = freeGame.currentFreeGameIndex;
			
			//只有PLAY的时候才会判断
			checkRetrigger(cmd, freeGame.totalFreeGameIndex);
			
			isShowGirl = totalTimes < GameSetting.showGirlTimes && totalTimes < freeGame.totalFreeGameIndex;
			
			totalTimes = freeGame.totalFreeGameIndex;	
			
			currentWon	= freeGame.freeGameWon;	
			totalWon	= freeGame.totalFreeGameWon;
			
			_freeGameStops = gameMgr.parseSpeicalStops( SlotUtil.stringToArray(freeGame.stops) );
			
			//[Add by Kumo for Sticky Wild func.**]
			//为了在freegameintro前把值重置.
			mathSpecificParams = freeGame.mathSpecificParams;
			//[Add by Kumo for Sticky Wild func.**]
				
			//Free game中
			if (freeGameIndex != 0 && freeGame.stops != null && freeGame.stops.length > 0) 
			{
				gameData.currentStops = gameMgr.parseSpeicalStops( SlotUtil.stringToArray(freeGame.stops) );
				
				gameData.setWinLineInfo(SlotUtil.parseStringArray(freeGame.winLineInfo));
				
				if(cmd != SlotAmfCommand.CMD_SLOTGAME_REGISTER){
					gameData.setWinLineInfo(StringUtil.isEmptyString(freeGame.scatterInfo) ? [] : [String(freeGame.scatterInfo).split(",")], false);
				}
								
				if (freeGame.mathSpecificParams != null) 
				{
					gameMgr.parseSpeicalFreeGame(freeGame.mathSpecificParams);
				}
			}
			
		}
	}
}