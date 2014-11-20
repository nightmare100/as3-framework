package com.aspectgaming.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * Point辅助 
	 * @author mason.li
	 * 
	 */	
	public class PointUtil
	{
		public static const ZERO_POINT:Point = new Point(0, 0);
		
		public static function globalToLocal(target:DisplayObject, x:Number = 0, y:Number = 0):Point
		{
			if (target)
			{
				var pt:Point = target.globalToLocal(new Point(x, y));
				pt.x += target.x;
				pt.y += target.y;
				return pt
			}
			else
			{
				return new Point(x, y);
			}
		}
		
		public static function localToGoble(target:DisplayObject, x:Number = 0, y:Number = 0):Point
		{
			if (target)
			{
				var pt:Point = target.localToGlobal(ZERO_POINT);
				pt.x -= x;
				pt.y -= y;
				return pt;
			}
			else
			{
				return new Point(x, y);
			}
		}
		
		/**
		 * 获取出发点 到 目标点的 角度 
		 * @param start
		 * @param des
		 * @return 
		 * 
		 */		
		public static function getPointAngle(start:Point, des:Point):Number
		{
			return radianToAngle(getPointRadian(start, des));
		}
		
		/**
		 * 获取弧度 
		 * @param start
		 * @param des
		 * @return 
		 * 
		 */		
		public static function getPointRadian(start:Point, des:Point):Number
		{
			var distant:Number = Point.distance(start, des);
			var disHeight:Number = des.x - start.x;
			var radian:Number = Math.asin(disHeight / distant);
			
			return radian;
		}
		
		/**
		 * 弧度 =》 角度 
		 * @return 
		 * 
		 */		
		public static function radianToAngle(r:Number):Number
		{
			return r / Math.PI * 180;
		}
		
		/**
		 * 获取贝塞尔曲线点 
		 * @param start
		 * @param end
		 * @param isUp 是否为上曲线
		 * @param n 点的数量
		 * @param linePower 曲度  值越小 曲度越大
		 * @return 
		 * 
		 */			
		public static function getBezierArray(start:Point, end:Point, isUp:Boolean = false, n:uint = 4, linePower:uint = 4):Array
		{
			//弧度	
			var radian:Number = getPointRadian(start, end);
			var currentRadian:Number = Math.PI / 2 - radian;
			
			//曲度
			var lineDer:Number = Point.distance(start, end) / linePower;
			var isRight:Boolean = start.x < end.x;
			
			var hSpace:Number = (end.x - start.x) / (n + 1);
			var vSpace:Number = (end.y - start.y) / (n + 1);
			var result:Array = [];
			var tPoint:Point = new Point();
			
			for (var i:uint = 0; i < n; i++)
			{
				tPoint.x = start.x + hSpace * (i + 1);
				tPoint.y = start.y + vSpace * (i + 1);
				var currIdx:uint = i + 1;
				var perfect:Number = getMiddlePerfect(currIdx, n);
				
				//偏移长度
				var currentDer:Number = lineDer * perfect;
				
				if (isUp)
				{
					tPoint.offset(0, 0 - currentDer * Math.sin(currentRadian));
				}
				else
				{
					tPoint.offset(0, currentDer * Math.sin(currentRadian));
				}
				
				var offsetX:Number = currentDer * Math.cos(currentRadian);
				tPoint.offset(getOffsetX(offsetX, isUp, isRight, start.y > end.y), 0);
				
				result.push({x:tPoint.x, y:tPoint.y});
			}
			result.unshift(start);
			result.push(end);
			return result;
		}
		
		private static function getOffsetX(n:Number, isUp:Boolean, isRight:Boolean, isLowToHigh:Boolean):Number
		{
			var zResult:Number = Math.abs(n);
			if (isUp)
			{
				if (isRight)
				{
					return isLowToHigh ? 0 - zResult : zResult;
				}
				else
				{
					return isLowToHigh ? zResult : 0 - zResult;
				}
			}
			else
			{
				if (isRight)
				{
					return isLowToHigh ? zResult : 0 - zResult;
				}
				else
				{
					return isLowToHigh ? 0 - zResult : zResult;
				}
			}
		}
		
		private static function getMiddlePerfect(idx:uint, t:uint):Number
		{
			var s:Number = (t + 1) / 2;
			var perfect:Number;
			if (idx > s)
			{
				perfect =  (s * 2 - idx) / s ;
			}
			else
			{
				perfect = idx / s;
			}
			
			return perfect;
		}
		
		public static function angleToRadian(n:Number):Number
		{
			return n / 180 * Math.PI;
		}
		
		/**
		* 通过角度向量 获取 偏移后的坐标 
		* @param source 原始坐标
		* @param len  偏移量 
		* @param rota -180 - 180 以x轴正方向起 为0度
		* @return 
		* 
		*/		
		public static function getVectorPoint(source:Point, len:Number, rota:Number):Point
		{
			var resultPt:Point = new Point();
			
			if (rota >= 0 <= 90)
			{
				rota = angleToRadian(rota);
				resultPt.x = Math.cos(rota) * len;
				resultPt.y = -(Math.sin(rota) * len);
			}
			else if (rota >= 90 && rota <= 180)
			{
				rota = 180 - rota;
				rota = angleToRadian(rota);
				resultPt.x = -(Math.cos(rota) * len);
				resultPt.y = -(Math.sin(rota) * len);
			}
			else if (rota < 0 && rota >= -90)
			{
				rota = Math.abs(rota);
				rota = angleToRadian(rota);
				resultPt.x = Math.cos(rota) * len;
				resultPt.y = Math.sin(rota) * len;
			}
			else
			{
				rota = 180 - Math.abs(rota);
				rota = angleToRadian(rota);
				resultPt.x = -(Math.cos(rota) * len);
				resultPt.y = Math.sin(rota) * len;
			}
			
			return source.add(resultPt);
		}
	}
}