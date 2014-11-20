package com.aspectgaming.game
{
	import com.aspectgaming.core.CustomAssetLoader;
	import com.aspectgaming.core.ICustomLoader;
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.event.GlobalEvent;
	import com.aspectgaming.globalization.controller.AssetLoaderCommand;
	
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;
	
	/**
	 * 游戏Context基类 
	 * @author mason.li
	 * 
	 */	
	public class BaseGameContext extends ModuleContext
	{
		private var _gameInfo:GameInfo;
		public function BaseGameContext(gameInfo:GameInfo, contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, applicationDomain:ApplicationDomain=null)
		{
			_gameInfo = gameInfo;
			super(contextView, autoStartup, null, applicationDomain);
		}
		
		override public function startup ( ):void
		{
			_commandMap.mapEvent(GlobalEvent.LOAD_ASSETS, AssetLoaderCommand, GlobalEvent);
			
			injector.mapValue(GameInfo, _gameInfo);
			injector.mapSingletonOf(ICustomLoader, CustomAssetLoader);
			
			mediatorMap.createMediator(contextView);
			super.startup();
		}
	}
}