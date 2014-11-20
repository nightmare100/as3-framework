package com.aspectgaming.popup.data
{
	
	import flash.display.DisplayObject;

	public class AlertInfo
	{
		private var _alertType:uint = 0 ;
		private var _initInfo:AlertInitInfo ;
		private var _centralize:Boolean = true;
		private var _isFocus:Boolean = true ;

		public function get centralize():Boolean
		{
			return _centralize;
		}

		public function set centralize(value:Boolean):void
		{
			_centralize = value;
		}

		public function get isFocus():Boolean
		{
			return _isFocus;
		}

		public function set isFocus(value:Boolean):void
		{
			_isFocus = value;
		}

		public function get alertType():uint
		{
			return _alertType;
		}

		public function set alertType(value:uint):void
		{
			_alertType = value;
		}

		public function get initInfo():AlertInitInfo
		{
			return _initInfo;
		}

		public function set initInfo(value:AlertInitInfo):void
		{
			_initInfo = value;
		}


	}
}
