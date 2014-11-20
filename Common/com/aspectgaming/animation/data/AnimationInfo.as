package com.aspectgaming.animation.data
{
	import com.aspectgaming.animation.iface.IAnimation;
	
	public class AnimationInfo
	{
		public var type:String;
		public var callBack:Function;
		public var isSingleInstance:Boolean;
		public var animation:IAnimation;
		
		public function AnimationInfo(t:String, cb:Function, isSingle:Boolean, ani:IAnimation)
		{
			type = t;
			callBack = cb;
			isSingleInstance = isSingle;
			animation = ani;
		}
		
		public function setKeyFunction(obj:Object):void
		{
			if (animation)
			{
				animation.clearFrameScript();
			}
			
			if (obj && animation)
			{
				for (var key:String in obj)
				{
					animation.addFrameScript(uint(key), obj[key]);
				}
			}
		}
	}
}