package com.aspectgaming.game.popup
{
	import com.aspectgaming.game.constant.asset.AssetRefDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.ui.base.BaseView;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.constant.AlignType;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	public class FreeSpinBonusView extends BaseView
	{
		private const CLOSE_TIME_OUT:uint = 2;
		private var _useMask:Boolean;
		
		public function FreeSpinBonusView(useMask:Boolean)
		{
			_isDisposeWhenClose = false;
			_useMask = useMask;
			super();
		}
		
		override protected function initView():void
		{
			_mc = GameAssetLibrary.getMovieClip(AssetRefDefined.BONUS_TIPS);
			if (_useMask)
			{
				this.graphics.clear();
				this.graphics.beginFill(0, 0.5);
				this.graphics.drawRect(0, 0, GameLayerManager.GAME_WIDTH, GameLayerManager.GAME_HEIGHT);
				this.graphics.endFill();
			}
			DisplayUtil.align(_mc, AlignType.MIDDLE_CENTER, new Rectangle(0, 0, GameLayerManager.GAME_WIDTH, GameLayerManager.GAME_HEIGHT));
			super.initView();
		}
		
		override public function show(layer:DisplayObjectContainer=null, alignType:int=4):void
		{
			if (layer)
			{
				layer.addChild(this);
				if (!_isInit)
				{
					initView();
				}
				GameGlobalRef.gameManager.gameTick.addTimeout(hide, CLOSE_TIME_OUT, AssetRefDefined.BONUS_TIPS);
			}
		}
		
		override public function dispose():void
		{
			GameGlobalRef.gameManager.gameTick.removeTimeout( AssetRefDefined.BONUS_TIPS);
			super.dispose();
		}
		
		override public function hide():void
		{
			GameGlobalRef.gameManager.gameTick.removeTimeout( AssetRefDefined.BONUS_TIPS);
			super.hide();
		}
		
		
	}
}