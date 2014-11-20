package com.aspectgaming.tooltip
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.tooltip.tipskin.BaseTipSkin;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 基础提示代理 
	 * @author mason.li
	 * 
	 */	
	internal class BaseTooltip
	{
		protected static const VERTICAL_GAP:int = 0;
		protected static const LEFT_OFFSET:int = 10;
				
		private var _map:Dictionary;
		
		/**
		 * 固定显示列表 
		 */		
		private var _fixedShowList:Dictionary;
		/**
		 * 固定提示 
		 */		
		private var _fixMap:Dictionary;
		
		protected var _currentTipSkin:BaseTipSkin;
		
		public function BaseTooltip()
		{
			_map = new Dictionary();
			_fixMap = new Dictionary();
			_fixedShowList = new Dictionary();
		}
		
		public function addFixTip(target:InteractiveObject, tip:String, tipSkin:BaseTipSkin, obj:* = null, offset:Point = null):void
		{
			if (target == null)
			{
				return;
			}
			
			if(_fixMap[target])
			{
				chanegTip(target, tip, obj, false, offset, _fixMap);
				return;
			}
			var tipStuct:TipStuct = new TipStuct();
			tipStuct.tip = tip;
			tipStuct.tipSkin = tipSkin;
			tipStuct.tipObj = obj;
			tipStuct.offset = offset;
			_fixMap[target] = tipStuct;
			showFixTip(target);
		}
		
		/**
		 * 添加一个浮动提示 
		 * @param target
		 * @param tip
		 * @param tipSkin
		 * @param obj
		 * @param useMouseScroll
		 * @param offset
		 * 
		 */		
		public function add(target:InteractiveObject, tip:String, tipSkin:BaseTipSkin, obj:* = null, useMouseScroll:Boolean = false, offset:Point = null):void
		{
			if (target == null)
			{
				return;
			}
			
			if(_map[target])
			{
				chanegTip(target, tip, obj, useMouseScroll, offset, _map);
				return;
			}
			target.addEventListener(MouseEvent.ROLL_OVER, onTargetOver);
			target.addEventListener(MouseEvent.ROLL_OUT, onTargetOut);
			var tipStuct:TipStuct = new TipStuct();
			tipStuct.tip = tip;
			tipStuct.tipSkin = tipSkin;
			tipStuct.tipObj = obj;
			tipStuct.useMosueScroll = useMouseScroll;
			tipStuct.offset = offset;
			_map[target] = tipStuct;
		}
		
		public function hasToolTip(target:InteractiveObject, isFixTip:Boolean = false):Boolean
		{
			var dic:Dictionary;
			dic = isFixTip?_fixMap:_map;
			if (dic[target])
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function remove(target:InteractiveObject):void
		{
			var tipStuct:TipStuct;
			if(_map[target])
			{
				target.removeEventListener(MouseEvent.ROLL_OVER, onTargetOver);
				target.removeEventListener(MouseEvent.ROLL_OUT, onTargetOut);
				tipStuct = _map[target] as TipStuct;
				tipStuct.tipSkin.hide();
				_map[target] = null;
				delete _map[target];
			}
			
			if(_fixMap[target])
			{
				tipStuct = _fixMap[target] as TipStuct;
				tipStuct.tipSkin.hide();
				_fixMap[target] = null;
				delete _fixMap[target];
			}
		}
		public function removefixMap(target:InteractiveObject):void
		{
			var tipStuct:TipStuct;
			if(_fixMap[target])
			{
				tipStuct = _fixMap[target] as TipStuct;
				tipStuct.tipSkin.hide();
				_fixMap[target] = null;
				delete _fixMap[target];
			}
		}
		
		public function chanegTip(target:InteractiveObject, tip:String, obj:*, useMouseScroll:Boolean, offset:Point, dic:Dictionary):void
		{
			if(dic[target])
			{
				var tipStruct:TipStuct = dic[target];
				tipStruct.tip = tip;
				tipStruct.tipObj = obj;
				tipStruct.useMosueScroll = useMouseScroll;
				tipStruct.offset = offset;
			}
		}
		
		public function showFixTip(target:InteractiveObject):void
		{
			if (_map[target] && TipStuct(_map[target]).tipSkin == _currentTipSkin)
			{
				_currentTipSkin.hide();
				_currentTipSkin = null;
			}
			
			var struct:TipStuct = _fixMap[target];
			
			struct.tipSkin.show(struct.tip,struct.tipObj);
			_currentTipSkin = struct.tipSkin;
			
			_fixedShowList[struct.tipSkin] = true;
			LayerManager.stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseUp);
			if (target is DisplayObjectContainer && DisplayObjectContainer(target).getChildByName(TooltipManager.FIX_LAYER_NAME))
			{
				target = DisplayObjectContainer(target).getChildByName(TooltipManager.FIX_LAYER_NAME) as InteractiveObject;
			}
			
			alignToolTip(target, struct.offset);
		}
		
		private function onTargetOver(evt:MouseEvent):void
		{
			var currentTarget:InteractiveObject = evt.currentTarget as InteractiveObject;
			var tipStuct:TipStuct = _map[currentTarget] as TipStuct;
			
			if(tipStuct)
			{
				if (_fixMap[currentTarget])
				{
					TipStuct(_fixMap[currentTarget]).tipSkin.hide();
				}
				
				tipStuct.tipSkin.show(tipStuct.tip,tipStuct.tipObj);
				_currentTipSkin = tipStuct.tipSkin;
				
				if (tipStuct.useMosueScroll)
				{
					deployTooltip(evt.stageX, evt.stageY - VERTICAL_GAP, tipStuct.offset);
					LayerManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onTooltipMove);
				}
				else
				{
					alignToolTip(currentTarget, tipStuct.offset, tipStuct.tipObj && tipStuct.tipObj.useFix, tipStuct.tipSkin);
				}
			}
		}
		
		private function alignToolTip(target:InteractiveObject, offset:Point, isFixed:Boolean = false, tipSkin:InteractiveObject = null):void
		{
			var point:Point = target.localToGlobal(LayerManager.ZERO_POINT);
			var bounds:Rectangle = target.getBounds(target);
			point.x += bounds.x;
			point.y += bounds.y;
			
			var tempX:Number = (point.x + target.width / 2) - _currentTipSkin.width / 2;
			var tempY:Number = point.y + target.height; 
			
			if (offset)
			{
				tempX += offset.x;
				tempY += offset.y;
			}
			
			tempX = (tempX + _currentTipSkin.width) > LayerManager.stageWidth ? (LayerManager.stageWidth - _currentTipSkin.width) : tempX;
			tempY = (tempY + _currentTipSkin.height) > LayerManager.stageHeight ? (LayerManager.stageHeight - _currentTipSkin.height) : tempY;
			
			if (isFixed)
			{
				tempY = point.y - tipSkin.height;
			}
			
			_currentTipSkin.x = Math.max(0, tempX);
			_currentTipSkin.y = Math.max(0, tempY);
		}
		
		private function onTargetOut(evt:MouseEvent):void
		{
			var tipStuct:TipStuct = _map[evt.currentTarget as InteractiveObject] as TipStuct;
			tipStuct.tipSkin.hide();
			LayerManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTooltipMove);
		}
		
		private function onStageMouseUp(e:MouseEvent):void
		{
			var hideLen:uint;
			var totalLen:uint;
			for (var key:* in _fixedShowList)
			{
				var skin:BaseTipSkin = key as BaseTipSkin;
				if (!skin.hitTestPoint(e.stageX, e.stageY))
				{
					skin.hide();
					hideLen++;
					_fixedShowList[key] = null;
					delete _fixedShowList[key];
				}
				totalLen++;
			}
			if (hideLen == totalLen)
			{
				LayerManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseUp);
			}
		}
		
		private function onTooltipMove(evt:MouseEvent):void
		{
			deployTooltip(evt.stageX, evt.stageY - VERTICAL_GAP);
		}
		
		protected function deployTooltip(x:int, y:int, offset:Point = null):void
		{
			var tempX:int = x;
			var tempY:int = y;
			
			if (offset)
			{
				tempX += offset.x;
				tempY += offset.y;
			}
			
			if((tempX - LEFT_OFFSET) < 0)
			{
				tempX = LEFT_OFFSET + 2;
			}

			if((tempX + _currentTipSkin.width - LEFT_OFFSET) > LayerManager.root.width)
			{
				tempX = x - _currentTipSkin.width - LEFT_OFFSET;
			}
			
			if((tempY + _currentTipSkin.height + 25) > LayerManager.root.height)
			{
				tempY = y -_currentTipSkin.height - 25;
			}
			_currentTipSkin.x = tempX;
			_currentTipSkin.y = tempY;
		}
	}
}
import com.aspectgaming.tooltip.tipskin.BaseTipSkin;

import flash.geom.Point;

class TipStuct
{
	public var tip:String;
	public var tipObj:*;
	public var tipSkin:BaseTipSkin;
	public var useMosueScroll:Boolean;
	public var offset:Point;
}