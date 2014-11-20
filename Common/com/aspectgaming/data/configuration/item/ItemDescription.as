package com.aspectgaming.data.configuration.item
{
	import flash.utils.Dictionary;

	public class ItemDescription
	{
		private var _itemDic:Dictionary;
		private var _allInMax:Number;
		private var _bjAllIn:String;
		
		public function ItemDescription()
		{
			_itemDic = new Dictionary();
		}
		
		public function parse(xml:XML):void
		{
			for each (var equip:XML in  xml.equip)
			{
				_itemDic[uint(equip.@id)] = ItemDesc.parseItemDesc(equip);
			}
			_allInMax = Number(xml.allInMax.@number);
			_bjAllIn = String(xml.BJAllin.@desc);
		}
		public function get allInMax():Number
		{
			return _allInMax;
		}
		public function get bjAllIn():String
		{
			return _bjAllIn;
		}
		
		public function getItemDesc(itemID:int):ItemDesc
		{
			return _itemDic[itemID];
		}
		
			
	}
}