package com.aspectgaming.game.popup
{
	import com.aspectgaming.constant.CoinType;
	import com.aspectgaming.constant.TrackPath;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.constant.asset.AssetRefDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.ui.base.BaseView;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.constant.AlignType;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class LowDragonDollarView extends BaseView
	{
		private var _useMask:Boolean;
		private var _buyButton:SimpleButton;
		
		public function LowDragonDollarView(useMask:Boolean)
		{
			_useMask = useMask;
			_isDisposeWhenClose = false;
			super();
		}
		
		override protected function initView():void
		{
			_mc = GameAssetLibrary.getMovieClip(AssetRefDefined.BUYDRAGON_TIPS);
			if (_useMask)
			{
				this.graphics.clear();
				this.graphics.beginFill(0, 0.5);
				this.graphics.drawRect(0, 0, GameLayerManager.GAME_WIDTH, GameLayerManager.GAME_HEIGHT);
				this.graphics.endFill();
			}
			_buyButton = _mc["btnBuyDagonDollar"];
			DisplayUtil.align(_mc, AlignType.MIDDLE_CENTER, new Rectangle(0, 0, GameLayerManager.GAME_WIDTH, GameLayerManager.GAME_HEIGHT));
			super.initView();
		}
		
		override protected function addEvent():void
		{
			_buyButton.addEventListener(MouseEvent.CLICK, onBuyDragon);
			super.addEvent();
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
			}
		}
		
		
		
		override protected function removeEvent():void
		{
			_buyButton.removeEventListener(MouseEvent.CLICK, onBuyDragon);
			super.removeEvent();
		}
		
		private function onBuyDragon(e:MouseEvent):void
		{
			ModuleManager.dispatchToGame(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_NOT_ENOUGH_MOENY,  CoinType.DRAGON, "0", { path:TrackPath.ANY_SLOTS + TrackPath.BET_WITH_DOLLARS }));
			onClose(e);
		}
	}
}