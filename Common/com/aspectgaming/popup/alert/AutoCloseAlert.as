package com.aspectgaming.popup.alert
{
	
	import com.aspectgaming.popup.data.AlertInfo;
	
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class AutoCloseAlert extends Alert
	{
		private var _delayTime:uint ;
		private var _intervalId:uint ;

		public function AutoCloseAlert()
		{
			super();
		}

		override public function show(info:AlertInfo):void
		{
			_delayTime = info.initInfo.autoCloseDelayTime;
			_intervalId = setTimeout(autoCloseHandler, _delayTime * 1000);
			super.show(info);
		}

		override protected function onConfirmBtnClick(evt:MouseEvent):void
		{
			clearTimeout(_intervalId);
			super.onConfirmBtnClick(evt);
		}

		private function autoCloseHandler():void
		{
			onConfirmBtnClick(null);
		}
	}
}
