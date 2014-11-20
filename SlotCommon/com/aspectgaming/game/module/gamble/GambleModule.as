package com.aspectgaming.game.module.gamble
{
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.constant.GambleSelectedType;
	import com.aspectgaming.game.constant.GambleType;
	import com.aspectgaming.game.constant.asset.AssetDefined;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.game.module.gamble.control.BmdToObj;
	import com.aspectgaming.game.module.gamble.control.CardReversal;
	import com.aspectgaming.game.module.gamble.control.SimpleButtonEx;
	import com.aspectgaming.globalization.managers.ModuleManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.tick.Tick;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	public class GambleModule extends BaseControlModule
	{
		//card
		private var _cardFx:CardReversal;
		private var _vObj:Object;
		//history
		private var _hisInfo:Array;
		private var _spHis:Sprite;
		private var _siW:int;
		private var _maxNum:int;
		//riskType
		private var _themark:MovieClip;
		private var _btnRiskHalf:SimpleButtonEx;
		private var _btnRiskAll:SimpleButtonEx;
		private var _txtRiskAll:TextField;
		private var _txtRiskHalf:TextField;
		private var _betHalf:Boolean;  // 0 : ALl   1 : Half
		private var _betValue:int;
		private var _pickValue:int;
		//winText
		private var _txtWin:TextField;
		private var _btnTakewin:SimpleButtonEx;
		//buttons
		private var _btn0:SimpleButtonEx;	// Black
		private var _btn1:SimpleButtonEx;	// Red
		private var _btn2:SimpleButtonEx;	//B-tao
		private var _btn3:SimpleButtonEx;   //B-mei
		private var _btn4:SimpleButtonEx;   //R-fang
		private var _btn5:SimpleButtonEx;   //R-tao
		//state
		private var _state_mc:MovieClip;
		public function GambleModule(mc:MovieClip=null)
		{
			super(mc);
		}
		
		override protected function init():void
		{
			var uiAsset:DisplayObject = GameAssetLibrary.getGameAssets(AssetDefined.GAMEBLE);
			_mc = uiAsset["uiGamble"];
			addChild(_mc);
			
			_btnRiskHalf 	= new SimpleButtonEx(_mc.btnRiskHalf);		// riskHalf
			_btnRiskAll		= new SimpleButtonEx(_mc.btnRiskAll);
			
			_themark = 	_mc.themark;
			
			_state_mc = _mc.state_mc;
			changeTips(-1)
			
			_cardFx = new CardReversal(_mc.card)
			
			_txtRiskAll = _mc._txtAll as TextField;
			_txtRiskHalf = _mc._txtHalf as TextField;
			_txtWin = _mc._txtWin as TextField;
			
			_btn1 = new SimpleButtonEx(_mc.btn1);
			_btn0 = new SimpleButtonEx(_mc.btn0);
			_btn4 = new SimpleButtonEx(_mc.btn4);
			_btn2 = new SimpleButtonEx(_mc.btn2);
			_btn5 = new SimpleButtonEx(_mc.btn5);
			_btn3 = new SimpleButtonEx(_mc.btn3);
			_btnTakewin	= new SimpleButtonEx(_mc.btnTakewin);
			
			_siW = (GameAssetLibrary.gambleHistory.getDisplayObject("" + GambleSelectedType.BLACK_TAO).width + 2);
			_maxNum = _mc.his_mask.width / _siW;
			
			_hisInfo = new Array;
			_spHis 	 = new Sprite;
			_spHis.x = _mc.his_mask.x + 1;
			_spHis.y = _mc.his_mask.y + 1 + ((_mc.his_mask.height-GameAssetLibrary.gambleHistory.getDisplayObject("" + GambleSelectedType.BLACK_TAO).height)>>1);
			_mc.addChild(_spHis);
			_spHis.mask = _mc.his_mask;
			setValue(_txtRiskAll,0);
			setValue(_txtRiskHalf,0);
			resetMarkPos(_mc.btnRiskAll as DisplayObject);
			setValue(_txtWin,0);
			super.init();
		}
		
		override public function show(par:DisplayObjectContainer, x:Number=0, y:Number=0):void
		{
			this.visible = false;
			super.show(par, x, y);
		}
		
		
		public function get isShow():Boolean
		{
			return this.parent != null;
		}
		
		
		public function start(allWager:Number, totalWon:int):void
		{
			this.visible = true;
			this.mouseEnabled = this.mouseChildren = true;
			_hisInfo = GameGlobalRef.gambleInfo.history;
			redrawHistorybar();
			
			changeTips(-1);
			_cardFx.reversalBack(true);
			setBtns(true);
			
			_betValue = _betHalf == false ? allWager : Number(allWager >>1);
			setValue(_txtRiskAll,allWager);
			setValue(_txtRiskHalf,Number(allWager >>1));
			resetMarkPos(_mc.btnRiskAll as DisplayObject);
			_betHalf = false;
			setValue(_txtWin,totalWon);
			
			if(GameGlobalRef.gambleInfo.currentIndex == 0) onClick_(0, "btnRiskAll", true);
		}
		//gamble win\gamble lost\空状态
		private function changeTips(isWin:int):void
		{
			if (isWin==1) {
				_state_mc.gotoAndStop(1);
				
			}else if (isWin==0) {
				_state_mc.gotoAndStop(2);
				
			}else {
				_state_mc.gotoAndStop(3);
			}
		}
		
		override protected function addEvent():void
		{
			_mc.addEventListener(MouseEvent.CLICK, onClickGambleEls);
		}
		
		override protected function removeEvent():void
		{
			_mc.removeEventListener(MouseEvent.CLICK, onClickGambleEls);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		//更新gamble状态
		public function update(isWin:Boolean, curCard:int, totalWon:Number = -1):void 
		{
			addAndDrawHisbar(curCard, isWin);
			redrawCard(curCard);
			if(totalWon != -1) setValue(_txtWin,totalWon);
			if (isWin) {
				setValue(_txtRiskAll,GameGlobalRef.gambleInfo.gambleWager);
				setValue(_txtRiskHalf,Number(GameGlobalRef.gambleInfo.gambleWager >>1));
				changeTips(1);
				setTimeout(_cardFx.reversalBack, 1500);
				setTimeout(setBtns,2000,true)
				SoundManager.playSound(SlotSoundDefined.GAMBLE_WIN);
			}else {
				changeTips(0);
				SoundManager.playSound(SlotSoundDefined.GAMBLE_LOSE);
				setBtnTakewin();
				exit();
			}
		}
		private function onClickGambleEls(e:MouseEvent):void 
		{
			if(_btn0.enabledEx)	onClick_( -1, e.target.name);
		}
		private function onClick_(idx:int, info:String, emnu:Boolean = false):void 
		{
			var obj:Object;
			trace("onClick_",idx,info)
			switch(info) 
			{
				case "btnRiskAll" :		// btnRiskAll	riskAll
					_betHalf = false;
					_betValue = getValue(_txtRiskAll);
					
					resetMarkPos(_mc.btnRiskAll as DisplayObject);
					if(!emnu){
						SoundManager.playSound(SlotSoundDefined.BUTTON_CLICK);
					}
					break;
				case "btnRiskHalf" :		// btnRiskHalf	riskHalf
					_betHalf = true;
					_betValue = getValue(_txtRiskHalf);
					resetMarkPos(_mc.btnRiskHalf as DisplayObject);
					if(!emnu){
						SoundManager.playSound(SlotSoundDefined.BUTTON_CLICK);
					}
					break;
				
				case "btn0" :
				case "btn1" :
					
				case "btn2" :
				case "btn3" :
				case "btn4" :
				case "btn5" :
					_pickValue = int(info.substr(3));
					setBtns();
					obj = { betHalf:betHalf, betValue:betValue, pickValue:pickValue };
					dispatchToContext(new SlotEvent(SlotEvent.GAMBLE_GAME,obj,GambleType.GAMBLE_SELECT))
					break;
				
				case "goAgain" :
					break;
				case "btnTakewin" :	// takeWin
//					SoundLibApp.This().playSound("Gb_takewin");
					SoundManager.playSound(SlotSoundDefined.GAMBLE_TAKEWIN);
					dispatchToContext(new SlotEvent(SlotEvent.GAMBLE_GAME, null, GambleType.GAMBLE_TAKEWIN));
					_btnTakewin.enabledEx = false;
					setBtnsExTakewin();
					break;
			}
		}
		
		private function resetMarkPos(sp:DisplayObject):void 
		{
			//trace("resetMarkPos =",_betHalf ,_betValue )
			_themark.x = sp.x + sp.width - 15;
			_themark.y = sp.y + sp.height -25;
		}
		
		private function setBtnsExTakewin(v:Boolean = false):void 
		{
			_btn0.enabledEx = v;
			_btn1.enabledEx = v;
			_btn2.enabledEx = v;
			_btn3.enabledEx = v;
			_btn4.enabledEx = v;
			_btn5.enabledEx = v;
			_btnRiskAll.enabledEx = v;
			_btnRiskHalf.enabledEx = v;
		}
		
		public function setBtnTakewin(v:Boolean = false):void 
		{
			_btnTakewin.enabledEx = v;	
		}
		
		public function setBtns(v:Boolean = false):void {
			setBtnsExTakewin(v);
			setBtnTakewin(v);
		}
		private function setValue(text:TextField,num:Number):void{
			trace("setValue",text.name,num)
			text.text = ""+ num;
		}
		private function getValue(text:TextField):Number{
			return Number(text.text)
		}
		//history
		private function addAndDrawHisbar(curCard:int, isWin:Boolean = false):void 
		{
			_hisInfo.unshift(curCard);
			if (_hisInfo.length > 25) _hisInfo.pop();
			
			redrawHistorybar();
		}
		private function redrawHistorybar():void 
		{
			if (_spHis != null) clean(_spHis);
			for (var i:int = 0; i < _hisInfo.length; i++ ) {
				if (i > _maxNum) break;		//20;
				var cardid:int = int(_hisInfo[i]) + 2;
				var his:DisplayObject = GameAssetLibrary.gambleHistory.getDisplayObject("" + cardid);
				if(his != null){
					his.x = i * _siW;	//22;
					_spHis.addChild(his);
				}
			}
		}
		private function clean(sp:Sprite):void 
		{
			while (sp.numChildren != 0) sp.removeChildAt(0);
		}
		private function redrawCard(idx:int):void 
		{
			//翻转动画
			if(_cardFx != null)
			{
				if (idx == 4) 
				{
					_cardFx.reversalBack();
				}
				else 
				{
					_cardFx.reversal(idx + 1);
				}
			}else {
				_mc.card.gotoAndStop(idx + 1);
			}
		}
		public function gamebleEnd():void
		{
			GameGlobalRef.gameManager.gameTick.addTimeout(sendEnd, 2);
		}
		private function sendEnd():void
		{
			this.mouseEnabled = this.mouseChildren = false;
			dispatchToContext(new SlotEvent(SlotEvent.GAMBLE_GAME, null, GambleType.GAMBLE_END));
		}
		
		public function get betHalf():Boolean { return _betHalf; }
		public function get betValue():int { return _betValue; }
		
		public function get pickValue():int { return _pickValue; }
		public function exit(pending:Number = 1.5):void 
		{
			GameGlobalRef.gameManager.gameTick.addTimeout(closeGamble, pending, null, 500);
		}
		
		private function closeGamble():void
		{
			this.visible = false;
			dispatchToContext(new SlotUIEvent(SlotUIEvent.SHOW_GAMBLE, false));
			dispatchToContext(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.PLAY_AGAIN)));
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_STATUE_CHANGE, "", "", false));
		}
	}
}