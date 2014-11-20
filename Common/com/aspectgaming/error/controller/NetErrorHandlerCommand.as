package com.aspectgaming.error.controller
{
	import com.aspectgaming.error.ServerErrorAgent;
	import com.aspectgaming.net.event.ServerErrorEvent;
	import com.aspectgaming.net.event.ServerEvent;
	import com.aspectgaming.utils.LoggerUtil;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	public class NetErrorHandlerCommand extends ModuleCommand//Command
	{
		[Inject]
		public var evt:ServerErrorEvent;
		
		override public function execute():void
		{
			//before
			
			dispatchToModules(new ServerErrorEvent(ServerErrorEvent.BEFORE_AMF_ERROR));
			
			LoggerUtil.traceNormal("[" , evt.type , evt.reqName, "]");
			ServerErrorAgent.defaultError();
		}
	}
}