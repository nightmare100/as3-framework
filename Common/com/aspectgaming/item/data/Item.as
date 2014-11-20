package com.aspectgaming.item.data
{
	import com.aspectgaming.data.configuration.Configuration;
	import com.aspectgaming.data.configuration.item.ItemDesc;
	import com.aspectgaming.utils.URLUtil;
	
	/**
	 * Item基类 
	 * @author mason.li
	 * 
	 */	
	public class Item
	{
		public var itemID:int;
		public var itemName:String;
		public var itemDesc:String;
		
		private var _itemNum:Number;
		
		/**
		 * 物品类型 
		 */		
		public var itemType:int;
		
		public var itemPrice:Number;
		
		public var itemDefaultDesc:String;
		
		private var _desc:ItemDesc;
		
		public var parmNumber1:Number;
		public var parmNumber2:Number;
		
		public var parmStr1:String;
		public var parmStr2:String;
		
		public function Item(id:int)
		{
			itemID = id;
			_desc = Configuration.itemDescription.getItemDesc(id);
			if (_desc)
			{
				itemName = _desc.name;
				itemDesc = _desc.desc;
				itemPrice = _desc.price;
				itemDefaultDesc = _desc.defaultDesc;
			}
		}
		
		public function canGameUse(gameID:int):Boolean
		{
			return _desc.canGameUse(gameID);
		}
		
		
		public function get defaultNum():Number
		{
			return _desc.defaultBuy;
		}
		
		public function getItemConsume(gameID:int):Number
		{
			if (_desc)
			{
				return _desc.getGameConsume(gameID)
			}
			else
			{
				return -1;
			}
		}
		
		public function getItemConsumeIncCurrent(gameID:int):Number
		{
			return (getItemConsume(gameID) - itemNum) * itemPrice;
		}
		
		public function getIconUrl(size:String):String
		{
			var picName:String = "item" + itemID + "_" + size;
			return URLUtil.getLobbyImage("equip/" + picName + ".png");
		}
		
		/**
		 * 数量 
		 */
		public function get itemNum():Number
		{
			return _itemNum;
		}

		/**
		 * @private
		 */
		public function set itemNum(value:Number):void
		{
			if (value < 0)
			{
				_itemNum = 0;
			}
			else
			{
				_itemNum = value;
			}
		}

		/**
		 * 图标 
		 * @return 
		 * 
		 */		
		public function get itemIcon():String
		{
			return itemName;
		}
		
		public function toString():String
		{
			return ["name:", itemName, "id:" , itemID, "num:", itemNum].join(" ");
		}
		
		
	}
}