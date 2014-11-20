package com.aspectgaming.game.base
{
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.event.AssetLoaderEvent;
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.game.BaseGameContext;
	import com.aspectgaming.game.base.control.StartUpCompleteCommand;
	import com.aspectgaming.game.base.control.error.ErrorHandlerCommand;
	import com.aspectgaming.game.data.FreeGameModel;
	import com.aspectgaming.game.data.GameData;
	import com.aspectgaming.game.data.gamble.GambleInfo;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.net.ServerManager;
	import com.aspectgaming.net.event.ServerErrorEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.base.ContextEvent;
	
	public class SlotGameContext extends BaseGameContext
	{
		public function SlotGameContext(gameInfo:GameInfo, contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, applicationDomain:ApplicationDomain=null)
		{
			super(gameInfo, contextView, autoStartup, applicationDomain);
		}
		
		/**
		 * 继承后需要注入 
		 * 1.IServer		服务器收发器  
		 * 2.IParse			服务端收发解析器
		 * 3.IErrorParse    错误解析器
		 */		
		override public function startup():void
		{
			//全局错误事件
			moduleCommandMap.mapEvent(ServerErrorEvent.AMF_ERROR, ErrorHandlerCommand, Event);
			moduleCommandMap.mapEvent(AssetLoaderEvent.ASSETS_LOADER_ERROR, ErrorHandlerCommand, Event);
			
			
			_commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartUpCompleteCommand, ContextEvent, true);
			
			_injector.mapSingleton(GameData);
			_injector.mapSingleton(GameManager);
			_injector.mapSingleton(GambleInfo);
			_injector.mapSingleton(FreeGameModel);
			
			super.startup();
		}
		
		
	}
}