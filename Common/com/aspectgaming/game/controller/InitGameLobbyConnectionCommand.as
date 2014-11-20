package com.aspectgaming.game.controller 
{
	import com.aspectgaming.constant.global.LobbyGameConstant;
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.event.LobbyGameBridgeEvent;
	import com.aspectgaming.globalization.managers.ModuleManager;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * 初始化大厅消息 处理
	 * 该项为 初始化最后执行命令
	 * @author Evan.Chen
	 */
	public class InitGameLobbyConnectionCommand extends ModuleCommand
	{
		public override function execute():void
		{
			//大厅 => 游戏事件
			if (ModuleManager.gameModule)
			{
				ModuleManager.gameModule.addEventListener(LobbyGameBridgeEvent.ON_LOBBY_COMMAND, onLobbyCommand);
			}
			
			ModuleManager.dispatchToLobby(new LobbyGameBridgeEvent(LobbyGameBridgeEvent.GAME_LOADING_END));
		}
		
		protected function onLobbyCommand(e:LobbyGameBridgeEvent):void
		{
			switch(e._str) {
				//data数据格式   {tableHands:xxxx, level:xxxx, maxRouletteBet:xxx}
				case LobbyGameConstant.LEVEL_UP:
					dispatch(new GameEvent(GameEvent.GAME_LEVEL_UP, e.data));
					break;
				
				
				case LobbyGameConstant.WIN_POPUP:
					dispatch(new GameEvent(GameEvent.GAME_WIN_POPUP));
					break;
				
				
				case LobbyGameConstant.WIN_CLOSE:
					dispatch(new GameEvent(GameEvent.GAME_POPUP_END));
					break;
				
				
				//value 为 加载耗时
				case LobbyGameConstant.LOADING_GAME_COMPLETE:
					dispatch(new GameEvent(GameEvent.GAME_LOADINGBAR_TO_END, int(e._value)));
					break;
				
				
				//部分新游戏改用SoundManager 无需处理
				/*
				data {mute:true | false }
				游戏初始化完成时 会调用一次 此时返回 
				{ mute:true | false, level:xxx, tableHands:xxx, maxRouletteBet:xxx};
				*/
				case  LobbyGameConstant.LOBBY_MUTE:
					dispatch(new GameEvent(GameEvent.GAME_MUTE, e.data));
					break;
				
				//data数据格式   {balance:xxxx, charms:xxxx}
				case  LobbyGameConstant.UPDATE_BALANCE:
					dispatch(new GameEvent(GameEvent.GAME_UPDATE_BALANCE, e.data));
					break;
				
				
				//data = null
				case  LobbyGameConstant.CONTINUE_GAME:
					dispatch(new GameEvent(GameEvent.GAME_CONTINUE, e.data));
					break;
				
				//data {item:[{id:xx, num:xxx}]}  all in的话  数组对象里还会 增加 bet 和  line属性
				case LobbyGameConstant.USE_PROP_ITEM:
					dispatch(new GameEvent(GameEvent.PROP_USED, e.data));
					break;
			}
		}
		
	}
	
}