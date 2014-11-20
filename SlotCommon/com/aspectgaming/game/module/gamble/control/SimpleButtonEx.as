package com.aspectgaming.game.module.gamble.control
{
	import flash.display.ColorCorrection;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class SimpleButtonEx extends SimpleButton 
	{
		//private var _name:String;
		
		private var _upState:DisplayObject;
		private var _overState:DisplayObject;
		private var _disState:DisplayObject;
		
		private var _enabled:Boolean;
		private var _btn:SimpleButton;
		
		private var _info:String;
		
		
		public function SimpleButtonEx(btn:SimpleButton, info:String="") 
		{
			_info = info;
			_btn = btn;
			
			_upState = btn.upState;
			_overState = btn.overState;
			// -1
			//if (_btn.hitTestState != null) _disState = _btn.hitTestState;
			//else _btn.hitTestState = _upState;
			// 不会为null,,只会dob.w/h = 0
			
			// -2
			if (_btn.hitTestState.width > 0) _disState = _btn.hitTestState;
			else _btn.hitTestState = _btn.upState;
		}
		
		public function resetState():void
		{
			if (_disState != null && _upState != null) 
			{
				_btn.upState = _upState;
				_btn.overState = _overState;
			}
		}
		
		
		
		
		public function get enabledEx():Boolean	{ 	return _enabled;	}
		public function set enabledEx(tv:Boolean) :void
		{
			//if (btn.hitTestStat != null) {
			_enabled = tv;
			if (_enabled) {
				_btn.enabled = true;
				if (_disState != null) {
					_btn.overState = _overState;
					_btn.upState = _upState;
					_btn.filters = null;
				}
			}else {
				_btn.enabled = false;
				if (_disState != null) {
					_btn.overState = _upState;
					//_btn.overState = _btn.downState;
					//_btn.upState = _btn.downState;
					_btn.filters = [new ColorMatrixFilter([0.65, 0, 0, 0, 0,
														0, 0.65, 0, 0, 0,
														0, 0, 0.65, 0, 0,
														0,0,0,1,0])];
				}
			}
			//this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			//_btn.visible = false;
			//_btn.visible = true;
		}
		
		public function get info():String 	{	return _info;	}
		
	}
}