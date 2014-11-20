package com.aspectgaming.globalization.managers
{
	import com.aspectgaming.item.Inventory;
	import com.aspectgaming.item.constant.ItemDefined;
	import com.aspectgaming.item.data.Item;
	import com.aspectgaming.item.event.ItemEvent;
	
	import org.robotlegs.utilities.modular.mvcs.ModuleActor;

	/**
	 * 物品管理 
	 * @author mason.li
	 * 
	 */	
	public class ItemManager extends ModuleActor
	{
		private var _inventory:Inventory;
		
		private var _usedItem:Vector.<Item>;
		
		public function ItemManager()
		{
			_inventory = new Inventory();
			_usedItem = new Vector.<Item>();
		}
		
		/**
		 * 使用的物品 
		 */
		public function get usedItem():Vector.<Item>
		{
			return _usedItem;
		}
		
		public function get allInTotalBet():Number
		{
			for each (var item:Item in _usedItem)
			{
				if (item.itemID == ItemDefined.ITEM_ALL_IN)
				{
					return item.parmNumber1 * item.parmNumber2;
				}
			}
			
			return 0;
		}
		
		public function clearUseItem():void
		{
			_usedItem.length = 0;
		}

		public function addItem(id:int, num:Number, type:uint = 2):void
		{
			var item:Item = _inventory.addItem(id, num,type);
			dispatchToModules(new ItemEvent(ItemEvent.ITEM_ADD, item));
		}
		
		public function removeItem(id:int, num:Number):void
		{
			var item:Item = _inventory.removeItem(id, num);
			dispatchToModules(new ItemEvent(ItemEvent.ITEM_REMOVED, item));
		}
		
		public function getItemByID(id:int):Item
		{
			return _inventory.getItemByID(id);
		}
		
		public function getItemByType(type:String):Vector.<Item>
		{
			return _inventory.getItemByType(type);
		}
		
		public function getItemByGameID(id:String):Vector.<Item>
		{
			return _inventory.getItemByGameID(id);
		}
	}
}