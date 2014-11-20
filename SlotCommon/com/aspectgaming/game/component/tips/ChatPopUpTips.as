package com.aspectgaming.game.component.tips
{
	import com.aspectgaming.game.constant.GameTickConstant;
	import com.aspectgaming.game.constant.asset.AssetRefDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.tooltip.constant.ToolTipDefined;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.PointUtil;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	
	/**
	 * 黑色文本提示冒泡框 
	 * @author mason.li
	 * 
	 */	
	public class ChatPopUpTips extends Sprite
	{
		private const AUTO_CLOSE_DELAY:uint = 3;
		private const WIDTH_FIX:uint = 20;
		private const HEIGHT_FIX:uint = 20;
		
		private var _viewCompoent:MovieClip;
		
		private var _txt:TextField;
		private var _corner:MovieClip;
		
		private static var _instance:ChatPopUpTips;
		private static function getInstance():ChatPopUpTips
		{
			if (!_instance)
			{
				_instance = new ChatPopUpTips();
			}
			
			return _instance;
		}
		
		public static function show(tar:InteractiveObject, txt:String):void
		{
			getInstance().text = txt;
			getInstance().show(tar);
		}
		
		public function ChatPopUpTips()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_viewCompoent = GameAssetLibrary.getMovieClip(AssetRefDefined.NORMAL_TIPS);
			addChild(_viewCompoent);
			
			_txt = _viewCompoent["txt"];
			_corner = _viewCompoent["boxArrow"];
		}
		
		private function set text(value:String):void
		{
			_txt.text = value;
		}
		
		public function show(target:InteractiveObject):void
		{
			var bonus:Rectangle = target.getBounds(target);
			var pt:Point = PointUtil.localToGoble(target);
			pt.x += bonus.x;
			pt.y += bonus.y;
			pt = pt.subtract(GameLayerManager.rootPoint);
			if (pt.x + target.width / 2 + this.width > GameLayerManager.GAME_WIDTH)
			{
				this.x = pt.x - this.width;
				_corner.gotoAndStop(1);
			}
			else
			{
				this.x = pt.x + target.width;
				_corner.gotoAndStop(2);
			}
			this.y = pt.y - this.height < 0 ? 0 : pt.y - this.height;
			
			GameLayerManager.uilayer.addChild(this);
			GameGlobalRef.gameManager.gameTick.addTimeout(onMoving, AUTO_CLOSE_DELAY, GameTickConstant.POP_UP_CLOSE_DELAY);
			GameLayerManager.root.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoving);
		}
		
		private function onMoving(e:MouseEvent = null):void
		{
			GameGlobalRef.gameManager.gameTick.removeTimeout(GameTickConstant.POP_UP_CLOSE_DELAY);
			GameLayerManager.root.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoving);
			DisplayUtil.removeFromParent(this);
		}
	}
}