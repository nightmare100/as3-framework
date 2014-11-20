package com.aspectgaming.event 
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class SimulatorEvent  extends Event
	{
		
		public static const SIMULATOR_INITIALIZE:String = 'SIMULATOR_INITIALIZE';
		public static const SIMULATOR_SEND_REQ:String = 'SIMULATOR_SEND_REQ';
		
		public var data:*
		public var value:String
		
		
		public override function clone ( ):Event
		{
			return new SimulatorEvent(type, value, value);
		}
		public function SimulatorEvent(type:String, data:* = null,value:String = null)
		{
			super(type);
			this.data = data;
			this.value = value;
		}
	}
	
}