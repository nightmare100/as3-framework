package com.aspectgaming.ui.loading
{
	import com.aspectgaming.globalization.managers.LayerManager;
	//import com.aspectgaming.ui.SimpleProgressBar;
	import com.aspectgaming.ui.base.BaseView;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.DomainUtil;
	//import com.aspectgaming.utils.LanguageUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	/**
	 * 公用外部模块加载进度条 
	 * @author mason.li
	 * 
	 */	
	public class CommonLoadingBar extends BaseView
	{
		private static var _instance:CommonLoadingBar;

		private static function getInstance():CommonLoadingBar
		{
			if (!_instance)
			{
				_instance = new CommonLoadingBar();
			}
			return _instance;
		}
		
		public static function show(lookAt:Loader):void
		{
			getInstance().show(LayerManager.noticeLayer);
			getInstance().look(lookAt);
		}
		
		public static function isUsedBy(loader:Loader):Boolean
		{
			return getInstance().parent && getInstance().currentObserver == loader;
		}
		
		/********************************************/
		
//		private var _progressBar:SimpleProgressBar;
//		private var _progressText:TextField;
		private var _currentObserver:Loader;
		
		public function CommonLoadingBar()
		{
			super();
		}
		
		public function get currentObserver():Loader
		{
			return _currentObserver;
		}
		
		override protected function addEvent():void
		{
			// TODO Auto Generated method stub
			super.addEvent();
		}
		
		override protected function initView():void
		{
			_mc = DomainUtil.getMovieClip("Common_Loading");
//			_progressText = _mc["LoadingText"];
//			_progressBar = new SimpleProgressBar(_mc["loadingbar"]);
			super.initView();
			drawMask();
			DisplayUtil.align(_mc);
		}
		
		private function drawMask():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.6);
			this.graphics.drawRect(0, 0, LayerManager.stageWidth, LayerManager.stageHeight);
			this.graphics.endFill();
		}
		
		public function look(loader:Loader):void
		{
			clearLoader();
			_currentObserver = loader;
			_currentObserver.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_currentObserver.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		public function update(value:int):void
		{
//			_progressBar.data = value;
//			_progressText.text = LanguageUtil.loading + " " + value + "%";
			
			if (value >= 100)
			{
				hide();
			}
		}
		
		override public function show(layer:DisplayObjectContainer=null, alignType:int=4):void
		{
			super.show(layer, alignType);
			clearLoader();
//			_progressBar.data = 0;
//			_progressText.text = "";
		}
		
		private function clearLoader():void
		{
			if (_currentObserver)
			{
				_currentObserver.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				_currentObserver.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			}
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			update(Math.round( e.bytesLoaded / e.bytesTotal * 100 ));
		}
		
		private function onError(e:IOErrorEvent):void
		{
			clearLoader();
			hide();
		}
		
		
		override public function dispose():void
		{
			clearLoader();
			_currentObserver = null;
//			_progressBar.dispose();
//			_progressBar = null;
//			_progressText = null;
			super.dispose();
		}
	}
}