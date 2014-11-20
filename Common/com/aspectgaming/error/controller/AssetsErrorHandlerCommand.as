package com.aspectgaming.error.controller
{
	import com.aspectgaming.error.ServerErrorAgent;
	import com.aspectgaming.event.AssetLoaderEvent;
	import com.aspectgaming.ui.ReconnectBox;
	import com.aspectgaming.utils.LoggerUtil;
	
	import org.robotlegs.mvcs.Command;
	
	
	public class AssetsErrorHandlerCommand extends Command
	{
		[Inject]
		public var evt:AssetLoaderEvent;
		override public function execute():void
		{
			LoggerUtil.traceNormal(evt.errorType , evt.message);
			ServerErrorAgent.defaultError();
		}
		
	}
}