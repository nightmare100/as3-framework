package com.aspectgaming.net.amf
{
	import com.aspectgaming.core.IParse;
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.net.data.BlockInfoManager;
	import com.aspectgaming.net.data.MessageInfo;
	import com.aspectgaming.net.event.AMFEvent;
	import com.aspectgaming.net.event.ServerEvent;
	import com.aspectgaming.utils.LoggerUtil;
	import com.aspectgaming.utils.constant.LogType;
	import com.probertson.utils.GZIPBytesEncoder;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Dictionary;
	
	/**
	 * AMF消息发送器 
	 * @author mason.li
	 * 
	 */	
	public class AMFService extends EventDispatcher implements IServer
	{
		private var _parse:IParse;
		private var _amfConn:AMFConnection;
		private var _logger:Function;
		
		private var _blockList:Dictionary;
		
		public function AMFService()
		{
			_blockList = new Dictionary();
			_amfConn = new AMFConnection();
			_amfConn.addEventListener(AMFEvent.ON_DATA, onAmfData);
			_amfConn.addEventListener(AMFEvent.ON_PROGRESS, onProgress);
			_amfConn.addEventListener(AMFEvent.RESPONSE_ERROR, onError);
			_amfConn.addEventListener(AMFEvent.PARSE_ERROR, onParseError);
		}
		
		public function init(appurl:String, isEncode:Boolean, parse:IParse = null, logFunc:Function = null, type:String = "AMF"):void
		{
			setHost(appurl);
			logger = logFunc;
			_amfConn.isEncode = isEncode;
			
			_parse = parse;
		}
		
		
		public function set logger(value:Function):void
		{
			_logger = value;
		}
		
		public function sendRequest(req:String, parm:Object = null):void
		{
			if (_parse)
			{
				parm = _parse.parseRequestData(req, parm);
			}
			
			log(LogType.LOG_REQUEST_SEND, parm, req);
			_amfConn.sendRequest(req, parm);
		}
		
		public function blockCommand(req:String):void
		{
			_blockList[req] = true;
		}
		
		public function releaseCommand(req:String):void
		{
			delete _blockList[req];
			var list:Vector.<MessageInfo> = BlockInfoManager.releaseInfo(req);
			if (list)
			{
				for each (var info:MessageInfo in list)
				{
					log(LogType.LOG_REQUEST_BACK, info.response, info.req);
					
					if (_parse)
					{
						_parse.parseResponse(info.req, info.response, info.request);
					}
					dispatchEvent(new ServerEvent(ServerEvent.ON_DATA, info.response, info.req, info.request));
				}
			}
		}
		
		public function setHost(str:String):void
		{
			_amfConn.hostUrl = str;
		}
		
		private function onProgress(e:AMFEvent):void
		{
			dispatchEvent(new ServerEvent(ServerEvent.ON_PROGRESS, null, e.req, e.parm));
		}
		
		private function onAmfData(e:AMFEvent):void
		{
			if (_blockList[e.req])
			{
				BlockInfoManager.addBlockInfo(e.req, new MessageInfo(e.req, e.data, e.parm));
				return;
			}
			
			log(LogType.LOG_REQUEST_BACK, e.data, e.req);
			
			if (_parse)
			{
				_parse.parseResponse(e.req, e.data, e.parm);
			}
			dispatchEvent(new ServerEvent(ServerEvent.ON_DATA, e.data, e.req, e.parm))
		}
		
		private function onError(e:AMFEvent):void
		{
			log(LogType.LOG_REQUEST_ERROR, null, e.req);
			processError(e);
		}
		
		private function log(type:String, o:*, head:String = ""):void
		{
			if (_logger != null)
			{
				_logger(o, LogType.LOG_AMF + " " + type, head);
			}
		}
		
		private function onParseError(e:AMFEvent):void
		{
			log(LogType.LOG_REQUEST_PARSE_ERROR, null, e.req);
			processError(e);
		}
		
		private function processError(e:AMFEvent):void
		{
			dispatchEvent(new ServerEvent(ServerEvent.ON_ERROR, e.data, e.req, e.parm));
		}
		
		public function connect():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function dispose():void
		{
			_amfConn.removeEventListener(AMFEvent.ON_DATA, onAmfData);
			_amfConn.removeEventListener(AMFEvent.RESPONSE_ERROR, onError);
			_amfConn.removeEventListener(AMFEvent.PARSE_ERROR, onParseError);
			_amfConn.removeEventListener(AMFEvent.ON_PROGRESS, onProgress);
			_amfConn = null;
			_blockList = null;
			_parse = null;
		}
		
		public function close():void
		{
			
		}
		
		
		
	}
}