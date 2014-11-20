package com.aspectgaming.ui
{
	import com.aspectgaming.ui.constant.SortType;
	import com.aspectgaming.ui.iface.IDataComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 排序组件 (使用组件接口 IDataComponent)的组合 
	 * @author mason.li
	 * 
	 */	
	public class SortableDispatcher implements IEventDispatcher
	{
		private var _dataComponent:IDataComponent;
		private var _defaultSortKey:String;
		private var _sortKeyList:Array;
		private var _buttonList:MovieClip;
		
		/**
		 * 当前排序字段 
		 */		
		private var _currentSortKey:String;
		
		private var _secKey:String;
		
		/**
		 * 当前排序类型 
		 */		
		private var _currentSortType:uint = 1;
		
		
		public function SortableDispatcher(component:IDataComponent, buttons:MovieClip)
		{
			_dataComponent = component;
			_buttonList = buttons;
		}

		/**
		 * 初始化 排序 
		 * @param keyList  关键字列表
		 * @param defaultKey 默认排序关键字
		 * @param secKey 第二排序关键字
		 * 
		 */		
		public function setSortInfo(keyList:Array, defaultKey:String, secKey:String):void
		{
			_defaultSortKey = defaultKey;
			_sortKeyList = keyList;
			_currentSortKey = defaultKey;
			_secKey = secKey;
			init();
		}
		
		private function init():void
		{
			if (_buttonList)
			{
				for (var i:uint = 0; i < _sortKeyList.length; i++)
				{
					initButton(_buttonList["sortBtn" + (i + 1)]);
				}
			}
		}
		
		private function initButton(mcBtn:MovieClip):void
		{
			if (mcBtn)
			{
				mcBtn.buttonMode = true;
				mcBtn.gotoAndStop(1);
				mcBtn.addEventListener(MouseEvent.CLICK, onSort);
			}
		}
		
		private function onSort(e:MouseEvent):void
		{
			var button:MovieClip = e.currentTarget as MovieClip;
			button.gotoAndStop(button.currentFrame == 1 ? 2 : 1);
			_currentSortKey = _sortKeyList[int(button.name.substring(button.name.length - 1)) - 1];
			_currentSortType = button.currentFrame;
			data = _dataComponent.data;
			
		}
		
		public function set data(value:Array):void
		{
			if (value)
			{
				_dataComponent.data = value.sort(onArrSort);
			}
		}
		
		private function onArrSort(o1:Object, o2:Object):int
		{
			if (o1[_currentSortKey] > o2[_currentSortKey])
			{
				return _currentSortType == SortType.ASC ? 1 : -1;
			}
			else if (o1[_currentSortKey] == o2[_currentSortKey])
			{
				if (o1[_secKey] > o2[_secKey])
				{
					return _currentSortType == SortType.ASC ? 1 : -1;
				}
				else if (o1[_secKey] == o2[_secKey])
				{
					return 0;
				}
				else
				{
					return _currentSortType == SortType.ASC ? -1 : 1;
				}
			}
			else
			{
				return _currentSortType == SortType.ASC ? -1 : 1;
			}
		}
		
		public function get data():Array
		{
			return _dataComponent.data as Array;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_dataComponent.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_dataComponent.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dataComponent.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dataComponent.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dataComponent.willTrigger(type);
		}
		
		public function dispose():void
		{
			_dataComponent.dispose();
			_dataComponent = null;
		}
	}
}