package com.aspectgaming.item
{
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.item.constant.ItemType;
	import com.aspectgaming.item.data.Item;
	
	import flash.utils.Dictionary;

	/**
	 * 物品清单
	 * @author mason.li
	 * 
	 */	
	public class Inventory
	{
		private var _itemDic:Dictionary;
		
		public function Inventory()
		{
			_itemDic = new Dictionary();
			_itemDic[ItemType.ITEM_EQUIP] = new Dictionary();
			_itemDic[ItemType.ITEM_PROP] = new Dictionary();
		}
		
		/**
		 * 添加物品 
		 * @param id 物品ID
		 * @param num 物品数量
		 * 
		 */		
		public function addItem(id:int, num:Number, type:uint):Item
		{
			if (_itemDic[type][id])
			{
				Item(_itemDic[type][id]).itemNum += num;
				return Item(_itemDic[type][id]);
			}
			_itemDic[type][id] = new Item(id);
			Item(_itemDic[type][id]).itemNum = num;
			return Item(_itemDic[type][id]);
		}
		
		public function removeItem(id:int, num:Number):Item
		{
			for (var key:String in _itemDic)
			{
				if (_itemDic[key][id])
				{
					Item(_itemDic[key][id]).itemNum -= num;
					return Item(_itemDic[key][id]);
				}
			}
			return null;
		}
		
		public function getItemByType(type:String):Vector.<Item>
		{
			if (type == ItemType.ITEM_ALL.toString())
			{
				var result:Vector.<Item> = Vector.<Item>([]);
				for (var key:* in _itemDic)
				{
					var typeCollect:Vector.<Item> = getItemByType(key);
					if (typeCollect)
					{
						result = result.concat(typeCollect);
					}
				}
				
				return result;
			}
			
			if (_itemDic[type])
			{
				var items:Vector.<Item> = new Vector.<Item>();
				for each (var item:Item in _itemDic[type])
				{
					items.push(item);
				}
				return items.sort(sortByID);
			}
			return null;
		}
		
		public function getItemByGameID(gameID:String):Vector.<Item>
		{
			var items:Vector.<Item> = new Vector.<Item>();
			for each (var item:Item in _itemDic[ItemType.ITEM_PROP])
			{
				if (item.getItemConsume(int(ClientManager.currGame.gameID)) != -1) {
					items.push(item);
				}
			}
			return items.sort(sortByID);
		}
		
		private function sortByID(item1:Item, item2:Item):int
		{
			if (item1.itemID > item2.itemID)
			{
				return 1;
			}
			else if (item1.itemID == item2.itemID)
			{
				return 0;
			}
			else
			{
				return -1;
			}
		}
		
		public function getItemByID(id:int):Item
		{
			for (var key:String in _itemDic)
			{
				if (_itemDic[key] && _itemDic[key][id])
				{
					return _itemDic[key][id];
				}
			}
			return null;
		}
	}
}