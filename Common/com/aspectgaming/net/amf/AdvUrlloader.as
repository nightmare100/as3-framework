package com.aspectgaming.net.amf
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class AdvUrlloader extends URLLoader
	{
		private var _req:String;
		private var _parm:Object;
		
		public function AdvUrlloader(request:URLRequest=null)
		{
			super(request);
		}

		public function get parm():Object
		{
			return _parm;
		}

		public function set parm(value:Object):void
		{
			_parm = value;
		}

		public function get req():String
		{
			return _req;
		}

		public function set req(value:String):void
		{
			_req = value;
		}

	}
}