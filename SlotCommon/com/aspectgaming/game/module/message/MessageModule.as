package com.aspectgaming.game.module.message
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.config.text.MessageBarInfo;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.component.BaseControlModule;
	import com.aspectgaming.ui.richtext.AutoResizeRichText;
	import com.aspectgaming.ui.richtext.RichText;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFieldType;
	
	/**
	 * 消息模块  
	 * @author mason.li
	 * 
	 */	
	public class MessageModule extends BaseControlModule
	{
		private var _richText:AutoResizeRichText;
		public function MessageModule()
		{
			super(null);
		}
		
		override protected function init():void
		{
			var msgInfo:MessageBarInfo = GameSetting.messageBarInfo;
			_richText = new AutoResizeRichText(msgInfo.width, msgInfo.height, GameAssetLibrary.bitmapFont, TextFieldType.DYNAMIC, 15, true, msgInfo.color, msgInfo.align);
			addChild(_richText);
			super.init();
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}

		public function changeText(txt:String):void
		{
			_richText.text = txt;			
		}
		
		override public function dispose():void
		{
			super.dispose();
			_richText.dispose();
			DisplayUtil.removeFromParent(_richText);
			_richText = null;
		}
		
		
		
	}
}