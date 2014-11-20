package com.aspectgaming.game.manager
{
	import com.aspectgaming.constant.ComeFromSource;
	import com.aspectgaming.event.GlobalEvent;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.animation.GameAnimationLibrary;
	import com.aspectgaming.game.base.control.OverrideCommandControl;
	import com.aspectgaming.game.component.reels.IReel;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.constant.SlotGameType;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.core.ISpeicalParse;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.data.winshow.SymbloInfo;
	import com.aspectgaming.game.data.winshow.WinLineInfo;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.iface.IGameModule;
	import com.aspectgaming.game.net.SlotAmfCommand;
	import com.aspectgaming.game.utils.WinShowUtil;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.utils.pool.SheetCachePool;
	import com.aspectgaming.utils.tick.FrameRender;
	import com.aspectgaming.utils.tick.Tick;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleActor;
	
	
	/**
	 * 游戏管理 
	 * 1.模块管理 (创建 缓存)
	 * 2.赌注数据
	 * 3.游戏特殊处理包装器
	 * 4.游戏全局管理 (模式切换  销毁)
	 * @author mason.li
	 * 
	 */
	public class GameManager extends ModuleActor
	{
		/**
		 * 是否为 FreeOutro 后停止状态
		 */		
		public var isAfterFreeOutro:Boolean = true;
		/**
		 * 需要特殊解析接口 
		 */		
		public var speicalParse:ISpeicalParse;
		
		private var _gameTick:Tick;
		private var _gameRender:FrameRender;
		private var _moduleList:Dictionary;
		private var _isAutoPlay:Boolean;
		
		private var _moduleRegList:Dictionary;
		
		private var _reelInfo:Vector.<IReel>;
		private var _isInFreeGameAnimation:Boolean;
		
		private var _overrideControl:OverrideCommandControl;
		
		public function GameManager()
		{
			super();
		}

		public function get overrideControl():OverrideCommandControl
		{
			if (!_overrideControl)
			{
				_overrideControl = new OverrideCommandControl();
			}
			
			return _overrideControl;
		}
		
		public function set isInFreeGameAnimation(value:Boolean):void
		{
			_isInFreeGameAnimation = value;
		}

		public function get gameTick():Tick
		{
			if (!_gameTick)
			{
				_gameTick = new Tick();
			}
			return _gameTick;
		}
		
		/**
		 * 发送至ROBOTLEGS事件 
		 * @param evt
		 * 
		 */		
		public function dispatchToContext(evt:Event):void
		{
			dispatch(evt);
		}

		public function set reelInfo(value:Vector.<IReel>):void
		{
			_reelInfo = value;
		}

		/**
		 * 当前是否为自动游玩模式 
		 * @return 
		 * 
		 */		
		public function get isAutoPlay():Boolean
		{
			return _isAutoPlay;
		}

		public function set isAutoPlay(value:Boolean):void
		{
			_isAutoPlay = value;
		}
		
		
		public function get isInFreeGameAnimation():Boolean
		{
			return _isInFreeGameAnimation;
		}
		/**
		 * 游戏版本号 
		 * @return 
		 * 
		 */		
		public function get version():String
		{
			return GameLayerManager.gameRoot.gameVersion;
		}
		
		private function get moduleList():Dictionary
		{
			if (!_moduleList)
			{
				_moduleList = new Dictionary();
			}
			return _moduleList;
		}
		
		/**
		 * 取模块数量 
		 * @return 
		 * 
		 */		
		public function get moduleCount():int
		{
			var result:int;
			for (var key:* in moduleList)
			{
				++result;
			}
			return result;
		}
		
		private function get moduleRegList():Dictionary
		{
			if (!_moduleRegList)
			{
				_moduleRegList = new Dictionary();
			}
			return _moduleRegList;
		}

		/**
		 * 添加一个模块到舞台 
		 * @param module
		 * @param key
		 * @param par
		 * @param x
		 * @param y
		 * 
		 */		
		public function addModule(module:IGameModule, key:String, par:DisplayObjectContainer, x:Number = 0, y:Number = 0):void
		{
			module.show(par, x ,y);
			moduleList[key] = module;
		}
		
		/**
		 * 通过索引获取轮子信息 
		 * @param idx
		 * @return 
		 * 
		 */		
		public function getReelInfoByIndex(idx:uint):IReel
		{
			if (_reelInfo)
			{
				if (idx > _reelInfo.length - 1)
				{
					return null;
				}
				else
				{
					return _reelInfo[idx];	
				}
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 填充LINE INFO  displayobject引用
		 * @param vec
		 * 
		 */		
		public function fullDisObjects(vec:Vector.<LineInfo>):void
		{
			for each (var info:LineInfo in vec)
			{
				if (info.symblos)
				{
					for each (var sb:SymbloInfo in info.symblos)
					{
						sb.displayObject = _reelInfo[sb.reelIndex].getCurrentDisplayObject(sb.idx);
					}
				}
			}
		}
		
		/**
		 * 重置当前游戏 
		 * 
		 */		
		public function reset():void
		{
			for (var key:String in _moduleList)
			{
				IGameModule(_moduleList[key]).restart();
			}
		}
		
		/**
		 * 当前轮子是否在运转 
		 * @return 
		 * 
		 */		
		public function get isReelRolling():Boolean
		{
			if (_reelInfo)
			{
				for each (var reel:IReel in _reelInfo)
				{
					if (reel.isRolling)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * 注册一个模块类 
		 * @param key
		 * @param cls
		 * 
		 */		
		public function registerModuleClass(key:String, cls:Class):void
		{
			moduleRegList[key] = cls;
		}
		
		/**
		 * 获取一个模块类 
		 * @param key
		 * @return 
		 * 
		 */		
		public function getModuleClass(key:String):Class
		{
			return moduleRegList[key];
		}
		
		/**
		 * 获取一个模块实例 
		 * @param key
		 * @return 
		 * 
		 */		
		public function getModule(key:String):IGameModule
		{
			return moduleList[key];
		}
		
		/**
		 * 销毁 干！ 
		 * 
		 */		
		public function dispose():void
		{
			if (_gameTick)
			{
				_gameTick.clear();
				_gameTick = null;
			}
			
			//Other
			GameAnimationLibrary.dispose();
			GameLayerManager.dispose();
			WinShowUtil.disposeAni();
			
			//gameManger 
			for (var key:String in _moduleList)
			{
				IGameModule(_moduleList[key]).dispose();
			}
			_moduleList = null;
			_moduleRegList = null;
			
			GameGlobalRef.gameData = null;
			GameGlobalRef.gambleInfo = null;
			GameGlobalRef.gameInfo = null;
			GameGlobalRef.gameManager = null;
			GameGlobalRef.gameServer.dispose();
			GameGlobalRef.gameServer = null;
			if (GameGlobalRef.simulator)
			{
				(GameGlobalRef.simulator as IEventDispatcher).removeEventListener(GlobalEvent.EMNULATOR_PLAY, arguments.callee);
				GameGlobalRef.simulator = null;
			}
			
			speicalParse = null;
			
			if (_gameRender)
			{
				_gameRender.dispose();
				_gameRender = null;
			}
			
			GameAssetLibrary.dispose();
			SheetCachePool.empty();
			GameTipsManager.dispose();
			
			GameSetting.clear();
			
			_overrideControl = null;
		}
		
		/**
		 * 帧渲染 器
		 * @return 
		 * 
		 */		
		public function get frameRender():FrameRender
		{
			if (!_gameRender)
			{
				_gameRender = new FrameRender();
			}
			
			return _gameRender;
		}
		
		//=====================Speical Parse=======================
		
		
		
		/**
		 * 判断元件是否为Scattor 
		 * @return 
		 * 
		 */		
		public function isScatterSymble(id:String):Boolean
		{
			if (speicalParse)
			{
				return speicalParse.isScatterSymble(id);
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 游戏HACK 处理 
		 * @param o
		 * 
		 */		
		public function parseSpeicalFreeGame(o:*):void
		{
			if (speicalParse)
			{
				speicalParse.parseSpeicalFreeGame(o);
			}
		}
		
		public function parseSpeicalBaseGame(o:*):void
		{
			if (speicalParse)
			{
				speicalParse.parseSpeicalBaseGame(o);
			}
		}
		
		public function parseSpeicalStops(arr:Array):Array
		{
			if (speicalParse)
			{
				return speicalParse.parseSpeicalStops(arr);
			}
			return arr;
		}
		
		public function get currentMeterSoundName():String
		{
			if (speicalParse)
			{
				return speicalParse.getMeterSound();
			}
			else
			{
				return SlotSoundDefined.METER_WIN;
			}
		}
		
		public function parseSpeicalLineInfo(lines:Vector.<LineInfo>):void
		{
			if (speicalParse)
			{
				speicalParse.parseLineInfo(lines);
			}
		}
		
		
		/**
		 * 检测 scatter是否还会中 
		 * @param scatterLen
		 * @param idx
		 * @return 
		 * 
		 */		
		
		public function checkScattarHitted(scatterLen:uint, idx:uint):Boolean
		{
			if (speicalParse && speicalParse.hasScatterRule)
			{
				return speicalParse.checkScatterHitted(scatterLen, idx);
			}
			else
			{
				return ((3 - scatterLen) <= (GameSetting.reelColume - idx)) || (GameGlobalRef.gameData.scatterSymbloNum >= 3); 
			}
		}
		
		/**
		 * 填充特殊轮子STOP 
		 * @param arr
		 * @return 
		 * 
		 */		
		public function parseSpeicalReel(arr:Array):void
		{
			if (speicalParse)
			{
				speicalParse.parseSpeicalReel(arr);
			}
		}
		
		public function fullSpeicalBaseGameData(obj:Object):void
		{
			if (speicalParse)
			{
				speicalParse.fullSpeicalBaseGameData(obj);
			}
		}
		
		public function fullSpeicalPowerPlay(obj:Object):void
		{
			if (speicalParse)
			{
				speicalParse.fullSpeicalPowerPlay(obj);
			}
		}
		
		public function processLine(line:Number):Number
		{
			if (speicalParse)
			{
				return speicalParse.processLineHack(line);
			}
			else
			{
				return line;
			}
		}
		
		public function processBet(obj:Number):Number
		{
			if (speicalParse)
			{
				return speicalParse.processBetHack(obj);
			}
			else
			{
				return obj;
			}
		}
		
		public function processBetMax(n:Number):Number
		{
			if (speicalParse)
			{
				return speicalParse.processBetMax(n);
			}
			else
			{
				return n;
			}
		}
		
		//========================赌注数据==================================
		
		private var _gameMode:String;
		
		private var _betLineMax:uint;
		private var _betCashEachLineMax:Number = 0;
		
		public var betLineMin:uint = 1;
		public var betCashEachLineMin:Number = 1;
		
		
		private var _currentBetLine:uint;
		
		private var _currentEachLineCash:Number;
		
		/**
		 * 当前线 
		 */
		public function get currentBetLine():uint
		{
			return _currentBetLine;
		}
		
		/**
		 * 服务器赋值 
		 * @param value
		 * 
		 */		
		public function setCurrentLine(value:uint):void
		{
			value = processLine(value);
			var needDispatch:Boolean = checkTellLobby(value, _currentBetLine);
			_currentBetLine = value;
			
			if (needDispatch)
			{
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.ON_TOTAL_BET_CHANGED, "", "0", {bet:currentEachLineCash, maxLine:_betLineMax}));
			}
		}
		
		/**
		 * 客户端变更当前赌注行数
		 */
		public function set currentBetLine(value:uint):void
		{
			value = processLine(value);
			var needDispatch:Boolean = checkTellLobby(value, _currentBetLine);
			_currentBetLine = value;
			dispatch(new SlotUIEvent(SlotUIEvent.BET_LINE_CHANGED));
			if (needDispatch)
			{
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.ON_TOTAL_BET_CHANGED, "", "0", {bet:currentEachLineCash, maxLine:_betLineMax}));
			}
		}
		
		/**
		 * 当前每条线的赌注 
		 */
		public function get currentEachLineCash():Number
		{
			return _currentEachLineCash;
		}
		
		/**
		 * 客户端变更每行赌注
		 */
		public function set currentEachLineCash(value:Number):void
		{
			value = processBet(value);
			var needDispatch:Boolean = checkTellLobby(value, _currentEachLineCash);
			_currentEachLineCash = value;
			dispatch(new SlotUIEvent(SlotUIEvent.BET_CASH_CHANGED));
			if (needDispatch)
			{
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.ON_TOTAL_BET_CHANGED, "", "0", {bet:currentEachLineCash, maxLine:_betLineMax}));
			}
		}
		
		/**
		 * 服务器赋值 每行赌注
		 */
		public function setCrrentEachLineCash(value:Number):void
		{
			value = processBet(value);
			var needDispatch:Boolean = checkTellLobby(value, _currentEachLineCash);
			_currentEachLineCash = value;
			if (needDispatch)
			{
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.ON_TOTAL_BET_CHANGED, "", "0", {bet:currentEachLineCash, maxLine:_betLineMax}));
			}
		}
		
		private function checkTellLobby(newVal:Number, oldVal:Number):Boolean
		{
			return newVal != oldVal;
		}
		
		/**
		 * 每条线下注的钱
		 */
		public function get betCashEachLineMax():Number
		{
			return _betCashEachLineMax;
		}
		
		/**服务器赋值每线最大投注额
		 * @private
		 */
		public function set betCashEachLineMax(value:Number):void
		{
			value = processBetMax(value);
			var isChanged:Boolean = value != _betCashEachLineMax;
			
			if (isChanged)
			{
				_betCashEachLineMax = value;
				dispatch(new SlotUIEvent(SlotUIEvent.BET_CASH_MAX_CHANGED));
			}
		}
		
		public function setBetCashEachLineMax(value:Number):void
		{
			value = processBet(value);
			_betCashEachLineMax = value;
		}
		
		/**
		 * 下注的线 
		 */
		public function get betLineMax():uint
		{
			return _betLineMax;
		}
		
		/**
		 * @private
		 */
		public function set betLineMax(value:uint):void
		{
			var needDispatch:Boolean = checkTellLobby(value, _betLineMax);
			_betLineMax = value;
			if (needDispatch)
			{
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.ON_TOTAL_BET_CHANGED, "", "0", {bet:currentEachLineCash, maxLine:_betLineMax}));
			}
		}
		
		public function setBetInfoToMax():void
		{
			var needDispatch:Boolean = checkTellLobby(_currentBetLine, _betLineMax) || checkTellLobby(_currentEachLineCash, _betCashEachLineMax);
			_currentBetLine = _betLineMax;
			_currentEachLineCash = processBetMax(_betCashEachLineMax);
			
			dispatch(new SlotUIEvent(SlotUIEvent.BET_LINE_CHANGED));
			dispatch(new SlotUIEvent(SlotUIEvent.BET_CASH_CHANGED));
			
			if (needDispatch)
			{
				ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.ON_TOTAL_BET_CHANGED, "", "0", {bet:currentEachLineCash, maxLine:_betLineMax}));
			}
		}
		
		/**
		 * 当前赌注 
		 * @return 
		 * 
		 */		
		public function get currentBet():Number
		{
			return _currentBetLine * _currentEachLineCash;
			//return _currentEachLineCash;
		}
		
		public function get isBaseGame():Boolean
		{
			return gameMode == SlotGameType.BASE_GAME;
		}
		public function get isFreeGame():Boolean
		{
			return gameMode == SlotGameType.FREE_GAME;
		}
		public function get isPropGame():Boolean
		{
			return gameMode == SlotGameType.POWER_SPIN;
		}
		public function get gameMode():String
		{
			return _gameMode;
		}
		
		public function set gameMode(value:String):void
		{
			var newGameMode:String = getGameMode(value);
			if (_gameMode != newGameMode)
			{
				_gameMode = newGameMode;
				dispatch(new SlotEvent(SlotEvent.GAME_MODE_CHANGED, null, value));
			}
		}
		
		public function get isInFreeGame():Boolean
		{
			return GameGlobalRef.gameData.currentStatue == GameStatue.FREE_GAME_INTRO || gameMode == SlotGameType.FREE_GAME
		}
		
		/**
		 * 通过状态获取当前游戏模式 
		 * @param statue
		 * @return 
		 * 
		 */		
		private function getGameMode(statue:String):String
		{
			switch (statue)
			{
				case GameStatue.FREE_GAME_OUTRO:
				case GameStatue.FREEGAME:
					return SlotGameType.FREE_GAME;
					break;
				case GameStatue.POWER_SPIN:
					return SlotGameType.POWER_SPIN;
					break;
				default:
					return SlotGameType.BASE_GAME;
					break;
			}
		}
		public function get isMakeliving():Boolean
		{
			return GameGlobalRef.gameInfo.clientSource == ComeFromSource.SOURCE_MAKELIVING?true:false;
		}
		
		/**
		 * 检测 ProgressiveEnd 后 的游戏状态 
		 * @param cmd
		 * 
		 */		
		public function checkProgressiveEnd(cmd:String):void
		{
			if (cmd == SlotAmfCommand.CMD_GAME_PROGRESSIVE_END && GameGlobalRef.gameData.currentStatue == GameStatue.FREE_GAME_INTRO)
			{
				dispatch(new SlotEvent(SlotEvent.GAME_CHECK_STATUE, 1));
			}
		}
	}
}