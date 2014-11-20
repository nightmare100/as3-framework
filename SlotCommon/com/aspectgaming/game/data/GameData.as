package com.aspectgaming.game.data
{
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.data.gamble.GambleInfo;
	import com.aspectgaming.game.data.progressive.ProgressiveInfo;
	import com.aspectgaming.game.data.singleresult.SingleResultInfo;
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.data.winshow.WinLineInfo;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.game.utils.SlotUtil;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * 游戏基本数据 
	 * @author mason.li
	 * 
	 */	
	public class GameData extends Actor
	{
		[Inject]
		public var gameMgr:GameManager;
		
		[Inject]
		public var gameInfo:GameInfo;
		
		/**
		 * 当前赢的钱 
		 */		
		public var totalWin:Number = 0;
		
		/**
		 * 龙币 
		 */		
		public var dragon:Number = 0;
		
		/**
		 * balance分 
		 */		
		public var totalCent:Number = 0;
		
		/**
		 * balance Dollar 
		 */		
		public var totalDollar:Number;
		
		/**
		 * 上次赢的钱 
		 */		
		public var lastWin:Number;
		
		/**
		 * 当前赌注 
		 */		
		public var totalWager:Number;
		
		/**
		 * 游戏当前状态 
		 */		
		public var currentStatue:String;
		
		private var _currentStops:Array;
		
		
		/**
		 * 赢钱线信息 
		 */		
		private var _winLineInfo:WinLineInfo;
		
		/**
		 * scatterInfo信息 
		 */		
		private var _scatterInfo:WinLineInfo;
		
		public var winTrack:Array;
		
		private var _bonusInfo:BonusInfo;
		
		private var _progressiveInfo:ProgressiveInfo;
		
		private var _baseGameStops:Array;
		
		private var _singleResultInfo:SingleResultInfo;

		public function GameData()
		{
			super();
			_winLineInfo = new WinLineInfo();
			_scatterInfo = new WinLineInfo();
		}

		public function set baseGameStops(value:Array):void
		{
			_baseGameStops = value;
		}

		public function get bonusInfo():BonusInfo
		{
			return _bonusInfo;
		}

		public function get progressiveInfo():ProgressiveInfo
		{
			if (!_progressiveInfo)
			{
				_progressiveInfo = new ProgressiveInfo();
			}
			return _progressiveInfo;
		}
		public function get singleResultInfo():SingleResultInfo 
		{
			if (!_singleResultInfo)
			{
				_singleResultInfo = new SingleResultInfo();
			}
			return _singleResultInfo;
		}
		/**
		 * 点PLAY后显示的钱 
		 * @return 
		 * 
		 */		
		public function get afterPlayDollar():Number
		{
			return totalDollar + totalWin - gameMgr.currentBet;
		}
		
		/**
		 * 是否能进行GAMBLE 
		 * @return 
		 * 
		 */		
		public function get canIntoGamble():Boolean
		{
			return currentStatue == GameStatue.GAMBLE_OR_TAKEWIN;
		}

		/**
		 * progressive信息设置 
		 * @param value
		 * 
		 */		
		public function parseProgressiveInfo(value:WinProgressiveDTO):void
		{
			progressiveInfo.parse(value);
			//事件备注
		}

		public function set currentStops(value:Array):void
		{
			_currentStops = value;
		}
		
		public function get scatterSymbloNum():Number
		{
			var scatNum:uint;
			if (_currentStops)
			{
				for (var i:uint = 0; i < _currentStops.length; i++)
				{
					if (_currentStops[i] == GameSetting.scatterSymbloNum)
					{
						scatNum++;
					}
				}
			}
			return scatNum;
		}

		/**
		 * 当前回合是否赢 
		 * @return 
		 * 
		 */		
		public function get isWin():Boolean
		{
			return totalWin > 0;
		}
		
		/**
		 * 当前停止的轮子 
		 * 二维数组
		 */
		public function get currentStops():Array
		{
			if (_currentStops)
			{
				return SlotUtil.processStops(_currentStops);
			}
			return null;
		}
		
		public function get baseGameStops():Array
		{
			return _baseGameStops;
		}

		/**
		 * 解析WINLINE 或者 scatter 
		 * @param winLineArr 
		 * @param isWinLine 是否为winline
		 * 
		 */		
		public function setWinLineInfo(winLineArr:Array, isWinLine:Boolean = true):void
		{
			if (isWinLine)
			{
				_winLineInfo.parseSourceArr(winLineArr, _currentStops);
			}
			else
			{
				_scatterInfo.parseSourceArr(winLineArr, _currentStops);
			}
		}
		
		public function get winLines():Vector.<LineInfo>
		{
			if (_winLineInfo.hasWinLine)
			{
				return _winLineInfo.winLineList;
			}
			else
			{
				return null;
			}
		}
		
		public function get scatterInfo():LineInfo
		{
			if (_scatterInfo.hasWinLine)
			{
				return _scatterInfo.winLineList[0];
			}
			else
			{
				return null;
			}
		}
		
		public function get isFreeGameStatue():Boolean
		{
			return currentStatue == GameStatue.FREE_GAME_INTRO || currentStatue == GameStatue.FREEGAME || currentStatue == GameStatue.FREE_GAME_OUTRO || gameInfo.isFreeSpin;
		}
		
		public function get isGaming():Boolean
		{
			return currentStatue != GameStatue.GAMEIDLE || GameGlobalRef.gameManager.isAutoPlay;
		}
		
		/**
		 * 获取当前轮子的显示列表
		 * @param name
		 * @return 
		 * 
		 */		
		public function getCurSymbloList(name:String):Array
		{
			var result:Array = [];
			if (_currentStops)
			{
				//左侧轮子
				if (GameSetting.checkFormalReel(name))
				{
					var symbloIdx:uint = uint(name.substr(1)) - 1;
					for (var i:uint = 0; i < _currentStops.length;i++)
					{
						if (i % GameSetting.reelColume == symbloIdx)
						{
							result.push(_currentStops[i]);
						}
					}
					return result;
				}
				else
				{
					//特殊轮子
					return result;
				}
			}
			else
			{
				return null;
			}
		}

	}
}