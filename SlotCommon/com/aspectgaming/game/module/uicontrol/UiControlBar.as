package com.aspectgaming.game.module.uicontrol
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.SlotGameType;
	import com.aspectgaming.game.constant.asset.AnimationDefined;
	import com.aspectgaming.game.constant.asset.AssetDefined;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.core.IFreeTimesAni;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.game.module.uicontrol.control.UiBaseControl;
	import com.aspectgaming.game.module.uicontrol.control.UiFreeControl;
	import com.aspectgaming.game.module.uicontrol.iface.ISlotControl;
	import com.aspectgaming.game.module.uicontrol.wintrack.WinTrackBar;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class UiControlBar extends BaseControlModule
	{
		/**
		 * 倍率动画 
		 */		
		private var _wildMc:IFreeTimesAni;
		private var _bgMc:MovieClip;
		private var _uiControlMc:MovieClip;
		
		private var _uiBaseControl:ISlotControl;
		private var _uiFreeControl:ISlotControl;
		private var _winTrackBar:WinTrackBar;
		
		private var _baseCls:Class;
		private var _freeCls:Class;
		
		private var _freeAniCls:Class;
		
		
		public function UiControlBar(baseBarCls:Class, freeBarCls:Class, freeTimesCls:Class = null)
		{
			_baseCls = baseBarCls;
			_freeCls = freeBarCls;
			_freeAniCls = freeTimesCls;
			super();
		}
		
		public function get uiFreeControl():ISlotControl
		{
			if (!_uiFreeControl)
			{
				_uiFreeControl = new _freeCls(_uiControlMc["uiFree"]);	
			}
			
			return _uiFreeControl;
		}
		
		public function get currentControl():ISlotControl
		{
			if (GameGlobalRef.gameManager.isBaseGame || GameGlobalRef.gameManager.isPropGame)
			{
				return uiBaseControl;
			}
			else
			{
				return uiFreeControl;
			}
		}
		
		public function set enable(value:Boolean):void
		{
			currentControl.enable = value;
		}
		
		public function get uiBaseControl():ISlotControl
		{
			if (!_uiBaseControl)
			{
				_uiBaseControl = new _baseCls(_uiControlMc["uiBase"]);
			}
			return _uiBaseControl;
		}
		
		/**
		 * 更新FREE TIMES 动画 
		 * 
		 */		
		public function updateWildAni():void
		{
			if (_wildMc)
			{
				_wildMc.update(GameGlobalRef.freeGameInfo.freeGameIndex);
			}
		}
		
		public function updateAfterStop():void
		{
			if (_wildMc)
			{
				_wildMc.updateAfterReelStop(GameGlobalRef.freeGameInfo.isCurrentWin);
			}
		}
		
		public function updateBetInfo():void
		{
			currentControl.updateBetInfo();
		}
		
		override protected function init():void
		{
			_bgMc = GameAssetLibrary.getGameAssets(AssetDefined.UI_COMMON) as MovieClip;
			_bgMc = _bgMc["bg"];
			GameLayerManager.bglayer.addChild(_bgMc);
			
			_uiControlMc = GameAssetLibrary.getGameAssets(AssetDefined.UI) as MovieClip;
			
			if (GameSetting.useWinTrack)
			{
				_winTrackBar = new WinTrackBar(_uiControlMc["winTrack"]);
				_winTrackBar.setList(GameGlobalRef.gameData.winTrack);
			}
			
			changeGameMode(GameGlobalRef.gameManager.gameMode);
			
			
			
			super.init();
			
		}
		
		public function changeGameMode(type:String):void
		{
			if (type == SlotGameType.BASE_GAME || type==SlotGameType.POWER_SPIN)
			{
				_bgMc.gotoAndStop(1);
				uiBaseControl.show(this);
				if (_uiFreeControl)
				{
					uiFreeControl.hide();
				}
				if (_winTrackBar)
				{
					_winTrackBar.show(this);
				}
				
				DisplayUtil.bringToTop(currentControl as DisplayObject);
				removeWildMC();
			}
			else
			{
				_bgMc.gotoAndStop(2);
				uiFreeControl.show(this);
				uiBaseControl.hide();
				if (_winTrackBar)
				{
					_winTrackBar.hide();
				}
				
				addWildMC();
				if (!SoundManager.getSoundIsPlaying(SlotSoundDefined.FREE_GAME_BG))
				{
					SoundManager.playSound(SlotSoundDefined.FREE_GAME_BG);
				}
			}
		}
		
		private function addWildMC():void
		{
			if (!_wildMc && _freeAniCls != null)
			{
				_wildMc = new _freeAniCls();
			}
			
			if (_wildMc)
			{
				_wildMc.show();
				_wildMc.update(Math.max(1, GameGlobalRef.freeGameInfo.freeGameIndex), false, false);
			}
		}
		
		private function removeWildMC():void
		{
			if (_wildMc)
			{
				_wildMc.hide();
			}
		}
		
		public function reflushBall():void
		{
			if (GameSetting.useWinTrack && 
				(GameGlobalRef.gameManager.isBaseGame || GameGlobalRef.gameManager.isPropGame && GameGlobalRef.gameData.winTrack.length > 0))
			{
				_winTrackBar.pushBall(GameGlobalRef.gameData.winTrack[GameGlobalRef.gameData.winTrack.length - 1]);
			}
		}
		
		override public function restart():void
		{
			currentControl.restart();
		}
		
		override public function dispose():void
		{
			DisplayUtil.removeFromParent(_bgMc);
			_bgMc = _uiControlMc = null;
			if (_wildMc)
			{
				_wildMc.dispose();
				_wildMc = null;
			}
			if (_uiBaseControl)
			{
				_uiBaseControl.dispose();
				_uiBaseControl = null;
			}
			
			if (_uiFreeControl)
			{
				_uiFreeControl.dispose();
				_uiFreeControl = null;
			}
			
			if (_winTrackBar)
			{
				_winTrackBar.dispose();
				_winTrackBar = null;
			}
			
			super.dispose();
		}
	}
}