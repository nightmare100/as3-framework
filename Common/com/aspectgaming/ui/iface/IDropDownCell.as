package com.aspectgaming.ui.iface
{
	/**
	 * 下拉列表接口 
	 * @author mason.li
	 * 
	 */	
	public interface IDropDownCell extends IDataCell
	{
		function onOver():void;
		function onOut():void;
		function onClick():void;
	}
}