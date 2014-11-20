package com.aspectgaming.item.data
{
	import com.aspectgaming.item.constant.ItemType;

	public class PropItem extends Item
	{
		public function PropItem(id:int)
		{
			itemType = ItemType.ITEM_PROP;
			super(id);
		}
	}
}