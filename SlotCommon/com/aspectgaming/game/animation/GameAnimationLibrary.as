package com.aspectgaming.game.animation
{
	import com.aspectgaming.animation.event.AnimationEvent;
	import com.aspectgaming.animation.iface.IAnimation;
	import com.aspectgaming.game.core.IGameAnimation;
	import com.aspectgaming.game.event.GameAnimaEvent;
	import com.aspectgaming.iterator.ArrayIIterator;
	import com.aspectgaming.iterator.IIterator;
	
	import flash.utils.Dictionary;
	
	/**
	 * 游戏动画库 
	 * @author mason.li
	 * 
	 */	
	public class GameAnimationLibrary
	{
		private static var _registerObject:Object = {};
		private static var _aniInstanceCache:Object = {};
		private static var _aniCache:Dictionary;
		
		/**
		 * IAnimation 集合管理 
		 */		
		private static var _aniSymbloCache:Dictionary;
		
		public static function get aniSymbloCache():Dictionary
		{
			if (!_aniSymbloCache)
			{
				_aniSymbloCache = new Dictionary();
			}
			return _aniSymbloCache;
		}

		public static function get aniCache():Dictionary
		{
			if (!_aniCache)
			{
				_aniCache = new Dictionary();
			}
			return _aniCache;
		}
		
		public static function addAniSymblo(key:String, value:IAnimation):void
		{
			var cacheList:Vector.<IAnimation>;
			if (aniSymbloCache[key])
			{
				cacheList = aniSymbloCache[key];
			}
			else
			{
				cacheList = new Vector.<IAnimation>();
				aniSymbloCache[key] = cacheList;
			}
			cacheList.push(value);
		}
		
		public static function getAniSymbloList(key:String):Vector.<IAnimation>
		{
			if (aniSymbloCache[key])
			{
				return aniSymbloCache[key];
			}
			else
			{
				return Vector.<IAnimation>([]);
			}
		}
		
		public static function addAniRef(key:String, value:IGameAnimation):void
		{
			aniCache[key] = value;
		}
		
		
		
		public static function getAniRef(key:String):IGameAnimation
		{
			return aniCache[key] ;
		}
		
		
		
		public static function killAniRef(key:String):void
		{
			if (aniCache[key] )
			{
				IGameAnimation( aniCache[key] ).dispose();
				delete aniCache[key] ;
			}
		}
		
		public static function removeAniRef(key:String):void
		{
			if (aniCache[key])
			{
				aniCache[key] = null;
				delete aniCache[key];
			}
		}
		
		public static function dispose():void
		{
			_registerObject = null;
			_aniInstanceCache = null;
			for (var key:String in aniCache)
			{
				if (aniCache[key])
				{
					IGameAnimation(aniCache[key]).removeEventListener(GameAnimaEvent.ANIMATION_HALF, arguments.callee);
					IGameAnimation(aniCache[key]).removeEventListener(GameAnimaEvent.ANIMATION_COMPLETE, arguments.callee);
					IGameAnimation(aniCache[key]).dispose();
				}
			}
			
			for (key in aniSymbloCache)
			{
				if (aniSymbloCache[key])
				{
					var aniList:Vector.<IAnimation> = aniSymbloCache[key];
					trace("currentKey:", key, "currentLen:", aniList.length);
					for (var i:uint = 0; i < aniList.length; i++)
					{
						aniList[i].removeEventListener(AnimationEvent.ANIMATION_COMPLETE, arguments.callee);
						aniList[i].removeEventListener(AnimationEvent.ANIMATION_HALF, arguments.callee);
						aniList[i].dispose();
					}
					aniSymbloCache[key] = null;
				}
			}
			_aniSymbloCache = null;
			
			_aniCache = null;
		}

		public static function registerAniClass(key:String, cls:Class):void
		{
			if (!_registerObject)
			{
				_registerObject = {};
			}
			_registerObject[key] = cls;
		}
		
		public static function getAnimation(key:String, needCache:Boolean = true):IGameAnimation
		{
			if (!_aniInstanceCache)
			{
				_aniInstanceCache = {};
			}
			
			if (!needCache)
			{
				return _registerObject[key] ? new _registerObject[key] : null;
			}
			else
			{
				if (_aniInstanceCache[key])
				{
					return _aniInstanceCache[key];
				}
				else
				{
					if (_registerObject[key])
					{
						_aniInstanceCache[key] = new _registerObject[key];
						return _aniInstanceCache[key];
					}
					else
					{
						return null;
					}
				}
			}	
		}
	}
}