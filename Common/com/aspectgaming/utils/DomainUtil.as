package com.aspectgaming.utils 
{
    
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.media.Sound;
    import flash.system.ApplicationDomain;
    import flash.system.SecurityDomain;
    import flash.utils.Dictionary;

	/**
	 * 域反射器
	 * @author Mason.Li
	 */
	public class DomainUtil 
	{
		private static var _uiDomain:ApplicationDomain;
		
		public static function get uiDomain():ApplicationDomain
		{
			return _uiDomain;
		}

		public static function set uiDomain(value:ApplicationDomain):void
		{
			_uiDomain = value;
		}

	    /**
		 * 从应用程序域中获取MovieClip 
		 * @param name
		 * @param domain
		 * @return 
		 * 
		 */		
		public static function getMovieClip(name:String, domain:ApplicationDomain = null):MovieClip
		{
			var o:DisplayObject = getDisplayObject(name, domain);
			return ((o == null) ? null : (o as MovieClip));
		}
		
	    /**
		 * 从应用程序域中获取Sprite
		 * @param name
		 * @param domain
		 * @return 
		 * 
		 */		
		public static function getSprite(name:String, domain:ApplicationDomain = null):Sprite
		{
			var o:DisplayObject = getDisplayObject(name, domain);
			return ((o == null) ? null : (o as Sprite));
		}
		
		/**
		 * 从应用程序域中获取SimpleButton
		 * @param name
		 * @param domain
		 * @return 
		 * 
		 */		
		public static function getSimpleButton(name:String, domain:ApplicationDomain = null):SimpleButton
		{
			var o:DisplayObject = getDisplayObject(name, domain);
			return ((o == null) ? null : (o as SimpleButton));
		}
		
		/**
		 * 从应用程序域中获取Sound
		 * @param name
		 * @param domain
		 * @return 
		 * 
		 */		
		public static function getSound(name:String, domain:ApplicationDomain = null):Sound
		{
			var classReference:Class = getClass(name,domain);
			if(classReference)
			{
				try
				{
					return new classReference() as Sound;
				}
				catch(e:Error)
				{
					trace("DomainUtil getSound error:" + e.toString());
				}
			}
			return null;
		}
		
		/**
		 * 从应用程序域中获取DisplayObject
		 * @param name
		 * @param loader
		 * @return 
		 * 
		 */		
		public static function getDisplayObject(name:String, domain:ApplicationDomain = null):DisplayObject
		{
			var classReference:Class = getClass(name, domain);
			if (classReference != null)
			{
				try
				{
					return new classReference() as DisplayObject;
				}
				catch(e:Error)
				{
					trace("DomainUtil getDisplayObject error:" + e.toString());
					return null;
				}
			}
			return null;
		}
		
		public static function getBitMapData(name:String, domain:ApplicationDomain = null):BitmapData
		{
			var classReference:Class = getClass(name, domain);
			if (classReference != null)
			{
				try
				{
					return new classReference() as BitmapData;
				}
				catch(e:Error)
				{
					trace("DomainUtil getDisplayObject error:" + e.toString());
					return null;
				}
			}
			return null;
		}
		
		/**
		 * 从应用程序域中获取Class
		 * @param name
		 * @param domain
		 * @return 
		 * 
		 */	
		public static function getClass(name:String, domain:ApplicationDomain = null):Class
		{
			if(domain == null)
			{
				domain = _uiDomain;
			}
			if(domain && domain.hasDefinition(name))
			{
				return domain.getDefinition(name) as Class;
			}
			else
			{
				trace("DomainUtil getClass not hasDefinition:"+name);
			}
			return null;
		}
		
		public static function hasDefinition(name:String, domain:ApplicationDomain = null):Boolean
		{
			if(domain == null)
			{
				domain = _uiDomain;
			}
			
			if(domain.hasDefinition(name))
			{
				return true;
			}
			else
			{
				return false;	
			}
		}
		
		public static function getSecurityDomain(isUseSecurity:Boolean):SecurityDomain
		{
			return isUseSecurity ? SecurityDomain.currentDomain : null;
		}
		
		public static function getGameLoadDomain(isNewGame:Boolean, gameUrl:String):ApplicationDomain
		{
			if (domainDic[gameUrl])
			{
				return domainDic[gameUrl];
			}
			
			if (isNewGame)
			{
				if (gameUrl.indexOf("baccaratbasic") != -1)
				{
					return new ApplicationDomain(ApplicationDomain.currentDomain);
				}
				domainDic[gameUrl] = new ApplicationDomain(ApplicationDomain.currentDomain);
			}
			else
			{
				return new ApplicationDomain();	
			}
			return domainDic[gameUrl];
		}
		
		private static var domainDic:Dictionary = new Dictionary();
	}

}