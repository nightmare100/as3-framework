package com.aspectgaming.ui
{
	import com.aspectgaming.globalization.managers.LayerManager;
	import com.aspectgaming.ui.event.RadioEvent;
	import com.aspectgaming.ui.event.SplitPageEvent;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.DomainUtil;
	import com.aspectgaming.utils.constant.AlignType;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 页面分页 
	 * 左右箭头 及下方的 点点 
	 * @author mason.li
	 * 
	 */	
	[Event(name="onPageChanged", type="com.aspectgaming.view.event.SplitPageEvent")]
	public class PageSplit extends SimpleSplitPage
	{
		private var _dotClass:String;
		private var _dotList:Vector.<RadioButton>;
		private var _dotGroup:RadioGroup;
		
		private var _groupContainter:Sprite;
		
		private var _soundBtnList:Vector.<SoundPlayDispatcher>;
		
		private var _dotMargin:Number;
		
		public function PageSplit(view:MovieClip, dotClass:String, dotMargin:Number = 25)
		{
			super(view);
			_dotClass = dotClass;
			_dotMargin = dotMargin;
		}
		
		/**
		 * 分页皮肤切换 
		 * @param view
		 * @param dotClass
		 * 
		 */		
		public function changeSkin(view:MovieClip, dotClass:String):void
		{
			if (dotClass == _dotClass)
			{
				return;
			}
			dispose();
			_viewComponent = view;
			_dotClass = dotClass;
			init();
		}
		
		override protected function init():void
		{
			_soundBtnList = new Vector.<SoundPlayDispatcher>();
			_btnLeft = _viewComponent["btn_left"];
			_btnRight = _viewComponent["btn_right"];
			_soundBtnList.push(new SoundPlayDispatcher(_btnLeft));
			_soundBtnList.push(new SoundPlayDispatcher(_btnRight));
			
			_groupContainter = new Sprite();
			_viewComponent["radioContainter"].addChild(_groupContainter);
			addEvent();
			checkButton();
		}
		
		override public function set currentPage(value:uint):void
		{
			super.currentPage = value;
			if (_dotGroup)
			{
				_dotGroup.enableAll();
				_dotGroup.selectedIndex = _currentPage;
				_dotGroup.disableButton(_currentPage);
			}
		}
		
		override public function set totalPage(value:uint):void
		{
			super.totalPage = value;
			madeDotList();
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			for each (var radioButton:RadioButton in _dotList)
			{
				radioButton.enabled = value;
			}
		}
		
		private function madeDotList():void
		{
			if (!_dotList)
			{
				_dotList = new Vector.<RadioButton>();
			}
			removeDot();	
			if (_totalPage > 1)
			{
				while (_dotList.length < _totalPage)
				{
					var btn:MovieClip = DomainUtil.getMovieClip(_dotClass);
					_dotList.push(new RadioButton(btn));
				}
				
				if (!_dotGroup)
				{
					_dotGroup = new RadioGroup(_dotList, 1);
					_dotGroup.addEventListener(RadioEvent.RADIO_GROUP_CHANGED, onSelectedChanged);
				}
				else
				{
					_dotGroup.changeButtonList(_dotList);
				}
				addDot();
				_dotGroup.selectedIndex = _currentPage;
				_dotGroup.disableButton(_currentPage);
			}
			checkButton();
		}
		
		override protected function onPageChangeClick(e:MouseEvent):void
		{
			super.onPageChangeClick(e);
			_dotGroup.enableAll();
			_dotGroup.selectedIndex = _currentPage;
			_dotGroup.disableButton(_currentPage);
		}
		
		private function removeDot():void
		{
			for each (var btn:RadioButton in _dotList)
			{
				DisplayUtil.removeFromParent(btn.viewComponent);
				btn.dispose();
			}
			_dotList.length = 0;
		}
		
		private function onSelectedChanged(e:RadioEvent):void
		{
			_previewPage = _currentPage;
			currentPage = e.index;
			dispatchEvent(new SplitPageEvent(SplitPageEvent.ON_PAGE_CHANGED));
		}
		
		private function addDot():void
		{
			for (var i:uint = 0 ; i < _dotList.length; i++)
			{
				_dotList[i].viewComponent.x = i * _dotMargin;
				_groupContainter.addChild(_dotList[i].viewComponent);
			}
			DisplayUtil.align(_groupContainter, AlignType.MIDDLE_CENTER, _viewComponent["radioContainter"].getRect(LayerManager.stage));
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
		}
		
		override protected function setButton(btn:SimpleButton, isEnabled:Boolean = false):void
		{
			if (btn)
			{
				btn.visible = isEnabled;
			}
		}
		
		public function show(par:DisplayObjectContainer, x:Number = 0, y:Number = 0):void
		{
			_viewComponent.x = x;
			_viewComponent.y = y;
			par.addChild(_viewComponent);
			
		}
		
		public function remove():void
		{
			DisplayUtil.removeFromParent(_viewComponent);
		}
		
		override public function dispose():void
		{
			remove();
			super.dispose();
			
			if (_dotList)
			{
				for each (var btn:RadioButton in _dotList)
				{
					DisplayUtil.removeFromParent(btn.viewComponent);
				}
				_dotList = null;
			}
			
			if (_dotGroup)
			{
				_dotGroup.dispose();
				_dotGroup = null;
			}
			
			for each (var soundBtn:SoundPlayDispatcher in _soundBtnList)
			{
				soundBtn.dispose();
			}
			_soundBtnList = null;
			
			DisplayUtil.removeFromParent(_groupContainter);
			_groupContainter = null;
		}
		
		
	}
}