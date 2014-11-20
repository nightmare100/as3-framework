package com.aspectgaming.item.data
{
	import com.aspectgaming.item.constant.ItemType;
	
	/**
	 * 装备物品 
	 * @author mason.li
	 * 
	 */	
	public class EquipItem extends Item
	{
		public function EquipItem(id:uint)
		{
			this.itemType = ItemType.ITEM_EQUIP;
			super(id);
		}
	}
}