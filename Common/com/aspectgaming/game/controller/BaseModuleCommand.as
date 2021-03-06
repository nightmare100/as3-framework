package com.aspectgaming.game.controller 
{
	import com.aspectgaming.core.ISimulator;
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
	
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class BaseModuleCommand extends ModuleCommand
	{
		protected function sendLog(obj:*):void {
			var simulator:ISimulator
			if (injector.hasMapping(ISimulator)) {
				simulator =  injector.getInstance(ISimulator);
				if (simulator != null) simulator.loggerAdd(getQualifiedClassName(this), obj);
			}
		}
	}
	
}