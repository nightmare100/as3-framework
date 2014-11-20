package com.aspectgaming.game.utils
{
	import com.aspectgaming.animation.iface.IAnimation;
	import com.aspectgaming.animation.phasor.PhasorPlayer;
	import com.aspectgaming.animation.sheet.SheetPlayer;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.data.winshow.SymbloInfo;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.PointUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * winshow子元件控制 
	 * @author mason.li
	 * 
	 */	
	public class WinShowUtil
	{	
		private static const FADE_DELAY:Number = 1;
		private static const LINE_DELAY:Number = 530;
		
		private static var _currentLineInfo:LineInfo;
		private static var _lineTick:int;
		
		private static var _anis:Dictionary;
		
		private static var _isInWinShow:Boolean;
		private static var _currentPar:DisplayObjectContainer;
		
		//[Add by Kumo for StickyWilld winshow.*]
		private static var _firstName:String;
		//[Add by Kumo for StickyWilld winshow.*]
		
		public static function get isInWinShow():Boolean
		{
			return _isInWinShow;
		}

		public static function get anis():Dictionary
		{
			if (!_anis)
			{
				_anis = new Dictionary();
			}
			return _anis;
		}
		
		public static function reset():void
		{
			clearChild();
			winShowChildProcess(_currentPar, _currentLineInfo);
		}

		/**
		 * winshow元件处理 
		 * @param par
		 * @param lineInfo
		 * 
		 */		
		public static function winShowChildProcess(par:DisplayObjectContainer, lineInfo:LineInfo):void
		{
			_isInWinShow = true;
			_currentLineInfo = lineInfo;
			_currentPar = par;
			_currentPar.addChild(lineInfo.instance);
			
			clearInterval(_lineTick);
			
			_lineTick = setInterval(onLineCalled, LINE_DELAY);
			//[Add by Kumo for StickyWilld winshow.**]
			_firstName = _currentLineInfo.symblos[0].name;
			//[Add by Kumo for StickyWilld winshow.**]
			
			for each (var item:SymbloInfo in _currentLineInfo.symblos)
			{
				//[Add by Kumo for StickyWilld winshow.***]
				var mc:MovieClip;
				if (LineInfo.IsStickyWildMode)
				{
					if (item.displayObject.name != "0" && item.displayObject.name != _firstName)
					{
						mc = GameAssetLibrary.symbolLibrary.getAniObject("0");
					}
					else
					{
						mc = GameAssetLibrary.symbolLibrary.getAniObject(item.name);
					}
				}
				else
				{
					mc = GameAssetLibrary.symbolLibrary.getAniObject(item.displayObject.name);
				}
				//[Add by Kumo for StickyWilld winshow.***]
				
				if (!mc)
				{
					addTweenTo(item.displayObject);
				}
				else
				{
					var pt:Point = PointUtil.localToGoble(item.displayObject, GameLayerManager.rootPoint.x, GameLayerManager.rootPoint.y) ;
					var sheet:SheetPlayer;
					if (anis[item.displayObject])
					{
						sheet = anis[item.displayObject];
					}
					else
					{
						sheet = new SheetPlayer(mc, -1);
						sheet.x = pt.x;
						sheet.y = pt.y;
					}
					
					_currentPar.addChild(sheet);
					sheet.start();
					anis[item.displayObject] = sheet;
					item.displayObject.visible = false;
				}

			}
		}
		
		private static function addTweenTo(o:DisplayObject):void
		{
			o.alpha = 1;
			fadeOut();
			function fadeOut():void
			{
				TweenLite.to(o, FADE_DELAY, {alpha:0.3, onComplete:fadeIn});
			}
			
			function fadeIn():void
			{
				TweenLite.to(o, FADE_DELAY, {alpha:1, onComplete:fadeOut});
			}
		}
		
		private static function onLineCalled():void
		{
			if (_currentLineInfo.instance)
			{
				_currentLineInfo.instance.visible = !_currentLineInfo.instance.visible;
			}
		}
		
		public static function clearChild(isDispose:Boolean = false):void
		{
			clearInterval(_lineTick);
			if (_currentLineInfo)
			{
				DisplayUtil.removeFromParent(_currentLineInfo.instance);
				_currentLineInfo.instance.visible = true;
				
				for each (var item:SymbloInfo in _currentLineInfo.symblos)
				{
					TweenLite.killTweensOf(item.displayObject);
					item.displayObject.alpha = 1;
					item.displayObject.visible = true;
				}
			}
			
			if (isDispose)
			{
				disposeAni();
			}
			else
			{
				clearAni();
			}
		}
		
		private static function clearAni():void
		{
			for (var key:* in anis)
			{
				IAnimation(anis[key]).hide();
			}
		}
		
		public static function disposeAni():void
		{
			_isInWinShow = false;
			for (var key:* in anis)
			{
				IAnimation(anis[key]).dispose();
			}
			_anis = null;
			_currentPar = null;
		}
	}
}