package com.aspectgaming.utils
{
	import com.aspectgaming.animation.data.FramesVO;
	import com.aspectgaming.animation.data.SheetVO;
	import com.aspectgaming.utils.pool.SheetCachePool;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;

	/**
	 * MovieClip辅助 
	 * @author mason.li
	 * 
	 */	
	public class MovieClipUtil
	{
		
		/**
		 * MovieClip TO 帧序列 
		 * @param mc
		 * @param palette 属性 0 表示资源表示  其他字段内容为mc中 颜色转换 默认为NULL
		 * @return 
		 * 
		 */		
		public static function transformToSheet(mc:MovieClip, palette:Object = null, useCache:Boolean = true, resName:String = ""):SheetVO
		{
			var resID:String = resName == ""? getKeyFromMc(mc, palette) : resName;
			if (SheetCachePool.hasVO(resID) && useCache)
			{
				return SheetCachePool.getVO(resID);
			}
			else
			{
				var vo:SheetVO 	= new SheetVO();
				vo.resId 	  	= resID;

				frameToBitmapData(mc, palette, vo);
				
				if (useCache)
				{
					SheetCachePool.append(vo);
				}
				
				mc.stop();
				mc = null;
				return vo;
			}
		}
		
		/**
		 * 清除全部帧代码
		 */
		public static function clearFrameCode(mc:MovieClip):void
		{
			for (var m:int = 1; m <= mc.totalFrames; m++) 
			{
				mc.addFrameScript(m, null);
			}
		}
		
		private static function frameToBitmapData(mc:MovieClip, palette:Object, vo:SheetVO):void
		{
			
			var _clipRect:Rectangle;
			var _childName:Array;
			var _isMatch:Boolean;
			var _tmpMatrix:Matrix = new Matrix();
			
			for (var m:int = 1; m <= mc.totalFrames; m++) 
			{
				mc.addFrameScript(m, null);
				mc.gotoAndStop(m);
				
				if (palette != null) 
				{
					for (var i:int = 0; i < mc.numChildren; i++)
					{
						var child:DisplayObject = mc.getChildAt(i);
						if (child.name.indexOf('color') != -1) 
						{
							_childName = child.name.split('_');
							FiltersUtil.colorTransform(child, palette[_childName[1]]);
						}
					}
				}
				
				_clipRect = mc.getBounds(mc);
				
				_clipRect.x      = Math.floor(_clipRect.x) - 1;
				_clipRect.y      = Math.floor(_clipRect.y) - 1;
				_clipRect.width  = Math.ceil(_clipRect.width) + 3;
				_clipRect.height = Math.ceil(_clipRect.height) + 3;
				
				var framesVO:FramesVO = new FramesVO();
				framesVO.bitmapData = new BitmapData(_clipRect.width, _clipRect.height, true, 0);
				
				framesVO.offsetX = _clipRect.x;
				framesVO.offsetY = _clipRect.y;
				
				_tmpMatrix.tx = 0 - _clipRect.x;
				_tmpMatrix.ty = 0 - _clipRect.y;
				
				_clipRect.x = 0;
				_clipRect.y = 0;
				
				framesVO.bitmapData.draw(mc, _tmpMatrix, null, null, _clipRect);
//				trace(framesVO.bitmapData.getVector(_clipRect));
				
				_isMatch = false;
				for each (var itemVO:FramesVO in vo.framesSet) 
				{
					if (framesVO.offsetX == itemVO.offsetX && framesVO.offsetY == itemVO.offsetY &&
						framesVO.bitmapData.compare(itemVO.bitmapData) == 0) 
					{
							_isMatch = true;
							break;
					}
				}
				
				if (_isMatch) 
				{
					framesVO.bitmapData.dispose();
					framesVO = null;
					vo.framesSet.push(itemVO);
				} 
				else 
				{
					vo.memorySize += (framesVO.bitmapData.width * framesVO.bitmapData.height * 4);
					vo.framesSet.push(framesVO);
				}
			}
		}
		
		private static function getKeyFromClassName(className:String, palette:Object = null):String
		{
			className = className.replace('::', '.');
			if (palette != null) 
			{
				className = className + '_' + palette[0].toString(16);
			}
			return className;
		}
		
		private static function getKeyFromMc(mc:MovieClip, palette:Object = null):String
		{
			return getKeyFromClassName(getQualifiedClassName(mc), palette);
		}
	}
}