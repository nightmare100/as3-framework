package com.aspectgaming.tooltip.tipskin
{
	
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 基础提示UI 
	 * @author mason.li
	 * 
	 */	
	public class BaseTipSkin extends Sprite
	{
		protected var _tipSkin:MovieClip;
		protected var _tipTxt:TextField;
		protected var _back:MovieClip;

		protected var _data:*;
		
		/**
		 * 父类中继承此方法，对tipSkin等变量进行赋值。
		 * */
		public function BaseTipSkin()
		{
			initliaze();
		}
		
		protected function initliaze():void
		{
			
		}
		
		public function show(tip:String = null,obj:* = null):void
		{
			if (tip)
			{
				_tipTxt.htmlText = tip.replace(/\n/gi,"<br />");
			}
			
			setData(obj);
			
			if(_back)
			{
				_back.width = _tipTxt.x + _tipTxt.textWidth + 8;
				_back.height = _tipTxt.y + _tipTxt.textHeight + 14;
			}
			LayerManager.topLayer.addChild(this);
		}
		
		public function hide():void
		{
			if(this.parent != null)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function setSkin(mc:MovieClip):void
		{
			if (_tipSkin)
			{
				DisplayUtil.removeFromParent(_tipSkin);
			}
			
			_tipSkin = mc;
			addChild(_tipSkin);
		}
		
		public function setData(obj:*):void
		{
			
		}
		
	}
}