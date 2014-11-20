package com.aspectgaming.game
{
	import com.aspectgaming.constant.global.ResourceType;
	import com.aspectgaming.data.game.GameInfo;
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.game.iface.INewGame;
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.globalization.managers.VersionManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.DomainUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import org.robotlegs.utilities.modular.core.IModuleContext;
	
	/**
	 * 游戏模块基类 
	 * @author mason.li
	 * 
	 */	
	public class BaseGameModule extends Sprite implements INewGame
	{
		protected var _context:IModuleContext;
		
		public function BaseGameModule()
		{
			if (stage)
			{
				preInit();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, preInit);
			}
			super();
		}
		
		protected function preInit(e:Event = null):void
		{
//			GameLayerManager.setup(this);
//			ClientManager.isLocalDebug = false;
//			return;
			
			
			if (Capabilities.playerType == "StandAlone")	
			{
				ClientManager.isLocalDebug = true;
			}
			
			this.removeEventListener(Event.ADDED_TO_STAGE, preInit);
			if (ClientManager.isLocalDebug)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				ClientManager.isDebug = true;
				GameLayerManager.setup(this);
				if (Capabilities.playerType == "StandAlone")
				{
					LayerManager.setup(this); 
				}
				init(debugGameInfo, null); 
			}
			else
			{
				if (!LayerManager.stage)
				{
					LayerManager.stage = stage;
				}
				GameLayerManager.setup(this);
			}
		}
		
		public function get gameVersion():String
		{
			return "0";
		}
		
		public function get debugGameInfo():GameInfo
		{
			return null;
		}
		
		public function init(gameInfo:GameInfo, simulator:*):void
		{
			VersionManager.addContextMenu(gameVersion);
		}
		
		public function dispatch(e:Event):void
		{
			if (_context)
			{
				_context.eventDispatcher.dispatchEvent(e);
			}
		}
		
		/**
		 * 游戏重启 
		 * 
		 */		
		public function reset():void
		{
			dispatch(new GameEvent(GameEvent.GAME_INITIALIZE_COMPLETED, true));
		}
		
		public function dispose():void
		{
			VersionManager.removeMenu(gameVersion);
			_context.dispose();
			_context = null
			SoundManager.disposeByType(ResourceType.GAME);
		}
	}
}
