package com.aspectgaming.popup.data
{

	public class AlertInitInfo
	{
		public var message:String;
		public var closeHandler:Function;
		public var confirmHandler:Function;
		public var cancelHandler:Function;
		public var autoCloseDelayTime:uint;

		public function AlertInitInfo(message:String, closeHandler:Function = null, confirmHandler:Function = null, cancelHandler:Function = null, autoCloseDelayTime:uint = 0)
		{
			this.message = message;
			this.closeHandler = closeHandler;
			this.confirmHandler = confirmHandler;
			this.cancelHandler = cancelHandler;
			this.autoCloseDelayTime = autoCloseDelayTime;
		}
	}
}
