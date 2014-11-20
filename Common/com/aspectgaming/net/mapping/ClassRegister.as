package com.aspectgaming.net.mapping
{
	import com.aspectgaming.net.constant.ProtoTransType;
	import com.aspectgaming.net.socket.MessageVO;
	import com.aspectgaming.utils.LoggerUtil;
	import com.netease.protobuf.Message;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 类注册公开API 
	 * @author mason.li
	 * 
	 */	
	public class ClassRegister
	{
		private static var _messageDic:Dictionary = new Dictionary();
		
		/**
		 * 注册大厅DTO 
		 * 
		 */		
		public static function setupLobby():void
		{
			
		}
		
		/**
		 * AMF 添加类注册信息 
		 * @param req				请求命令
		 * @param reqNameSpcae		请求类命名空间
		 * @param reqClass			请求类
		 * @param resNameSpace		响应类命名空间
		 * @param resClass			响应类
		 * 
		 */		
		public static function addDataStruct(req:String, reqNameSpcae:String, reqClass:Class, resNameSpace:String, resClass:Class):void
		{
			ServerClassRegister.registerClass(req, reqNameSpcae, reqClass, resNameSpace, resClass);
		}
		
		/**
		 * 注册单个DTO 
		 * @param nameSpace		命名空间
		 * @param cls			类名
		 * 
		 */		
		public static function registerSingle(nameSpace:String, cls:Class):void
		{
			ServerClassRegister.registerSingle(nameSpace, cls);
		}
		
		public static function killMapping():void
		{
			ServerClassRegister.killDataClassMapping();
		}
		
		public static function resetMapping():void
		{
			ServerClassRegister.resetDataClassMapping();
		}
		
		//================================= Socket with pb ============================================
		
		public static function disposeMessage():void
		{
			_messageDic = null;
		}
		
		/**
		 * 注册PB 协议方法与数据关联 
		 * @param method
		 * @param cls
		 * @param desc 请求描述字段
		 * @param proxyName 代理名称(监听名, 请求名)
		 */		
		public static function registerMessageVO(cmd:uint, cls:Class, cmdResponse:uint, clsResponse:Class, desc:String, proxyName:String):void
		{
			if (!_messageDic)
			{
				_messageDic = new Dictionary();
			}
			_messageDic[proxyName] = new MessageVO(cmd, cls, cmdResponse, clsResponse, desc);
		}
		
		public static function getMessageDesc(type:String):String
		{
			if (_messageDic[type])
			{
				return _messageDic[type].description;
			}
			else
			{
				return "未知命令";
			}
		}
		
		/**
		 * 通过命令查找代理名称 
		 * @param cmd
		 * @return 
		 * 
		 */		
		public static function getProxyName(cmd:int):String
		{
			var vo:MessageVO;
			for (var key:String in _messageDic)
			{
				vo = _messageDic[key];
				if (vo.cmdReq == cmd || vo.cmdRes == cmd)
				{
					return key;
				}
			}
			return null;
		}
		
		/**
		 * 获取请求数据 VO 类型 
		 * @param name
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getMessageVO(name:String, type:String):Class
		{
			if (_messageDic[name])
			{
				var vo:MessageVO = _messageDic[name];
				if (type == ProtoTransType.Request)
				{
					return vo.reqClass;
				}
				else
				{
					return vo.resClass;
				}
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 获取请求CMD 
		 * @param name
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getCmd(name:String, type:String):int
		{
			if (_messageDic[name])
			{
				var vo:MessageVO = _messageDic[name];
				if (type == ProtoTransType.Request)
				{
					return vo.cmdReq;
				}
				else
				{
					return vo.cmdRes;
				}
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * Socket PB数据转换 
		 * @param func
		 * @param byteArr
		 * @return 
		 * 
		 */		
		public static function transferToMessage(type:String, byteArr:ByteArray):*
		{
			if (_messageDic[type] != null)
			{
				var msgVO:MessageVO = _messageDic[type];
				var msg:Message = new (msgVO.resClass as Class);
				LoggerUtil.traceNormal("transferDataPosition", byteArr.position);
				msg.mergeFrom(byteArr);
				return msg;
			}
			return byteArr;
		}
	}
}