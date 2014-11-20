package com.aspectgaming.event 
{
	import flash.events.Event;
	import org.assetloader.core.ILoadStats;
	
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class AssetProgressEvent  extends Event
	{
		public static const ASSET_PROGRESS:String = 'ASSET_PROGRESS';
		
		private var _stats:ILoadStats;
		private var _id:String
		public function AssetProgressEvent ( id:String, s:ILoadStats = null )
		{
			super(ASSET_PROGRESS);
			_stats = s;
			_id=id
		}
		
		public function get stats():*
		{
			return _stats;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public override function clone ( ):Event
		{
			return new AssetProgressEvent(type, stats);
		}
		
	}
	
}