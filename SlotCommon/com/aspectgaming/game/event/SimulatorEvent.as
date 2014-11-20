package com.aspectgaming.game.event
{
	import com.aspectgaming.event.base.BaseEvent;
	
	import flash.events.Event;

	public class SimulatorEvent extends BaseEvent
	{
		public static const SHOW_SIMULATOR:String		= "show_simulator";
		public static const SIMULATOREVENT:String		= "simulatorevent";
		public static const START:String						= "start";
		public static const SHOW_LOG:String					= "show_log";
		public static const SHOW_EMNULATION:String		= "show_emulation";
		public static const EMNULATION_PLAY:String		= "emulation_play";
		
		public static const INIT_EMNULATION:String		= "init_emulation";
		public static const REFRESH_EMULATION:String	= "refresh_emulation";
		public static const CALL_SIMULATOR:String		= "call_simulator";
		public static const LOG_ADD:String					= "log_add";
		
		public static const SEND_EMNU:String				="send_emnu";
		public static const REFRESH_EMNU:String			="refresh_emnu";
		
		public function SimulatorEvent(type:String, data:*=null, content:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, content, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new SimulatorEvent(type, data, content, bubbles, cancelable);
		}
	}
}