package com.aspectgaming.game.base.control
{
	import com.aspectgaming.game.base.control.init.CreateGameCommand;
	import com.aspectgaming.game.base.control.init.GameInitliazeCommand;
	import com.aspectgaming.game.base.control.init.RegisterGameCommand;
	import com.aspectgaming.game.constant.OverrideCommandlDefine;
	
	import flash.utils.Dictionary;
	
	/**
	 * 基本命令注册 
	 * @author mason.li
	 * 
	 */	
	public class OverrideCommandControl
	{
		private var _map:Dictionary;
		
		public function OverrideCommandControl()
		{
			_map = new Dictionary();
		}
		
		public function resisterCommand(key:String, cls:Class):void
		{
			_map[key] = cls;
		}
		
		public function getCommandByType(key:String):Class
		{
			if (_map[key])
			{
				return _map[key];
			}
			else
			{
				switch (key)
				{
					case OverrideCommandlDefine.GameInitCommand:
						return GameInitliazeCommand;
						break;
					case OverrideCommandlDefine.RegisterGameCommand:
						return RegisterGameCommand;
						break;
					case OverrideCommandlDefine.CreateGameCommand:
						return CreateGameCommand;
						break;
				}
			}
			
			return null;
		}
	}
}