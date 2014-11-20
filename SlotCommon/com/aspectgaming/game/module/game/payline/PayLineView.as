package com.aspectgaming.game.module.game.payline
{
	import com.aspectgaming.game.component.tips.ChatPopUpTips;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.config.text.LanguageReplaceTag;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.asset.AssetDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.winshow.LineInfo;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.game.module.game.iface.ILineMaster;
	import com.aspectgaming.game.module.game.iface.IPayLine;
	import com.aspectgaming.utils.BitmapDataUtil;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * PayLine 显示  PayLine 线动画 
	 * @author mason.li
	 * 
	 */	
	public class PayLineView extends BaseControlModule implements IPayLine
	{
		/**
		 * fadeout间隔 
		 */		
		private const FADE_OUT_DURATION:Number = 0.05;
		private const SHOW_DELAY:uint = 2;
		private const LINE_TAG:String = "L";
		private const LINE_BTN_TAG:String = "bh";
		
		/**
		 * 线按钮组合 
		 */		
		private var _lineBtnListMc:MovieClip;
		private var _lineRefObject:Object;
		
		public function PayLineView(mc:MovieClip=null)
		{
			super(mc);
		}
		
		public function updateButton(isInit:Boolean = false):void
		{
			showButtonList();
			if (!isInit)
			{
				GameGlobalRef.gameManager.gameTick.removeTimeout(getQualifiedClassName(this));
				showLineList();
			}
		}
		
		/**
		 * 隐藏所有线 
		 * 
		 */		
		public function hideAllLine():void
		{
			GameGlobalRef.gameManager.gameTick.removeTimeout(getQualifiedClassName(this));
			for (var key:String in _lineRefObject)
			{
				SimpleLine(_lineRefObject[key]).visible = false;
			}
		}
		
		public function stopLineApi():void
		{
			hideAllLine();
			if (GameGlobalRef.gameManager.isAutoPlay)
			{
				removeHoverEvent();
			}
			else
			{
				removeEvent();
			}
		}
		
		public function getLineObj(idx:uint):DisplayObject
		{
			return _mc[LINE_TAG + idx];
		}
		
		/**
		 * 显示自动游戏的线条 
		 * @param lines
		 * 
		 */		
		public function showAutoLine(lines:Vector.<LineInfo>):void
		{
			if (lines)
			{
				for each (var info:LineInfo in lines)
				{
					var lineObj:SimpleLine = SimpleLine(_lineRefObject[info.lineIndex]);
					lineObj.visible = true;
				}
				var winWord:String = GameLanguageTextConfig.getLangText(ConfigTextDefined.WINNER);
				winWord = winWord.replace(LanguageReplaceTag.CREDIT, GameGlobalRef.gameData.totalWin);
				dispatchToContext(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, winWord));
			}
		}
		
		/**
		 * 轮子停止之后  添加线条事件
		 * 
		 */		
		public function processReelStop():void
		{
			addEvent();
		}
		
		override protected function init():void
		{
			var uiAsset:MovieClip = GameAssetLibrary.getGameAssets(AssetDefined.UI_COMMON);
			_lineBtnListMc = uiAsset["lineHead"];
			addChild(_lineBtnListMc);
			updateButton(true);
			initLine();
			super.init();
		}
		
		private function initLine():void
		{
			_lineRefObject = {};
			for (var i:uint = 1; i <= GameSetting.maxLineNum; i++)
			{
				_lineRefObject[i] = new SimpleLine(_mc[LINE_TAG + i]);
			}
		}
		
		override protected function addEvent():void
		{
			addBtnEvent();
			addHoverEvent();
		}
		
		public function addBtnEvent():void
		{
			for (var i:uint = 1; i <= GameSetting.maxLineNum; i++)
			{
				var lineBtn:MovieClip = _lineBtnListMc[LINE_BTN_TAG + i];
				lineBtn.buttonMode = true;
				lineBtn.addEventListener(MouseEvent.CLICK, onLineClick);
			}
		}
		
		private function onLineClick(e:MouseEvent):void
		{
			if (GameGlobalRef.gameManager.isAutoPlay || GameGlobalRef.gameManager.isInFreeGame)
			{
				var target:DisplayObject = e.currentTarget as DisplayObject;
				ChatPopUpTips.show(target as InteractiveObject, GameLanguageTextConfig.getLangText(ConfigTextDefined.Click_linehead));
			}
			else
			{
				var name:String = e.currentTarget.name;
				var lineNum:uint = uint(name.substr(LINE_BTN_TAG.length));
				
				GameGlobalRef.gameManager.currentBetLine = lineNum;
			}
		}
		
		private function onLineHover(e:MouseEvent):void
		{
			var name:String = e.currentTarget.name;
			var lineIdx:String = name.substr(LINE_BTN_TAG.length);
			if (e.type == MouseEvent.ROLL_OVER)
			{
				_lineRefObject[lineIdx].visible = true;
			}
			else
			{
				_lineRefObject[lineIdx].visible = false;
			}
		}
		
		override protected function removeEvent():void
		{
			for (var i:uint = 1; i <= GameSetting.maxLineNum; i++)
			{
				var lineBtn:MovieClip = _lineBtnListMc[LINE_BTN_TAG + i];
				lineBtn.removeEventListener(MouseEvent.CLICK, onLineClick);
				lineBtn.buttonMode = false;
			}
			removeHoverEvent();
		}
		
		private function removeHoverEvent():void
		{
			for (var i:uint = 1; i <= GameSetting.maxLineNum; i++)
			{
				var lineBtn:MovieClip = _lineBtnListMc[LINE_BTN_TAG + i];
				lineBtn.removeEventListener(MouseEvent.ROLL_OVER, onLineHover);
				lineBtn.removeEventListener(MouseEvent.ROLL_OUT, onLineHover);
			}
		}
		
		private function addHoverEvent():void
		{
			for (var i:uint = 1; i <= GameSetting.maxLineNum; i++)
			{
				var lineBtn:MovieClip = _lineBtnListMc[LINE_BTN_TAG + i];
				lineBtn.addEventListener(MouseEvent.ROLL_OVER, onLineHover);
				lineBtn.addEventListener(MouseEvent.ROLL_OUT, onLineHover);
			}
		}
		
		private function showButtonList():void
		{
			var currentLine:uint = GameSetting.maxLineNum;
			while (currentLine > 0)
			{
				var currentBtnObj:MovieClip = _lineBtnListMc[LINE_BTN_TAG + currentLine];
				if (currentBtnObj)
				{
					if (currentLine > GameGlobalRef.gameManager.currentBetLine)
					{
						currentBtnObj.gotoAndStop(2);
					}
					else
					{
						currentBtnObj.gotoAndStop(1);
					}
				}
					
				currentLine--;
			}
		}
		
		/**
		 * 显示当前下注的线 带消除动画 
		 * 
		 */		
		private function showLineList():void
		{
			var currentLine:uint = GameSetting.maxLineNum;
			while (currentLine > 0)
			{
				var currentBtnObj:SimpleLine = _lineRefObject[currentLine];
				if (currentBtnObj)
				{
					if (currentLine > GameGlobalRef.gameManager.currentBetLine)
					{
						currentBtnObj.visible = false;
					}
					else
					{
						currentBtnObj.visible = true;
					}
				}
				currentLine--
			}
			removeHoverEvent();
			GameGlobalRef.gameManager.gameTick.addTimeout(doFadeOut, SHOW_DELAY, getQualifiedClassName(this));
		}
		
		/**
		 * 线条渐出 
		 * 
		 */		
		private function doFadeOut():void
		{
			for (var i:uint = 1; i <= GameSetting.maxLineNum; i++)
			{
				var sline:SimpleLine = _lineRefObject[i] as SimpleLine;
				if (sline && sline.visible)
				{
					if (i == GameGlobalRef.gameManager.currentBetLine)
					{
						sline.fadeOut((i - 1) * FADE_OUT_DURATION, addHoverEvent);
					}
					else
					{
						sline.fadeOut((i - 1) * FADE_OUT_DURATION);
					}
				}
			}
		}
		
		public function set enabled(value:Boolean):void
		{
			this.mouseEnabled = this.mouseChildren = value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			DisplayUtil.removeFromParent(_lineBtnListMc);
			_lineRefObject = null;
		}
		
		
	}
}