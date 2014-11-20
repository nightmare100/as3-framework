package com.aspectgaming.game.control
{
	import com.aspectgaming.event.GameEvent;
	import com.aspectgaming.game.config.text.GameLanguageTextConfig;
	import com.aspectgaming.game.constant.ConfigTextDefined;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.manager.GameManager;
	import com.aspectgaming.game.manager.GameTipsManager;
	
	import org.robotlegs.mvcs.Command;
	
	public class BaseRestartCommand extends Command
	{
		[Inject]
		public var gameMgr:GameManager;
		
		override public function execute():void
		{
			GameTipsManager.killAllPopUp();
			gameMgr.reset();
			
			dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, GameLanguageTextConfig.getLangText(ConfigTextDefined.WELCOME)));
			dispatch(new SlotEvent(SlotEvent.GAME_CHECK_STATUE, null, "true"));
			
			dispatch(new GameEvent(GameEvent.GAME_CREATED_COMPLETE));
		}
	}
}