package com.aspectgaming.utils 
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.utils.constant.AlignType;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *显示对象的一些常规、频繁操作 
	 * @author Mason.Li
	 */
	public class DisplayUtil
	{
		private static var _grayFilter:ColorMatrixFilter = new ColorMatrixFilter(
			[0.3086, 0.6094, 0.0820, 0, 0,
				0.3086, 0.6094, 0.0820, 0, 0,
				0.3086, 0.6094, 0.0820, 0, 0,
				0,      0,      0,      1, 0]
		);
		
		public static function removeAllChildren(container:DisplayObjectContainer):void
		{
			if (container)
			{
				while(container.numChildren > 0)
				{
					container.removeChildAt(0);
				}
			}
		}
		
		public static function disableInterObjectWithDark(o:InteractiveObject):void
		{
			o.filters = [FiltersUtil.DARK_FILTER];
			o.mouseEnabled = false;
		}
		
		public static function disableButton(btn:InteractiveObject):void
		{
			btn.filters = [_grayFilter];
			btn.mouseEnabled = false;
		}
		
		public static function enableButton(btn:InteractiveObject):void
		{
			btn.filters = [];
			btn.mouseEnabled = true;
		}
		
		public static function disableSprite(sprite:Sprite, needGray:Boolean = true):void
		{
			if(sprite)
			{
				sprite.mouseChildren = false;
				sprite.mouseEnabled = false;
				if (needGray)
				{
					sprite.filters = [_grayFilter];
				}
			}
		}
		
		public static function enableSprite(sprite:Sprite):void
		{
			if(sprite)
			{
				sprite.mouseChildren = true;
				sprite.mouseEnabled = true;
				sprite.filters = [];
			}
		}
		
		/**
		 * 移除对象 
		 * @param displayObj
		 * 
		 */
		public static function removeFromParent(displayObj:DisplayObject):void
		{
			if(displayObj && displayObj.parent != null)
			{
				displayObj.parent.removeChild(displayObj);
			}
		}
		/**
		 * 置顶层 
		 * @param displayObj
		 * 
		 */		
		public static function bringToTop(displayObj:DisplayObject, offset:int = 0):void
		{
			if(displayObj && displayObj.parent != null)
			{
				displayObj.parent.setChildIndex(displayObj, displayObj.parent.numChildren - 1 + offset);
			}
		}
		
		public static function isViewShow(view:DisplayObject):Boolean
		{
			return view && view.parent != null;
		}
		
		/**
		 * 对齐
		 * @param target
		 * @param align
		 * @param bounds
		 * @param offset
		 *
		 */
		public static function align(target:DisplayObject,align:int = 4,bounds:Rectangle = null,offset:Point = null):void
		{
			if (align == AlignType.NO_ALIGN_TYPE)
			{
				return;
			}
			
			var rect:Rectangle;
			if(bounds == null)
			{
				if(target.stage)
				{
					rect = new Rectangle(0,0, target.stage.stageWidth, target.stage.stageHeight);
				}
				else
				{
					target.addEventListener(Event.ADDED_TO_STAGE,createFun(onAddStage,align,offset, bounds),false,0,true);
					return ;
				}
			}
			else
			{
				rect = bounds.clone();
			}
			align2(target,rect,align,offset);
		}
		private static function onAddStage(event:Event,align:int,offset:Point, bonuds:Rectangle = null):void
		{
			var target:DisplayObject = event.currentTarget as DisplayObject;
			target.removeEventListener(Event.ADDED_TO_STAGE,arguments.callee);
			align2(target,bonuds ? bonuds : new Rectangle(0,0,target.stage.stageWidth,target.stage.stageHeight),align,offset);
		}
		
		private static function align2(target:DisplayObject,bounds:Rectangle,align:int,offset:Point):void
		{
			if(offset)
			{
				bounds.offsetPoint(offset);
			}
			var targetRect:Rectangle = target.getRect(target);
			var _hd:Number = bounds.width - target.width;
			var _vd:Number = bounds.height - target.height;
			var pt:Point = new Point();
			switch(align)
			{
				case AlignType.TOP_LEFT:
					pt.x = bounds.x;
					pt.y = bounds.y;
					break;
				case AlignType.TOP_CENTER:
					pt.x = bounds.x + _hd / 2 - targetRect.x;
					pt.y = bounds.y;
					break;
				case AlignType.TOP_RIGHT:
					pt.x = bounds.x + _hd - targetRect.x;
					pt.y = bounds.y;
					break;
				case AlignType.MIDDLE_LEFT:
					pt.x = bounds.x;
					pt.y = bounds.y + _vd / 2 - targetRect.x;
					break;
				case AlignType.MIDDLE_CENTER:
					pt.x = bounds.x + _hd / 2 - targetRect.x;
					pt.y = bounds.y + _vd / 2 - targetRect.y;
					break;
				case AlignType.MIDDLE_RIGHT:
					pt.x = bounds.x + _hd - targetRect.x;
					pt.y = bounds.y + _vd / 2 - targetRect.y;
					break;
				case AlignType.BOTTOM_LEFT:
					pt.x = bounds.x;
					pt.y = bounds.y + _vd - targetRect.y;
					break;
				case AlignType.BOTTOM_CENTER:
					pt.x = bounds.x + _hd / 2 - targetRect.x;
					pt.y = bounds.y + _vd - targetRect.y;
					break;
				case AlignType.BOTTOM_RIGHT:
					pt.x = bounds.x + _hd - targetRect.x;
					pt.y = bounds.y + _vd - targetRect.y;
					break;
			}
			var lastPT:Point = PointUtil.globalToLocal(target, pt.x, pt.y);
			target.x = lastPT.x;
			target.y = lastPT.y;
		}
		
		private static function createFun(func:Function, ...args):Function
		{
			var f:Function = function():*
			{
				var func:Function = arguments.callee.func;
				var pat:Array = arguments.concat(args);
				return func.apply(null, pat);
			};
			f["func"] = func;
			return f;
		}
	}

}