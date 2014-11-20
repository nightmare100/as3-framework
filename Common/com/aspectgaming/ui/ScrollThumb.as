package com.aspectgaming.ui
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.DomainUtil;
	import com.aspectgaming.utils.constant.AlignType;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ScrollThumb extends Sprite
	{
		protected var _tumbBg:Sprite;
		protected var _tumbTag:Sprite;
		
		public function ScrollThumb(skin:MovieClip = null)
		{
			init(skin);
		}
		
		protected function init(mc:MovieClip):void
		{
			_tumbBg = mc ? mc["ScrollBar_Tumb"] : DomainUtil.getSprite("ScrollBar_Tumb");
			_tumbBg.x = _tumbBg.y = 0;
			
			_tumbTag = mc ? mc["Tumb_tag"] : DomainUtil.getSprite("Tumb_tag");
			if (_tumbTag)
			{
				_tumbTag.mouseEnabled = false;
				addChild(_tumbTag);
				_tumbTag.x = _tumbTag.y = 0;
				_tumbTag.x = _tumbBg.x + (_tumbBg.width - _tumbTag.width) / 2;
			}
			
			this.buttonMode = true;
			addChildAt(_tumbBg, 0);
		}
		
		override public function set height(value:Number):void
		{
			_tumbBg.height = value;
			if (_tumbTag)
			{
				_tumbTag.y = _tumbBg.y + (_tumbBg.height - _tumbTag.height) / 2;
			}
		}
		
		override public function set width(value:Number):void
		{
			_tumbBg.width = value;
			if (_tumbTag)
			{
				_tumbTag.x = _tumbBg.x + (_tumbBg.width - _tumbTag.width) / 2;
			}
		}
		
		
	}
}