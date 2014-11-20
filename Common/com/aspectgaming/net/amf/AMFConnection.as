package com.aspectgaming.net.amf
{
	import com.aspectgaming.net.event.AMFEvent;
	import com.probertson.utils.GZIPBytesEncoder;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * Msg Prototype 
	 * @author mason.li
	 * 
	 */	
	internal class AMFConnection extends EventDispatcher
	{
		private static var _gzipEncoder:GZIPBytesEncoder;
		
		public function set isEncode(value:Boolean):void
		{
			_isEncode = value;
		}

		public static function get gzipEncoder():GZIPBytesEncoder
		{
			if (!_gzipEncoder)
			{
				_gzipEncoder = new GZIPBytesEncoder();
			}
			return _gzipEncoder;
		}
		
		private var _hostUrl:String;
		private var _isEncode:Boolean;
		
		public function AMFConnection(host:String = "")
		{
			hostUrl = host;
		}

		public function set hostUrl(value:String):void
		{
			_hostUrl = value;
		}
		
		public function sendRequest(req:String, parm:Object = null):void
		{
			var uloader:AdvUrlloader = new AdvUrlloader();
			uloader.dataFormat = URLLoaderDataFormat.BINARY;
			
			var request:URLRequest = RequestFactory.createRequest(_hostUrl, parm, req);

			uloader.addEventListener(Event.COMPLETE, onResponse);
			uloader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			uloader.addEventListener(IOErrorEvent.IO_ERROR, onResponseError);
			uloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			uloader.req = req;
			uloader.parm = parm;
			uloader.load(request);
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			var uloader:AdvUrlloader = e.currentTarget as AdvUrlloader;
			
			dispatchEvent(new AMFEvent(AMFEvent.ON_PROGRESS, null, uloader.req, {progress:int(e.bytesLoaded / e.bytesTotal * 100), loaded:e.bytesLoaded, total:e.bytesTotal}));
		}
		
		private function onResponse(e:Event):void
		{
			var uloader:AdvUrlloader = e.currentTarget as AdvUrlloader;
			uloader.removeEventListener(Event.COMPLETE, onResponse);
			uloader.removeEventListener(IOErrorEvent.IO_ERROR, onResponseError);
			uloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			uloader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			
			var byteData:ByteArray = uloader.data;
			try
			{
				if (_isEncode)
				{
					byteData = gzipEncoder.uncompressToByteArray(byteData);
				}
				
				var backObject:* = byteData.readObject();
			}
			catch (err:Error)
			{
				dispatchEvent(new AMFEvent(AMFEvent.PARSE_ERROR, null, uloader.req, uloader.parm));
				return;
			}
			
			dispatchEvent(new AMFEvent(AMFEvent.ON_DATA, backObject, uloader.req, uloader.parm));
		}
		
		private function onResponseError(e:IOErrorEvent):void
		{
			var uloader:AdvUrlloader = e.currentTarget as AdvUrlloader;
			uloader.removeEventListener(Event.COMPLETE, onResponse);
			uloader.removeEventListener(IOErrorEvent.IO_ERROR, onResponseError);
			uloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			dispatchEvent(new AMFEvent(AMFEvent.RESPONSE_ERROR, null, uloader.req, uloader.parm));
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			var uloader:AdvUrlloader = e.currentTarget as AdvUrlloader;
			uloader.removeEventListener(Event.COMPLETE, onResponse);
			uloader.removeEventListener(IOErrorEvent.IO_ERROR, onResponseError);
			uloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			dispatchEvent(new AMFEvent(AMFEvent.RESPONSE_ERROR, null, uloader.req, uloader.parm));
		}
	}
}