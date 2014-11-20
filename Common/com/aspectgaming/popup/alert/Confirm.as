package com.aspectgaming.popup.alert	
{
	import com.aspectgaming.popup.data.AlertInfo;
	import com.aspectgaming.popup.AlertManager;
	import com.aspectgaming.utils.DomainUtil;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 确认取消框 
	 * @author mason.li
	 * 
	 */	
	public class Confirm extends Sprite implements IAlert
	{
		protected var _ui:MovieClip;
		protected var _confirmBtn:SimpleButton;
		protected var _cancelBtn:SimpleButton;
		protected var _contentTxt:TextField;

//		private var _content:String;
		protected var _confirmHandler:Function;
		protected var _cancelHandler:Function;

		public function Confirm()
		{
			mouseEnabled = false;
			init();
		}
		
		public function init():void
		{
			_ui = DomainUtil.getMovieClip("UI_Confirm");
			_confirmBtn = _ui["confirmBtn"];
			_confirmBtn.addEventListener(MouseEvent.CLICK, onConfirmBtnClick);
			
			_cancelBtn = _ui["cancelBtn"];
			_cancelBtn.addEventListener(MouseEvent.CLICK, onCancelBtnClick);
			
			_contentTxt = _ui["contentTxt"];
			addChild(_ui);
		}

		public function show(info:AlertInfo):void
		{
			_contentTxt.htmlText = info.initInfo.message;
			_confirmHandler = info.initInfo.confirmHandler;
			_cancelHandler = info.initInfo.cancelHandler;

			AlertManager.addPopUp(info,this) ;
		}

		public function dispose():void
		{
			_cancelHandler = null ;			
			_confirmHandler = null;
			_ui = null ;
			
			_confirmBtn.removeEventListener(MouseEvent.CLICK, onConfirmBtnClick);
			_cancelBtn.removeEventListener(MouseEvent.CLICK, onCancelBtnClick);
			_confirmBtn = null ;
			_contentTxt = null ;
			_cancelBtn = null ;
			AlertManager.removePopUp(this);
			this.dispatchEvent(new Event(Event.CLOSE));
		}

		protected function onConfirmBtnClick(evt:MouseEvent):void
		{
			if (_confirmHandler != null)
			{
				_confirmHandler();
				_confirmHandler = null;
			}
			dispose();
//			evt.stopImmediatePropagation();
		}

		protected function onCancelBtnClick(evt:MouseEvent):void
		{
			if (_cancelHandler != null)
			{
				_cancelHandler();
				_cancelHandler = null;
			}
			dispose();
			evt.stopImmediatePropagation();
		}
	}
}
