package com.aspectgaming.globalization.controller
{
	import com.aspectgaming.cache.LoaderCache;
	import com.aspectgaming.core.ICustomLoader;
	import com.aspectgaming.data.loading.AssetProgressInfo;
	import com.aspectgaming.data.loading.LoadingDataInfo;
	import com.aspectgaming.data.loading.LoadingListInfo;
	import com.aspectgaming.event.AssetLoaderEvent;
	import com.aspectgaming.event.GlobalEvent;
	import com.aspectgaming.utils.LoggerUtil;
	import com.aspectgaming.utils.StringUtil;
	
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import org.assetloader.base.AssetType;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * 加载资源控制器 
	 * @author mason.li
	 * 
	 */	
	public class AssetLoaderCommand extends ModuleCommand
	{
		[Inject] 
		public var assetLoader:ICustomLoader;
		
		[Inject]
		public var globalEvent:GlobalEvent;
		
		private var _assets:Dictionary;
		
		override public function execute():void
		{
			_assets = new Dictionary();
			
			for (var i:uint = 0;i < loadingInfo.vec.length; i++)
			{
				if (assetLoader.getLoader(loadingInfo.vec[i].id) == null)
				{
					assetLoader.add(loadingInfo.vec[i].id, new URLRequest( loadingInfo.vec[i].url), "AUTO", loadingInfo.vec[i].parm);
				}
				else
				{
					_assets[loadingInfo.vec[i].id] = assetLoader.getLoader(loadingInfo.vec[i].id);
					loadingInfo.setComplete(loadingInfo.vec[i].id);
				}
				
				if (isSaveToCustomCache)
				{
					LoaderCache.saveCache(loadingInfo.vec[i].id, assetLoader.getLoader(loadingInfo.vec[i].id), globalEvent.value);
				}
			}
			
			if (loadingInfo.isComplete)
			{
				doComplete();
				return;
			}
			
			assetLoader.onChildComplete.add(onChildComplete);
			
			if (loadingInfo.progressFunc != null)
			{
				assetLoader.onProgress.add(onProgress);
			}
			
			assetLoader.start();
		}
		
		public function get loadingInfo():LoadingListInfo
		{
			return (globalEvent.obj as LoadingListInfo);
		}
		
		public function get isSaveToCustomCache():Boolean
		{
			return !StringUtil.isEmptyString(globalEvent.str);
		}
		
		private function onChildComplete(signal:LoaderSignal, loader:ILoader):void 
		{
//			trace("Load Asset " +loader.id + " Completed");
			
			var assets:Dictionary = new Dictionary();
			assets[loader.id] = loader;

			this.dispatchToModules(new AssetLoaderEvent(AssetLoaderEvent.ASSETS_CHILD_COMPLETED, assets));
			
			//判断所有资源是否加载完成
			if (loadingInfo.isInList(loader.id))
			{
				loadingInfo.setComplete(loader.id);
				_assets[loader.id] = loader;
			}
			
			if (loadingInfo.isComplete)
			{
				doComplete();
			}
		}
		
		private function onProgress(signal:ProgressSignal):void 
		{
			if (signal.loader is ICustomLoader && loadingInfo.isInList(signal.progressID))
			{
				if (signal.bytesLoaded / signal.bytesTotal > 1)
				{
					return;
				}
				
				var progressInfo:AssetProgressInfo = new AssetProgressInfo();
				progressInfo.id = signal.loader.id;
				progressInfo.progress = loadingInfo.getCompletePrefect(signal.bytesLoaded / signal.bytesTotal, signal.progressID);
				progressInfo.speed = signal.speed;
				progressInfo.averageSpeed = signal.averageSpeed;
				loadingInfo.progressFunc(progressInfo);
			}
		}
		
		private function doComplete():void 
		{
			LoggerUtil.traceNormal("Assets Load Completed")
			assetLoader.onProgress.remove(onProgress);
			assetLoader.onChildComplete.remove(onChildComplete);
//			assetLoader.stop();
			
			
			if (loadingInfo.completeFunc != null)
			{
				loadingInfo.completeFunc(_assets);
			}
			else
			{
				this.dispatchToModules(new AssetLoaderEvent(AssetLoaderEvent.ASSETS_LOADER_COMPLETED, _assets));
			}
			
			
			//干缓存
			if (!loadingInfo.needCache)
			{
				for each (var info:LoadingDataInfo in loadingInfo.vec)
				{
					assetLoader.remove(info.id);
				}
			}
		}
		
	}
}