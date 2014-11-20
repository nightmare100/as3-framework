package com.aspectgaming.data.loading
{
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.utils.DomainUtil;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.assetloader.base.Param;
	import org.assetloader.core.IParam;

	/**
	 * 加载信息 
	 * @author mason.li
	 * 
	 */	
	public class LoadingDataInfo
	{
		public var url:String;
		public var id:String;
		private var _ldContext:LoaderContext;
		private var _parm:IParam;
		
		/**
		 * 是否加载完成 
		 */		
		public var isComplete:Boolean;		
		
		public function LoadingDataInfo(_url:String, _id:String = null, appDomain:ApplicationDomain = null)
		{
			this.url = _url;
			this.id = (_id == null) ? _url : _id;
			setLoaderContext(appDomain);
		}

		public function get parm():IParam
		{
			if (!_parm)
			{
				_parm = new Param(Param.LOADER_CONTEXT, ldContext);
			}
			return _parm;
		}

		public function get ldContext():LoaderContext
		{
			return _ldContext;
		}

		private function setLoaderContext(app:ApplicationDomain):void
		{
			if (app)
			{
				_ldContext = new LoaderContext(false, app, DomainUtil.getSecurityDomain(ClientManager.useFaceBookConnect));
			}
		}

	}
}