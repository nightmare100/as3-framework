package com.aspectgaming.ui.base
{
	import com.aspectgaming.globalization.managers.ClientManager;
	import com.aspectgaming.ui.iface.IMovement;
	import com.aspectgaming.utils.PointUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 基础运动元件 
	 * @author mason.li
	 * 
	 */	
	public class BaseMoveMemtItem extends Sprite implements IMovement
	{
		/**
		 * 帧速度 
		 */		
		protected var _movieSpeed:Number = 40;
		private var _onCompleteHandler:Function;
		private var _onUpdateHandler:Function;
		
		public function BaseMoveMemtItem()
		{
			super();
		}
		
		public function get movieSpeed():Number
		{
			return _movieSpeed;
		}

		public function set movieSpeed(value:Number):void
		{
			_movieSpeed = value;
		}

		/**
		 * 直线运动 
		 * @param endPoint
		 * @param startPoint
		 * @param duration
		 * @param onComplete
		 * @param onUpdate
		 * 
		 */		
		public function moveLine(endPoint:Point, startPoint:Point=null, duration:Number = 0, onComplete:Function=null, onUpdate:Function=null):void
		{
			TweenLite.killTweensOf(this);
			var obj:Object = {};
			obj.x = endPoint.x;
			obj.y = endPoint.y;
			obj.onComplete = animationComplete;
			obj.onUpdate = animationUpdate;
			
			_onCompleteHandler = onComplete;
			_onUpdateHandler = onUpdate;
			
			if (startPoint)
			{
				this.x = startPoint.x;
				this.y = startPoint.y;
			}
			else
			{
				startPoint = new Point(this.x, this.y);
			}
			
			if (duration == 0)
			{
				duration = Point.distance(startPoint, endPoint) / (_movieSpeed * ClientManager.frameRate);
			}
			TweenLite.to(this, duration, obj);
		}
		
		/**
		 * 曲线运动 
		 * @param endPoint
		 * @param isUp
		 * @param startPoint
		 * @param power
		 * @param duration
		 * @param autoRotation
		 * @param onComplete
		 * @param onUpdate
		 * 
		 */		
		public function moveParabola(endPoint:Point, isUp:Boolean, startPoint:Point=null, power:uint = 4, duration:Number = 0, autoRotation:Boolean = true, onComplete:Function=null, onUpdate:Function=null):void
		{
			TweenMax.killTweensOf(this);
			
			var obj:Object = {};
			obj.x = endPoint.x;
			obj.y = endPoint.y;
			obj.onComplete = animationComplete;
			obj.onUpdate = animationUpdate;
			
			_onCompleteHandler = onComplete;
			_onUpdateHandler = onUpdate;
			
			if (startPoint)
			{
				this.x = startPoint.x;
				this.y = startPoint.y;
			}
			else
			{
				startPoint = new Point(this.x, this.y);
			}
			
			if (duration == 0)
			{
				duration = Point.distance(startPoint, endPoint) / (_movieSpeed * ClientManager.frameRate);
			}
			obj.bezier = PointUtil.getBezierArray(startPoint, endPoint, isUp, power);
			obj.orientToBezier = autoRotation;
			TweenMax.to(this, duration, obj);
		}
		
		protected function animationComplete():void
		{
			
			if (_onCompleteHandler != null)
			{
				_onCompleteHandler();
			}
		}
		
		protected function animationUpdate():void
		{
			
			if (_onUpdateHandler != null)
			{
				_onUpdateHandler();
			}
		}
	}
}