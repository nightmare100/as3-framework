package com.aspectgaming.ui 
{
	import com.aspectgaming.constant.JSMethodType;
	import com.aspectgaming.event.LobbyEvent;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.ui.base.BaseView;
	import com.aspectgaming.ui.constant.UIDictionary;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.DomainUtil;
	import com.aspectgaming.utils.ExternalUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Mason.Li
	 */
	public class ReconnectBox extends BaseView 
	{
		private static var _instance:ReconnectBox;
		
		public function ReconnectBox()
		{
		    _mc = DomainUtil.getMovieClip(UIDictionary.AssetUITag + UIDictionary.AssetReconnectBox, ApplicationDomain.currentDomain);
		    super();
		}
		
		public static function show():void
		{
		    getInstance().show(LayerManager.noticeLayer);
			getInstance().dispatchEvent(new LobbyEvent(LobbyEvent.RECONNECT_SHOW));
		}
		
		public static function hide():void
		{
		    getInstance().hide();
		    
		}
		
		
		override protected function addEvent():void
		{
		    _mc.connectBtn.addEventListener(MouseEvent.CLICK, onReconnectClick);
		}
		
		override protected function removeEvent():void
		{
		    _mc.connectBtn.removeEventListener(MouseEvent.CLICK, onReconnectClick);
		}
		
		override protected function initView():void
		{
			_mc["tip"].gotoAndStop(ClientManager.currentLanuage);
			_mc["connectBtn"].gotoAndStop(ClientManager.currentLanuage);
			super.initView();
		}
		
		
		private function onReconnectClick(e:MouseEvent):void
		{
			ExternalUtil.call(JSMethodType.PAGE_REFLUSH);
			hide();
		}
		
		public static function getInstance():ReconnectBox
		{
		    if (!_instance)
		    {
			    _instance = new ReconnectBox();
		    }
		    return _instance;
		}
	}

}