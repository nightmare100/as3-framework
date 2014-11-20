package com.aspectgaming.game.module.game.winshow
{
	import com.aspectgaming.animation.iface.IAnimation;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.reel.ReelInfo;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.config.text.LanguageReplaceTag;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.constant.GameTickConstant;
	import com.aspectgaming.game.core.IWinShow;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.game.module.game.iface.ILineMaster;
	import com.aspectgaming.game.utils.SlotUtil;
	import com.aspectgaming.game.utils.WinShowUtil;
	import com.aspectgaming.utils.BitmapDataUtil;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * WinShow窗口 
	 * @author mason.li
	 * 
	 */	
	public class WinShowView extends BaseControlModule implements IWinShow
	{
		/**
		 * winner Message 显示时间 
		 */		
		private const WIN_MSG_DELAY:uint = 2;
		/**
		 * winshow变换间隔 
		 */		
		private const CHANGED_DELAY:uint = 2;
		private var _currentIdx:uint;
		private var _currentLines:Vector.<LineInfo>;
		private var _lineMc:MovieClip;
		
		//[Change by Kumo for WinLineBox.*]
		protected var _lineMaster:ILineMaster;
		//[Change by Kumo for WinLineBox.*]
		
		private var _currentLine:LineInfo;
		
		/**
		 * 每条线消息都是否发送过了 
		 */		
		private var _isMsgWordEnd:Boolean;
		
		public function WinShowView(mc:MovieClip=null)
		{
			super(mc);
		}
		
		public function showWinLine(lines:Vector.<LineInfo>, totalWin:Number, needAutoShow:Boolean = true):void
		{
			_currentLines = lines;
			
			if (totalWin > 0)
			{
				//SOUND
				var winWord:String = GameLanguageTextConfig.getLangText(ConfigTextDefined.WINNER);
				winWord = winWord.replace(LanguageReplaceTag.CREDIT, totalWin);
				dispatchToContext(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, winWord));
				
				if (needAutoShow && GameSetting.hasWinLine)
				{
					GameGlobalRef.gameManager.gameTick.addTimeout(startShow, WIN_MSG_DELAY, GameTickConstant.WIN_MSG_TICK);
				}
				else
				{
					startShow();
				}
			}
			else
			{
				startShow();
			}
		}
		
		private function startShow():void
		{
			_lineMaster.hideAllLine();
			GameGlobalRef.gameManager.gameTick.removeTimeout(GameTickConstant.WIN_MSG_TICK);
			if (_currentLines && _currentLines.length > 0)
			{
				clear();
				_currentLine = _currentLines[_currentIdx];
				if (!_currentLine.instance)
				{
					_currentLine.instance = getLineObject(_currentLine);
				}
				
				WinShowUtil.winShowChildProcess(this, _currentLine);

				if (!_isMsgWordEnd || GameGlobalRef.gameData.isFreeGameStatue || GameSetting.isWinshowLoop)
				{
					dispatchToContext(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, _currentLine.winMessageWord));
					dispatchEvent(new SlotUIEvent(SlotUIEvent.SINGLE_WINSHOW_START,_currentLine));
				}
					
				GameGlobalRef.gameManager.gameTick.addTimeout(showChanged, CHANGED_DELAY, GameTickConstant.WIN_SHOW_TICK);
			}
		}
		
		private function showChanged():void
		{
			if (!_isMsgWordEnd && _currentLines.length - 1 == _currentIdx)
			{
				if (!GameGlobalRef.gameData.isFreeGameStatue)
				{
					dispatchToContext(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.GAMBLE_OR_PLAY)));
				}
				_isMsgWordEnd = true;
				dispatchToContext(new SlotUIEvent(SlotUIEvent.WIN_SHOW_END));
				if (GameGlobalRef.gameData.isFreeGameStatue)
				{
					return;
				}
			}
			
			if (_currentLines.length > 1 || GameSetting.isWinshowLoop)
			{
				WinShowUtil.clearChild();
				_currentIdx = _currentIdx >= _currentLines.length - 1 ? 0 : (_currentIdx + 1);
				startShow();
			}
		}
		
		public function stop():void
		{
			GameGlobalRef.gameManager.gameTick.removeTimeout(GameTickConstant.WIN_SHOW_TICK);
			GameGlobalRef.gameManager.gameTick.removeTimeout(GameTickConstant.WIN_MSG_TICK);
			WinShowUtil.clearChild(true);
			_isMsgWordEnd = false;
			_currentIdx = 0;
			clear();
		}
		
		/**
		 * 清除所有 动画 
		 * 
		 */	
		private function clear():void
		{
			if (_currentLine)
			{
				DisplayUtil.removeFromParent(_currentLine.instance);
				_currentLine = null;
			}
		}
		
		//[Change by Kumo for WinLineBox.**]
		protected function getLineObject(info:LineInfo):DisplayObject
		{
			var lineObj:DisplayObject = _lineMaster.getLineObj(info.lineIndex);
			var lineColor:uint = BitmapDataUtil.getLineColor(lineObj);
			
			return SlotUtil.madeWinLineBox(lineObj, info.symbloRects, lineColor, GameSetting.winLine.isOutSide, GameSetting.winLine.thickness); 
		}
		//[Change by Kumo for WinLineBox.**]
		
		public function set lineMaster(value:ILineMaster):void
		{
			_lineMaster = value;
		}
		
		
		override public function dispose():void
		{
			stop();
			_lineMc = null;
			_currentLines = null;
			_lineMaster = null;
			super.dispose();
		}
		
		
		
	}
}