package com.aspectgaming.data.configuration.item
{
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.item.constant.ConsumeRule;
	import com.aspectgaming.item.constant.ItemDefined;
	
	import flash.utils.Dictionary;

	/**
	 * 物品描述 
	 * @author mason.li
	 * 
	 */	
	public class ItemDesc
	{
		public var desc:String;
		public var price:Number;
		public var name:String;
		public var itemID:int;
		public var defaultBuy:Number;
		public var defaultDesc:String;
		
		private var _consumeDic:Object;
		
		public function ItemDesc()
		{
			_consumeDic = {};
		}
		
		public function addConsume(xml:XML):void
		{
			_consumeDic[int(xml.@gameid)] = {rule:String(xml.@rule) ,num:Number(xml)};
		}
		
		public function canGameUse(gameId:int):Boolean
		{
			return gameId.toString() in _consumeDic;
		}
		
		public function getGameConsume(gameId:int):Number
		{
			if (_consumeDic[gameId])
			{
				switch (_consumeDic[gameId].rule)
				{
					case ConsumeRule.RULE_BET:
						if (itemID == ItemDefined.ITEM_POWER_SPIN && ClientManager.itemMgr.allInTotalBet > 0)
						{
							return _consumeDic[gameId].num * ClientManager.itemMgr.allInTotalBet;
						}else if (itemID == ItemDefined.ITEM_POWER_SPIN){
							return _consumeDic[gameId].num * (ClientManager.currGame.totalBet > ClientManager.currGame.maxBet ? ClientManager.currGame.maxBet : ClientManager.currGame.totalBet);
						}
						return _consumeDic[gameId].num * ClientManager.currGame.totalBet;
						break;
					case ConsumeRule.RULE_FIX:
					default:
						return _consumeDic[gameId].num;
						break;
				}
			}
			
			return -1;
		}
		
		public static function parseItemDesc(xml:XML):ItemDesc
		{
			var item:ItemDesc = new ItemDesc();
			item.desc = String(xml.@desc);
			item.price = Number(xml.@price);
			item.name = String(xml.@name);
			item.itemID = int(xml.@id);
			item.defaultBuy = int(xml.@defaultBuy);
			item.defaultDesc = String(xml.@defaultDesc);
			
			for each (var consume:XML in xml.consume)
			{
				item.addConsume(consume);
			}
			return item;
		}
	}
}