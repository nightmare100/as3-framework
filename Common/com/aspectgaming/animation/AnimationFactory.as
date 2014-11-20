package com.aspectgaming.animation
{
	import com.aspectgaming.animation.data.AnimationInfo;
	import com.aspectgaming.animation.iface.IAnimation;
	import flash.utils.Dictionary;
	

	/**
	 * 动画工厂 
	 * @author mason.li
	 * 
	 */	
	public class AnimationFactory
	{
		private static var _mcCache:Dictionary = new Dictionary();
		
		private static var _clsDic:Dictionary = new Dictionary();
		
		/**
		 * 注册动画类  
		 * @param cls
		 * @param type 动画类型 ResourceType
		 * 
		 */		
		public static function registerClass(cls:Class, name:String, type:String = "goble"):void
		{
			_clsDic[name] = {mclass:cls, mtype:type };
		}
		
		/**
		 * 销毁指定资源的动画 
		 * @param type
		 * 
		 */		
		public static function dispose(type:String):void
		{
			for (var key:String in _clsDic)
			{
				if (_clsDic[key].mtype == type)
				{
					delete _clsDic[key];
					if (_mcCache[key])
					{
						var info:AnimationInfo = _mcCache[key];
						info.animation.dispose();
						_mcCache[key] = null;
						delete _mcCache[key];
						
					}
				}
			}
		}
		
		/**
		 * 获取动画信息 
		 * @param type
		 * @param callBack
		 * @param times
		 * @param isSingleInstance
		 * @return 
		 * 
		 */		
		public static function getAnimationInfo(type:String, callBack:Function, times:uint, funcOjbect:Object, isSingleInstance:Boolean):AnimationInfo
		{
			var info:AnimationInfo;
			if (isSingleInstance)
			{
				if (_mcCache[type])
				{
					info = _mcCache[type];
					info.animation.playTimes = times;
					info.callBack = callBack;
				}
				else
				{
					info = new AnimationInfo(type, callBack, isSingleInstance, createAnimation(type, times));
					_mcCache[type] = info;
				}
			}
			else
			{
				var animation:IAnimation = createAnimation(type, times);
				info = new AnimationInfo(type, callBack, isSingleInstance, animation);
				_mcCache[animation] = info;
			}
			info.setKeyFunction(funcOjbect);
			
			return info;
		}
		
		/**
		 * 获取并 删除 无需继续使用的对象 
		 * @param o
		 * @return 
		 * 
		 */		
		public static function getExistInfo(o:*):AnimationInfo
		{
			var info:AnimationInfo = _mcCache[o];
			if (info && !info.isSingleInstance)
			{
				_mcCache[o] = null;
				delete _mcCache[o];
				
				info.animation.dispose();
				info.animation = null;
			}
			return info;
		}
		
		/**
		 * 根据UI名称 创建动画 (根据动画的体积 决定使用 矢量 还是 sheet)  
		 * @param type 
		 * @param times
		 * @return 
		 * 
		 */		
		private static function createAnimation(type:String, times:uint):IAnimation
		{
			
			if (_clsDic[type])
			{
				var obj:Object = _clsDic[type];
				return new (obj.mclass as Class)(type);
			}
			else
			{
				return null;
			}
		}
	}
}