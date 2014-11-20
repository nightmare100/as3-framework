package com.aspectgaming.animation
{
	import com.aspectgaming.ui.iface.IView;
	import com.aspectgaming.utils.DomainUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	/**
	 * Loading动画  为多列 或 单列
	 * @author mason.li
	 * 
	 */	
	public class LoadingAnimation extends Sprite
	{
		private var _mc:MovieClip;
		private static var _dic:Dictionary = new Dictionary();
		private static var _instance:LoadingAnimation;
		private static function getInstance():LoadingAnimation
		{
			if (!_instance)
			{
				_instance = new LoadingAnimation();
			}
			return _instance;
		}
		
		public static function show(par:IView, isSingle:Boolean = false):void
		{
			var instance:LoadingAnimation;
			if (isSingle)
			{
				instance = getInstance();
			}
			else
			{
				if (!_dic[par])
				{
					_dic[par] =  new LoadingAnimation();
				}
				instance = _dic[par];
			}
			
			instance.show(par);
		}
		
		public static function hide(par:IView = null):void
		{
			if (par)
			{
				if (_dic[par])
				{
					LoadingAnimation(_dic[par]).hide();
					delete _dic[par];
				}
			}
			else
			{
				getInstance().hide();
			}
		}
		
		//=================================
			
		
		public function LoadingAnimation()
		{
			_mc = DomainUtil.getMovieClip("Common_Loading");
			addChild(_mc);
		}
		
		public function show(par:IView):void
		{
			_mc.play();
			par.addByCenter(this);
		}
		
		public function hide():void
		{
			if (parent)
			{
				parent.removeChild(this);
				_mc.stop();
			}
		}
	}
}