package com.aspectgaming.net.amf
{
	
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.utils.LoggerUtil;
	
	import flash.net.ObjectEncoding;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * MsgRequest Factory 
	 * @author mason.li
	 * 
	 */	
	public class RequestFactory
	{

		public static function createRequest(_host:String, parm:Object = null, func:String = null):URLRequest
		{
			var urlReq:URLRequest = new URLRequest();
			var reqName:String = func;
			
			var cookieStr:String = (!ClientManager.canUseCookie && ClientManager.cookieStr) ? "&aspectUid=" + ClientManager.cookieStr : "";
			urlReq.url = _host + ((func && func != "")?("?rpc=" + func):"") + "&r=" + Math.random() + cookieStr;
			
			
			urlReq.method = URLRequestMethod.POST;
			urlReq.contentType="application/x-amf";
			if (parm)
			{
				var dataByte:ByteArray = new ByteArray();
				dataByte.objectEncoding = ObjectEncoding.AMF3;
				dataByte.writeObject(parm);
				if (ClientManager.useEncode)
				{
					dataByte = AMFConnection.gzipEncoder.compressToByteArray(dataByte);
				}
				
				urlReq.data = dataByte;
				LoggerUtil.traceNormal("[AMFRequestSend]", "func:", func, "parmLen:", dataByte.length, "url:" , urlReq.url);
			}
			else
			{
				LoggerUtil.traceNormal("[AMFRequestSend]", "func:", func, "url:" , urlReq.url);
			}
			
			return urlReq;
		}
	}
}