package com.aspectgaming.utils.tick
{
	
	import com.aspectgaming.globalization.managers.ClientManager;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * 简易定时器  以秒为单位
	 * @author mason.li
	 * 2013.07 fixed 支持毫秒 必须为帧率的倍数
	 * 
	 */	
	public class Tick
	{
		private static var _instance:Tick;
		private static function getInstance():Tick
		{
			if (!_instance)
			{
				_instance = new Tick();
			}
			return _instance;
		}
		
		
		
		public function Tick()
		{
			_timeOutDic = new Dictionary();
			_timeIntervalDic = new Dictionary();
			_timer = new Timer(1000 / ClientManager.frameRate);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			stopTimer();
		}
		
		/**
		 * setTimeout功能 
		 * @param func
		 * @param timeout 定时时间
		 * @param id
		 * @duurtion 定时间隔
		 * 
		 */		
		public static function addTimeout(func:Function, timeout:Number, id:String = null, duurtion:Number = 1000):void
		{
			if (timeout < 0)
			{
				return;
			}
			getInstance().addTimeout(func, timeout, id, duurtion);
		}
		
		public static function set pause(value:Boolean):void
		{
			getInstance().pause = value;
		}
		
		/**
		 * 清所有 
		 * 
		 */		
		public static function clear():void
		{
			getInstance().clear();
		}
		
		public static function removeTimeout(key:*):void
		{
			getInstance().removeTimeout(key);
		}
		
		/**
		 * setInterval功能 
		 * @param func
		 * @param timeout
		 * @param id
		 * 
		 */	
		public static function addTimeInterval(func:Function, timeout:Number, id:String = null, duurtion:Number = 1000):void
		{
			if (timeout <= 0)
			{
				return;
			}
			getInstance().addTimeInterval(func, timeout, id, duurtion);
		}
		
		public static function removeTimeInterval(key:*):void
		{
			getInstance().removeTimeInterval(key);
		}
		
		/**
		 * 通过ID 或 CALLBACK 查看TIMEOUT是否已结束  只对指定ID的TIMEOUT 有效  
		 * @param key
		 * @return 
		 * 
		 */		
		public static function isTimeoutComplete(key:*):Boolean
		{
			return getInstance().isTimeoutComplete(key);
		}
		
		public static function hasTimeTick(key:String):Boolean
		{
			return getInstance().hasTimeTick(key);
		}
		
		/**
		 * 通过ID 或 CALLBACK 查看TIMEOUT 剩余TICK
		 * @param key
		 * @return 
		 * 
		 */	
		public static function getTimeLeft(key:*):Number
		{
			return getInstance().getTimeLeft(key);
		}
		
		
		//==============================================
		public function getTimeLeft(key:String):Number
		{
			if (!_timeOutDic)
			{
				return 0;
			}
			
			var info:TickInfo = _timeOutDic[key];
			
			if (info)
			{
				return info.timeout;	
			}
			else
			{
				return 0;
			}
		}
		
		public function hasTimeTick(key:String):Boolean
		{
			return _timeOutDic && _timeOutDic[key] || (_timeIntervalDic && _timeIntervalDic[key]);
		}
		
		public function isTimeoutComplete(key:String):Boolean
		{
			if (!_timeOutDic)
			{
				return false;
			}
			
			var info:TickInfo = _timeOutDic[key];
			
			if (info && info.isComplete)
			{
				removeTimeout(key);
				return true;	
			}
			else
			{
				return false;
			}
		}
		
		public function addTimeout(func:Function, timeout:Number, id:String = null, duration:Number = 1000):void
		{
			if (!_timeOutDic)
			{
				return;
			}
			
			var tickInfo:TickInfo;
			var nid:String = id?id:getTimer().toString();
			if (!_timeOutDic[nid])
			{
				tickInfo = new TickInfo();
				tickInfo.id = nid;
				tickInfo.func = func;
				tickInfo.timeout = timeout;
				
				_timeOutDic[nid] = tickInfo;
			}
			else
			{
				tickInfo = _timeOutDic[nid];
				tickInfo.isComplete = false;
				tickInfo.timeout = timeout;
			}
			tickInfo.dur = duration;
			tickInfo.timeTick = getTimer();
			
			madeTimerRun();
		}
		
		/**
		 *  
		 * @param key 注册ID 或 函数
		 * 
		 */		
		public function removeTimeout(key:String):void
		{
			if (_timeOutDic)
			{
				_timeOutDic[key] = null;
				delete _timeOutDic[key];
			}
		}
		
		public function addTimeInterval(func:Function, timeout:Number, id:String = null, duration:Number = 1000):void
		{
			if (!_timeIntervalDic)
			{
				return;
			}
			var nid:String = id?id:getTimer().toString();
			if (!_timeIntervalDic[nid])
			{
				var tickInfo:TickInfo = new TickInfo();
				tickInfo.id = id;
				tickInfo.func = func;
				tickInfo.timeout = timeout;
				tickInfo.timeInterval = timeout;
				tickInfo.timeTick = getTimer();
				tickInfo.dur = duration;
				_timeIntervalDic[id] = tickInfo;
			}
			madeTimerRun();
		}
		
		public function removeTimeInterval(key:String):void
		{
			if (_timeIntervalDic)
			{
				_timeIntervalDic[key] = null;
				delete _timeIntervalDic[key];
			}
		}
		
		public function clear():void
		{
			if (_timer)
			{
				stopTimer();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
			_timeOutDic = null;
			_timeIntervalDic = null;
		}

		private function onTimer(e:TimerEvent):void
		{
			processTickInfo();
			processTickInfoInterval();
			if (getAvailableNum(_timeOutDic) + getAvailableNum(_timeIntervalDic) <= 0)
			{
				stopTimer();
			}
		}
		
		private function madeTimerRun():void
		{
			if (getAvailableNum(_timeOutDic) + getAvailableNum(_timeIntervalDic) > 0 && !_pause )
			{
				if (!_timer.running)
				{
					_timer.start();
				}
			}
			else
			{
				stopTimer();
			}
		}
		
		private function getAvailableNum(d:Dictionary):uint
		{
			var n:uint = 0;
			for each (var info:TickInfo in d)
			{
				if (!info.isComplete)
				{
					n++;
				}
			}
			
			return n;
		}
		
		/**
		 * 处理timeout 
		 * @return 
		 * 
		 */		
		private function processTickInfo():uint
		{
			var n:uint = 0;
			for each (var info:TickInfo in _timeOutDic)
			{
				if (!info.isComplete && info.isTicked && info.timeout <= 0)
				{
					info.isComplete = true;
					info.timeout = 0;
					if (info.func != null)
					{
						info.func();
					}
					if (info.id == null)
					{
						_timeOutDic[info.id] = null;
						delete _timeOutDic[info.id];
					}
				}
				
				if (!info.isComplete)
				{
					n++;
				}
			}
			
			return n;
		}
		
		/**
		 * 处理timeInterval
		 * @return 
		 * 
		 */		
		private function processTickInfoInterval():uint
		{
			var n:uint = 0;
			for each (var info:TickInfo in _timeIntervalDic)
			{
				if (info.isTicked && info.timeout <= 0)
				{
					if (info.func != null)
					{
						info.func();
					}
					info.timeout = info.timeInterval;
				}
				
				n++;
			}
			
			return n;
		}
		
		public function set pause(value:Boolean):void
		{
			_pause = value;
			if (value)
			{
				stopTimer();
			}
			else
			{
				if (!_timer.running)
				{
					_timer.start();
				}
			}
		}
		
		private function stopTimer():void
		{
			_timer.stop();
		}
		
		private var _timeOutDic:Dictionary;
		private var _timeIntervalDic:Dictionary;
		private var _timer:Timer;
		private var _pause:Boolean;
	}
}
import flash.utils.getTimer;

class TickInfo
{
	public var id:String;
	public var func:Function;
	public var timeTick:Number;
	public var timeInterval:Number;
	public var timeout:Number;
	public var isComplete:Boolean = false;
	public var dur:Number;
	
	/**
	 * 是否已经过间隔
	 * @return 
	 * 
	 */	
	public function get isTicked():Boolean
	{
		var currentTick:Number = getTimer();
		var isPassSecond:Boolean = currentTick - timeTick >= dur;
		if (isPassSecond)
		{
			timeTick = getTimer();
			timeout -= dur / 1000;
		}
		return isPassSecond;  
	}
}