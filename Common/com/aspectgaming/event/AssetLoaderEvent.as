package com.aspectgaming.event 
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.assetloader.core.ILoadStats;
	
	import org.assetloader.signals.LoaderSignal;
	
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class AssetLoaderEvent  extends Event
	{
		
		public static const ASSETS_LOADER_COMPLETED:String = 'ASSETS_LOADER_COMPLETED';
		public static const ASSETS_STOP:String = 'ASSETS_STOP';
		public static const ASSETS_CHILD_COMPLETED:String = 'ASSETS_CHILD_COMPLETED';
		public static const ASSETS_CHILD_OPEN:String = 'ASSETS_CHILD_OPEN';
		public static const ASSETS_LOADER_ERROR:String = 'ASSETS_ERROR';
		
		private var _assets:Dictionary;
		private var _errortype:String;
		private var _message:String;
		private var _stats:ILoadStats
		public function AssetLoaderEvent ( type:String, assets:Dictionary = null,message:String="",stats:ILoadStats=null )
		{
			super(type);
			_assets = assets;
		}
		public function getClass(objName:String,name:String):Class
		{
			if (_assets!=null) {
				var ref:Class = _assets[objName].loaderInfo.applicationDomain.getDefinition(name) as Class;
				return ref;
			}
			return null
			
		}
		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message = value;
		}

		public function get errorType():String
		{
			return _errortype;
		}

		public function set errorType(value:String):void
		{
			_errortype = value;
		}

		public function get assets():Dictionary
		{
			return _assets;
		}
		
		public function get stats():ILoadStats 
		{
			return _stats;
		}
		
		public override function clone ( ):Event
		{
			return new AssetLoaderEvent(type, assets, message, stats);
		}
		
	}
	
}