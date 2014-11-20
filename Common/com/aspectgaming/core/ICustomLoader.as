package com.aspectgaming.core
{
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	
	public interface ICustomLoader extends IAssetLoader
	{
		function get currentLoader():ILoader;
		function get currentLoaderID():String;
		function get errorLoader():ILoader;
	}
}