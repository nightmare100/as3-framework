package com.aspectgaming.core
{
	import org.assetloader.AssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;
	
	/**
	 * AssetLoader 修改 
	 * @author mason.li
	 * 
	 */	
	public class CustomAssetLoader extends AssetLoader implements ICustomLoader
	{
		private var _customLoader:ILoader;
		private var _errorLoader:ILoader;
		public function CustomAssetLoader(id:String="PrimaryGroup")
		{
			super(id);
		}
		
		public function get errorLoader():ILoader
		{
			return _errorLoader;
		}

		public function get currentLoader():ILoader
		{
			return _customLoader;
		}
		
		public function get currentLoaderID():String
		{
			if (_customLoader)
			{
				return _customLoader.id;
			}
			else
			{
				return null;	
			}
		}
		
		override protected function complete_handler(signal : LoaderSignal, data : * = null) : void
		{
			super.complete_handler(signal, data);
			_customLoader = null;
		}
		
		override protected function error_handler(signal:ErrorSignal):void
		{
			_errorLoader = signal.loader;
			super.error_handler(signal);
		}
		
		
		override public function startLoader(id : String) : void
		{
			var loader : ILoader = getLoader(id);
			if(loader)
			{
				loader.start();
				_customLoader = loader;
			}
			
			updateTotalBytes();
		}
		
	}
}