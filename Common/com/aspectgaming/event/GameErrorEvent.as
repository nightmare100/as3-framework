package com.aspectgaming.event 
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class GameErrorEvent  extends Event
	{
		public static const GAME_ERROR:String = 'GAME_ERROR';
		private static const ERROR:String="[ERROR]"
		
		private var _message:String;
		private var _ref:*;
		
		public function GameErrorEvent (ref:*,msg:String="")
		{
			super(GAME_ERROR);
			_message = msg;
			_ref = ref
		}
		

		
		public function get message():String 
		{
			
			return ERROR + " --> "+getQualifiedClassName(_ref) +"	Message:"+_message;
		}
		
		public override function clone ( ):Event
		{
			return new GameErrorEvent(_ref, _message);
		}
		
	}
	
}