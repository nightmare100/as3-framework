package com.aspectgaming.game.module.game
{
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.game.component.reels.IReel;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.reel.WinLine;
	import com.aspectgaming.game.constant.asset.AssetDefined;
	import com.aspectgaming.game.core.IWinShow;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.module.game.iface.IPayLine;
	import com.aspectgaming.game.module.game.payline.NoLineAdapter;
	import com.aspectgaming.game.module.game.payline.PayLineView;
	import com.aspectgaming.game.module.game.reel.ReelBoxView;
	import com.aspectgaming.game.module.game.winshow.WinShowView;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.NewPlayerGuidManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ReelModule extends BaseControlModule
	{
		
		private var _hasPayLine:Boolean;
		/**
		 * 滚动元件 
		 */		
		public var reelBox:ReelBoxView;
		
		/**
		 * payline模块
		 */		
		public var payLine:IPayLine;
		
		protected var _winShow:IWinShow;
		
		/**
		 * 构造 
		 * @param mc
		 * @param winShow
		 * @param hasPayLine 是否有PAYLINE
		 * 
		 */		
		public function ReelModule(mc:MovieClip = null, winShow:IWinShow = null, hasPayLine:Boolean = true)
		{
			_winShow = winShow;
			_hasPayLine = hasPayLine;
			super(mc);
		}
		
		public function showWinLine(list:Vector.<LineInfo>, scatterInfo:LineInfo, totalWin:Number, needShowAutoLine:Boolean = true):void
		{
			// || (!GameGlobalRef.gameManager.isBaseGame && NewPlayerGuidManager.isInGuild)
			if (GameGlobalRef.gameManager.isAutoPlay && scatterInfo == null && GameGlobalRef.gameManager.isBaseGame || GameGlobalRef.gameManager.isPropGame)
			{
				//showLine Only
				if (payLine)
				{
					payLine.showAutoLine(list);
				}
			}
			else
			{
				if (_winShow)
				{
					var fullList:Vector.<LineInfo> = list ? list.concat() : new Vector.<LineInfo>();
					
					
//					needShowAutoLine = GameSetting.hasWinLine ? needShowAutoLine : false;
					
					if (list && payLine && needShowAutoLine)
					{
						payLine.showAutoLine(list);
					}
					if (scatterInfo)
					{
						fullList.push(scatterInfo);
					}
					GameGlobalRef.gameManager.fullDisObjects(fullList);
					_winShow.showWinLine(fullList, totalWin, needShowAutoLine);
				}
			}
		}
		
		public function clearWinShow():void
		{
			if (_winShow)
			{
				_winShow.stop();
			}
		}

		override public function dispose():void
		{
			super.dispose();
			reelBox.dispose();
			reelBox = null;
			
			if (payLine)
			{
				payLine.dispose();
				payLine = null;
			}
			if (_winShow)
			{
				_winShow.dispose();
				_winShow = null;
			}
		}
		
		override public function restart():void
		{
			clearWinShow();
			reelBox.clearStopAni();
			reelBox.clearOverStopAni();
		}
		
		
		
		override protected function init():void
		{
			reelBox = new ReelBoxView();
			reelBox.show(this, GameSetting.reelPos.x, GameSetting.reelPos.y);
			
			if (_hasPayLine)
			{
				payLine = new PayLineView(GameAssetLibrary.getGameAssets(AssetDefined.PAY_LINE));
				payLine.show(this);
				
				if (GameGlobalRef.gameManager.isInFreeGame)
				{
					payLine.stopLineApi();
					payLine.addBtnEvent();
				}
			}
			else
			{
				payLine = new NoLineAdapter();
			}
			
			if (_winShow)
			{
				_winShow.show(this);
				_winShow.lineMaster = payLine;
			}

			super.init();
		}
		
		public function hideWinShow():void
		{
			if (_winShow)
			{
				_winShow.hide();
			}
		}
		
		public function showWinShow():void
		{
			if (_winShow)
			{
				_winShow.show(this);
			}
		}
		
	
	}
}