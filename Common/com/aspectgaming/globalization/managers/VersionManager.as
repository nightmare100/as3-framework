package com.aspectgaming.globalization.managers
{
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 版本信息管理 
	 * @author mason.li
	 * 
	 */	
	public class VersionManager
	{

		public static function addContextMenu(name:String, func:Function = null):void
		{
			if (!LayerManager.root.contextMenu)
			{
				LayerManager.root.contextMenu = new ContextMenu();
			}
			
			var menu:ContextMenu = LayerManager.root.contextMenu;
			var menuItem:ContextMenuItem = new ContextMenuItem(name);
			if (func != null)
			{
				menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, func);
			}
			menu.customItems.push(menuItem);
			
			LayerManager.root.contextMenu = menu;
		}
		
		public static function hideBuiltInItems():void
		{
			LayerManager.root.contextMenu.hideBuiltInItems();
		}
		
		public static function removeMenu(name:String):void
		{
			if (!LayerManager.root.contextMenu)
			{
				return;
			}
			
			var menu:ContextMenu = LayerManager.root.contextMenu;
			for (var i:uint = 0 ; i < menu.customItems.length; i++)
			{
				if (ContextMenuItem(menu.customItems[i]).caption == name)
				{
					menu.customItems.splice(i, 1);
					return;
				}
			}
			
			LayerManager.root.contextMenu = menu;
		}
	}
}