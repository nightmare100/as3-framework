package com.aspectgaming.popup.alert
{
	import com.aspectgaming.utils.DomainUtil;
	
	import flash.events.MouseEvent;

	public class UnLockConfirm extends Confirm
	{
		public function UnLockConfirm()
		{
			super();
		}
		
		override public function init():void
		{
			_ui = DomainUtil.getMovieClip("UI_ConfirmUnlock");
			_confirmBtn = _ui["btnUnlock"];
			_confirmBtn.addEventListener(MouseEvent.CLICK, onConfirmBtnClick);
			
			_cancelBtn = _ui["closeBtn"];
			_cancelBtn.addEventListener(MouseEvent.CLICK, onCancelBtnClick);
			
			_contentTxt = _ui["contentTxt"];
			addChild(_ui);
		}
		
		
	}
}