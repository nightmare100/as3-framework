package com.aspectgaming.game.module.uicontrol.iface
{
	import com.aspectgaming.game.iface.IGameModule;
	import com.aspectgaming.game.event.SlotUIEvent;
	import com.aspectgaming.game.module.uicontrol.control.component.MeterWord;
	
	public interface ISlotControl extends IGameModule
	{
		/**
		 * 轮子滚完后 变更按钮状态 
		 * @param type
		 * 
		 */		
		function changeButtonStatue(type:String):void;
		function updateBetInfo(isNormal:Boolean = true):void;
		function enableControlBtn():void;
		function takeWinEnd():void;
		function updateBalanceInfo():void;
		function updateTotalWin():void;
		function updateBetData():void;
		function onAutoPlay(e:SlotUIEvent = null):void;
		function afterPlayClick():void;
		function set pause(value:Boolean):void;
		function set enable(value:Boolean):void;
		function get isAutoPlay():Boolean;
		function get winMeter():MeterWord;
	}
}