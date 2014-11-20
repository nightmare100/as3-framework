package com.aspectgaming.game.manager
{
	import com.aspectgaming.game.constant.asset.AssetRefDefined;
	import com.aspectgaming.game.popup.FreeSpinBonusView;
	import com.aspectgaming.game.popup.LowDragonDollarView;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.ui.base.BaseView;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * 游戏弹窗管理 
	 * @author mason.li
	 * 
	 */	
	public class GameTipsManager
	{
		private static var _popUpDic:Dictionary = new Dictionary();
		public static function popUp(type:String, useMask:Boolean = false):void
		{
			var popUpView:BaseView = getPopUpview(type, useMask);
			popUpView.show(GameLayerManager.topLayer);
		}
		
		public static function registerPopUpView(type:String, cls:Class):void
		{
			_popUpDic[type] = cls;
		}
		
		private static function getPopUpview(type:String, useMask:Boolean):BaseView
		{
			if (!_popUpDic[type])
			{
				var popUpview:Sprite; 
				switch (type)
				{
					case AssetRefDefined.BONUS_TIPS:
						popUpview = new FreeSpinBonusView(useMask);
						break;
					case AssetRefDefined.BUYDRAGON_TIPS:
						popUpview = new LowDragonDollarView(useMask);
						break;
				}
				
				_popUpDic[type] = popUpview;
			}
			else if (_popUpDic[type] is Class)
			{
				_popUpDic[type] = new _popUpDic[type] ();
			}
			
			
			return _popUpDic[type]
		}
		
		public static function killAllPopUp():void
		{
			for (var key:* in _popUpDic)
			{
				if (_popUpDic[key] is BaseView && DisplayUtil.isViewShow(_popUpDic[key]))
				{
					BaseView(_popUpDic[key]).dispose();
				}
			}
		}
		
		public static function dispose():void
		{
			for (var key:* in _popUpDic)
			{
				_popUpDic[key] = null;
				delete _popUpDic[key];
			}
		}
	}
}