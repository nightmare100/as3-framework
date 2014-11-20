package com.aspectgaming.game.control
{
	import com.aspectgaming.game.constant.GameModuleDefined;
	import com.aspectgaming.game.constant.GameStatue;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.game.manager.GameManager;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * 自动游戏模式切换 
	 * @author mason.li
	 * 
	 */	
	public class AutoPlayModeChangeCommand extends ModuleCommand
	{
		[Inject]
		public var slotEvt:SlotEvent;
		
		[Inject]
		public var gameMgr:GameManager;
		
		public function AutoPlayModeChangeCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			gameMgr.isAutoPlay = Boolean(slotEvt.data);
			
			//发送给模块
			if (slotEvt.content == GameStatue.GAMEIDLE && !gameMgr.isAutoPlay)
			{
				//autoPlay停止
				dispatchToModules(slotEvt.clone());
			}
		}
		
		
	}
}