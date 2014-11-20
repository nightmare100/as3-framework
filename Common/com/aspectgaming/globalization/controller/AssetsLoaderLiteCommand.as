package com.aspectgaming.globalization.controller 
{
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.event.AssetLoaderEvent;
	import com.aspectgaming.event.AssetProgressEvent;
	import com.aspectgaming.event.GameErrorEvent;
	
	import flash.utils.Dictionary;
	
	import org.assetloader.AssetLoader;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoadStats;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	import org.assetloader.signals.ProgressSignal;
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class AssetsLoaderLiteCommand extends ModuleCommand
	{
		[Inject]
		public var gameInfo:GameInfo
		public override function execute ( ):void
		{
			var lang:String
			var assetLoader:IAssetLoader = new AssetLoader()
			assetLoader.onConfigLoaded.add(onConfigLoaded_handler);
			assetLoader.addConfig(gameInfo.gameAssetsPath + "asset-config.xml")
		}
		protected function addListenersToLoader(loader : IAssetLoader) : void
        {
            loader.onChildOpen.add(onChildOpen_handler);
            loader.onChildError.add(onChildError_handler);
            loader.onChildComplete.add(onChildComplete_handler);
			loader.onComplete.add(onComplete_handler)
			loader.onProgress.add(onProgress_handler)
  
        }
 
        protected function removeListenersFromLoader(loader : IAssetLoader) : void
        {
            loader.onChildOpen.remove(onChildOpen_handler);
            loader.onChildError.remove(onChildError_handler);
			loader.onComplete.remove(onComplete_handler)
            loader.onChildComplete.remove(onChildComplete_handler);
			loader.onProgress.remove(onProgress_handler)
         
        }
		
		protected function onConfigLoaded_handler(signal : LoaderSignal) : void
        {
			
			 
			/*if (injector.hasMapping(GameInfo)) {
				var info:GameInfo = injector.getInstance(GameInfo);
				local = info.lang?info.lang:"en_US";
				local=local+"\\";
			}*/
			var local:String = gameInfo.gameAssetsPath + gameInfo.lang+ "/"
			var loader:IAssetLoader = signal.loader as IAssetLoader
            loader.onConfigLoaded.remove(onConfigLoaded_handler);
			addListenersToLoader(loader);
			
			for (var id:String in loader.ids ) {
				var ld:ILoader = loader.getLoader(loader.ids[id]);
				ld.setParam("BASE",local)
			}
			trace(loader.hasParam("base"))
            loader.start();
        }
 
        protected function onChildOpen_handler(signal : LoaderSignal, child : ILoader) : void
        {
           trace(signal)
        }
 
        protected function onChildError_handler(signal : ErrorSignal, child : ILoader) : void
        {
			this.dispatchToModules(new GameErrorEvent(this,signal.message))
        }
 
        protected function onChildComplete_handler(signal : LoaderSignal,child : ILoader) : void
        {
         //   trace("[" + signal.loader.id + "]\t[" + child.id + "]\t\tcomplete\tSpeed\t: " + Math.floor(child.stats.averageSpeed) + "\tkbps");
		 this.dispatchToModules(new AssetLoaderEvent(AssetLoaderEvent.ASSETS_CHILD_COMPLETED))
        }

        protected function onComplete_handler(signal : LoaderSignal, assets : Dictionary) : void
        {
            var loader : IAssetLoader = IAssetLoader(signal.loader);
            removeListenersFromLoader(loader);
            var stats : ILoadStats = loader.stats;
			 this.dispatchToModules(new AssetLoaderEvent(AssetLoaderEvent.ASSETS_LOADER_COMPLETED,assets))
        }
		protected function onProgress_handler(signal:ProgressSignal) : void
        {
            var loader : IAssetLoader = IAssetLoader(signal.loader);
            var stats : ILoadStats = loader.stats;
           // trace("\n[" + loader.id + "/"+signal.progressID+"]",loader.inProgress);
         //   trace("LOADING.....",Number(stats.bytesLoaded/1024).toFixed(2),"/",Number(stats.bytesTotal/1024).toFixed(2),stats.progress+"%",Math.floor(stats.averageSpeed) + " kbps");
			this.dispatchToModules(new AssetProgressEvent(signal.progressID,loader.stats))
		}

	}
	
}