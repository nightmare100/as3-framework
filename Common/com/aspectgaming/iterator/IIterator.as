package com.aspectgaming.iterator
{
	/**
	 * 迭代器 接口 
	 * @author mason.li
	 * 
	 */	
	public interface IIterator
	{
		function hasNext():Boolean;
		function getItem(key:*):*;
		function get current():*;
		function get currentIdx():uint;
		
		function moveNext():void;
		function moveTo(idx:uint):void;
		
		function addItem(vo:*):void;
		function removeCurrentItem():void;
		function removeItem(vo:*):void;
		function removeItemByAttribute(attr:String, key:*):Boolean;
		function getItemByAttribute(attr:String, key:*):*; 
		function isItemExistByAttr(attr:String, key:*):Boolean;
		function replaceItem(oldItem:*, newItem:*):void;
		function get itemList():Array;
		function get totalItemNum():uint;
		function set itemList(list:*):void
	}
}