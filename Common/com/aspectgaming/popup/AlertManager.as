package com.aspectgaming.popup
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.popup.alert.*;
	import com.aspectgaming.popup.data.AlertInfo;
	import com.aspectgaming.popup.data.AlertInitInfo;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 公共 警告信息 管理
	 * @author mason.li
	 * 
	 */	
	public class AlertManager
	{
		private static var _popList:Vector.<AlertInfo> = new Vector.<AlertInfo>() ;
		private static var _popFlag:Boolean = true ;
		private static var _currAlert:IAlert;

		/**
		 * 暂停提示框弹出
		 * 
		 */		
		public static function blockPop():void
		{
			_popFlag = false;
		}

		/**
		 * 开始提示框弹出 
		 * 
		 */		
		public static function releasePop():void
		{
			_popFlag = true;
			nextShow();
		}
		
		private static function showPopUp(alertType:uint,
										 initData:AlertInitInfo = null, 
										 centralize:Boolean = true, 
										 isFocus:Boolean = true):void
		{
			var alertInfo:AlertInfo = new AlertInfo();
			alertInfo.alertType = alertType;
			alertInfo.initInfo = initData;
			alertInfo.centralize = centralize;
			alertInfo.isFocus = isFocus;
			
			_popList.push(alertInfo);
			if (_popFlag)
			{
				nextShow();
			}
		}
		
		public static function addPopUp(info:AlertInfo,alert:IAlert):void
		{
			if (info.centralize == true)
			{
				var posX:int = (LayerManager.stage.stageWidth - alert.width) / 2;
				var posY:int = (LayerManager.stage.stageHeight - alert.height) / 2;
				alert.x = posX;
				alert.y = posY;
			}
			
			LayerManager.noticeLayer.addChild(alert as DisplayObject);
		}
		
		public static function removePopUp(popUp:DisplayObject, isFocus:Boolean = true):void
		{
			DisplayUtil.removeFromParent(popUp as DisplayObject);
			if (isFocus == true)
			{
				
			}
		}
		
		/**
		 * 关闭所有PopUP 
		 * 
		 */		
		public static function closeAllPopUp():void
		{
			if(_currAlert != null)
			{
				_currAlert.removeEventListener(Event.CLOSE,onAlertClose);
				_currAlert.dispose() ;
				_currAlert = null ;
			}
		}
		
		private static function nextShow():void
		{
			if (_popList.length == 0)
			{
				return;
			}
			
			if (_currAlert == null)
			{
				var info:AlertInfo = _popList.shift() as AlertInfo;
				switch (info.alertType)
				{
					case AlertType.ALERT:
						_currAlert = new Alert();
						break;
					case AlertType.CONFIRM:
						_currAlert = new Confirm();
						break;
					case AlertType.AUTOCLOSE_ALERT:
						_currAlert = new AutoCloseAlert();
						break;			
					case AlertType.UNLOCK_CONFIRM:
						_currAlert = new UnLockConfirm();
						break;
					default:
						return;
				}
				_currAlert.addEventListener(Event.CLOSE,onAlertClose);
				_currAlert.show(info);
			}
			else
			{
				LayerManager.noticeLayer.addChild(Sprite(_currAlert));
			}
		}
		
		//======================User Interface=========================================
		
		/**
		 * 确认提示框 
		 * @param message
		 * @param closeHandler
		 * 
		 */		
		public static function showAlert(message:String, 
										 closeHandler:Function = null):void
		{
			showPopUp(AlertType.ALERT, new AlertInitInfo(message,closeHandler));
		}
		
		/**
		 * 自动关闭的确认提示框
		 * @param message
		 * @param delayTime
		 * @param closeHandler
		 * 
		 */		
		public static function showAutoCloseAlert(message:String,
												  delayTime:uint=3,
												  closeHandler:Function = null):void
		{
			showPopUp(AlertType.AUTOCLOSE_ALERT,new AlertInitInfo(message,closeHandler,null,null,delayTime));
		}
		
		/**
		 * 确认 取消 提示框  
		 * @param message
		 * @param confirmHandler
		 * @param cancelHandler
		 * 
		 */		
		public static function showConfirm(message:String, 
										   confirmHandler:Function = null, 
										   cancelHandler:Function = null):void
		{
			showPopUp(AlertType.CONFIRM,new AlertInitInfo(message,null,confirmHandler,cancelHandler));
		}
		
		public static function showUnLockConfirm(message:String, 
												 confirmHandler:Function = null, 
												 cancelHandler:Function = null):void
		{
			showPopUp(AlertType.UNLOCK_CONFIRM,new AlertInitInfo(message, cancelHandler ,confirmHandler));
		}
		
		//================================================================================
		
		/**
		 * 获取当前的提示框 
		 * @return 
		 * 
		 */		
		public static function get currAlert():IAlert
		{
			return _currAlert;
		}
		
		private static function onAlertClose(event:Event):void
		{
			_currAlert.removeEventListener(Event.CLOSE,onAlertClose);
			_currAlert = null;
			if (_popFlag)
			{
				nextShow();
			}
		}
	}
}

