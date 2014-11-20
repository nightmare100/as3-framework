package com.aspectgaming.popup.alert
{
	import com.aspectgaming.popup.data.AlertInfo;
	import com.aspectgaming.popup.AlertManager;
	import com.aspectgaming.popup.alert.IAlert;
	import com.aspectgaming.utils.DomainUtil;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	[Event(type="flash.events.Event",name="close")]
	
	/**
	 *简单提示框 
	 * @author tb
	 * 
	 */	
	public class Alert extends Sprite implements IAlert
	{
		public var offset:Point = new Point(0, 0);
		private var _ui:MovieClip;
		private var _confirmBtn:SimpleButton;
		private var _contentTxt:TextField;
		
//		private var _content:String;
		private var _closeHandler:Function;
		
		public function Alert()
		{
			initialize();			
		}
		
		private function initialize():void
		{
			this.mouseEnabled = false;
			_ui = DomainUtil.getMovieClip("UI_Alert");
			if (_ui)
			{
				_confirmBtn = _ui["confirmBtn"];
				_confirmBtn.addEventListener(MouseEvent.CLICK, onConfirmBtnClick);
				
				_contentTxt = _ui["contentTxt"];
				addChild(_ui);
			}
		}
		
		// 显示 Alert
		public function show(info:AlertInfo):void
		{
			if (_ui)
			{
				_contentTxt.htmlText = info.initInfo.message ;
				_closeHandler = info.initInfo.closeHandler ;
				
				AlertManager.addPopUp(info,this);
			}
		}
		
		public function dispose():void {
			_closeHandler = null;
			_ui = null ;
			_confirmBtn.removeEventListener(MouseEvent.CLICK, onConfirmBtnClick);
			_confirmBtn = null ;
			_contentTxt = null ;
			AlertManager.removePopUp(this);
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		protected function onConfirmBtnClick(evt:MouseEvent):void
		{
			if(_closeHandler != null)
			{
				_closeHandler();
			}
			
			dispose();		
		}
	}
}