package com.aspectgaming.globalization.controller 
{
	
	import com.aspectgaming.core.ICustomLoader;
	import com.aspectgaming.event.AssetLoaderEvent;
	import com.aspectgaming.utils.LoggerUtil;
	
	import flash.utils.Dictionary;
	
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * AssetsLoader初始化  配置
	 * @author mason.li
	 * 
	 */	
	public class AssetLoaderInitCommand extends ModuleCommand
	{
		[Inject] 
		public var assetLoader:ICustomLoader;
		
		private const INGON_ERROR_PATH:Array = [
			"/image/"
		];
		
		public override function execute ( ):void
		{
			assetLoader.numConnections = 5;
			
			assetLoader.onChildOpen.add(onChildOpen);
			assetLoader.onError.add(onError);
		}
		
		private function onError(signal:ErrorSignal):void 
		{
			if (assetLoader.errorLoader && isIngon(assetLoader.errorLoader.id))
			{
				return;
			}
			
			assetLoader.onError.remove(onError);
			assetLoader.stop();
			
			var assEvent:AssetLoaderEvent = new AssetLoaderEvent(AssetLoaderEvent.ASSETS_LOADER_ERROR);
			assEvent.errorType = signal.type;
			assEvent.message = signal.message;
			this.dispatchToModules(assEvent);
		}
		
		private function isIngon(id:String):Boolean
		{
			for (var i:uint = 0; i < INGON_ERROR_PATH.length; i++)
			{
				if (id.indexOf(INGON_ERROR_PATH[i]) != -1)
				{
					return true;	
				}
			}
			return false;
		}
		
		private function onChildOpen(signal:LoaderSignal, loader:ILoader):void 
		{
			LoggerUtil.traceNormal("[AssetLoader]openFileID ", loader.id, " startLoading");
			this.dispatchToModules(new AssetLoaderEvent(AssetLoaderEvent.ASSETS_CHILD_OPEN));
		}
	}
	
}