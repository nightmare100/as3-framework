package com.aspectgaming.net
{
	import com.aspectgaming.core.IParse;
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.net.amf.parse.BaseServerParse;
	import com.aspectgaming.net.constant.ServerType;
	import com.aspectgaming.net.event.ServerErrorEvent;
	import com.aspectgaming.net.event.ServerEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleActor;
	
	/**
	 * 网络消息通信  => 装饰器MODE
	 * 先判断customDispatcher事件发送
	 * 抛出 Actor 事件发送 至模块 
	 * @author mason.li
	 * 
	 */	
	public class ServerManager extends ModuleActor implements IServer
	{
		protected var _service:IServer;
		protected var _customDispatcher:IEventDispatcher;
		protected var _serverType:String;
		
		protected var _parseMgr:IParse;
		
		public function ServerManager()
		{
			_customDispatcher = new EventDispatcher();
		}
		
		public function blockCommand(req:String):void
		{
			_service.blockCommand(req);
		}
		
		public function releaseCommand(req:String):void
		{
			_service.releaseCommand(req);
		}

		public function get serviceDispatch():IEventDispatcher
		{
			return _service as IEventDispatcher;
		}

		public function init(appurl:String, isEncode:Boolean, parse:IParse = null, logFunc:Function = null, type:String = "AMF"):void
		{
			_service = ServerFactory.createServer(type);
			_serverType = type;
			serviceDispatch.addEventListener(ServerEvent.ON_DATA, onData);
			serviceDispatch.addEventListener(ServerEvent.ON_ERROR, onError);
			
			if (type == ServerType.SOCKET)
			{
				serviceDispatch.addEventListener(ServerEvent.ON_CONNECT, onConnect);
				serviceDispatch.addEventListener(ServerEvent.ON_TIMEOUT, onConnectTimeout);
				serviceDispatch.addEventListener(ServerEvent.ON_CLOSE, onClose);
			}
			else
			{
				serviceDispatch.addEventListener(ServerEvent.ON_PROGRESS, onProgress);
			}
			_service.init(appurl, isEncode, parse, logFunc);
			_parseMgr = parse;
		}
		
		public function sendRequest(req:String, parm:Object=null):void
		{
			if (_service)
			{
				_service.sendRequest(req, parm);
			}
		}
		
		protected function onData(e:ServerEvent):void
		{
			var serverEvent:ServerEvent = new ServerEvent(e.req, e.data, e.req, e.parm);
			if (hasEventListener(e.req))
			{
				dispatchEvent(serverEvent);	
			}

			dispatchToModules(serverEvent.clone());
		}
		
		protected function onProgress(e:ServerEvent):void
		{
			var serverEvent:ServerEvent = new ServerEvent(e.type + e.req, e.data, e.req, e.parm);
			if (hasEventListener(e.type + e.req))
			{
				dispatchEvent(serverEvent);	
			}
		}
		
		protected function onError(e:ServerEvent):void
		{
			var type:String = _serverType == ServerType.AMF ? ServerErrorEvent.AMF_ERROR : ServerErrorEvent.SOCKET_ERROR;
			dispatchToModules(new ServerErrorEvent(type, e.req));
		}
		
		protected function onConnect(e:ServerEvent):void
		{
			if (hasEventListener(e.type))
			{
				dispatchEvent(new ServerEvent(ServerEvent.ON_CONNECT));	
			}
			dispatchToModules(new ServerEvent(ServerEvent.ON_CONNECT));
		}
		
		override protected function dispatchToModules(event:Event):Boolean
		{
			if(moduleEventDispatcher && moduleEventDispatcher.hasEventListener(event.type))
			{
				return moduleEventDispatcher.dispatchEvent(event);
			}
			return true;
		}
		
		
		
		/**
		 * 连接超时 
		 * @param e
		 * 
		 */		
		protected function onConnectTimeout(e:ServerEvent):void
		{
			//参数  1.目前是第几次重连  2.是否重连
			if (hasEventListener(e.type))
			{
				dispatchEvent(new ServerEvent(ServerEvent.ON_TIMEOUT, e.data, null, e.parm));	
			}
			dispatchToModules(new ServerEvent(ServerEvent.ON_TIMEOUT, e.data, null, e.parm));
		}
		
		protected function onClose(e:ServerEvent):void
		{
			//参数  1.目前是第几次重连 2.是否主动关闭  3. 是否重连
			if (hasEventListener(e.type))
			{
				dispatchEvent(new ServerEvent(ServerEvent.ON_CLOSE, e.data, e.req, e.parm));	
			}
			dispatchToModules(new ServerEvent(ServerEvent.ON_CLOSE, e.data, e.req, e.parm));
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_customDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _customDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _customDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_customDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _customDispatcher.willTrigger(type);
		}
		
		public function connect():void
		{
			_service.connect();
		}
		
		public function close():void
		{
			_service.close();
		}
		
		public function dispose():void
		{
			if (serviceDispatch!=null) {
				serviceDispatch.removeEventListener(ServerEvent.ON_DATA, onData);
				serviceDispatch.removeEventListener(ServerEvent.ON_ERROR, onError);
				serviceDispatch.removeEventListener(ServerEvent.ON_CONNECT, onConnect);
				serviceDispatch.removeEventListener(ServerEvent.ON_TIMEOUT, onConnectTimeout);
				serviceDispatch.removeEventListener(ServerEvent.ON_CLOSE, onClose);
				serviceDispatch.removeEventListener(ServerEvent.ON_PROGRESS, onProgress);
				_service.dispose();
				_service = null
			}
		
		}
		
		public function get parseMgr():BaseServerParse
		{
			// TODO Auto Generated method stub
			return _parseMgr as BaseServerParse;
		}
		
		
	}
}