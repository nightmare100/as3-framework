package com.aspectgaming.game.config.reel
{
	
	/**
	 * 轮子加速度信息 
	 * @author mason.li
	 * 
	 */	
	public class ReelAcceleration
	{
		public var upDistance:Number;
		public var upDurtion:Number;
		public var vStart:Number;
		public var vMax:Number;
		public var vStop:Number;
		public var useBlur:Boolean;
		public var stopDistance:Number;
		public var stopDur:Number;
		
		public function ReelAcceleration(xml:XML)
		{
			vStart = Number(xml.@vStart);
			vMax = Number(xml.@vMax);
			vStop = Number(xml.@vStop);
			useBlur = Boolean(uint(xml.@vBlur));
			upDistance = Number(xml.@upDistance);
			upDistance = isNaN(upDistance) ? 0 : upDistance;
			
			upDurtion = Number(xml.@upDur);
			upDurtion = isNaN(upDurtion) ? 0 : upDurtion;
			
			stopDistance = Number(xml.@stopDistance);
			stopDistance = isNaN(stopDistance) ? 0 : stopDistance;
			
			stopDur = Number(xml.@stopDur);
			stopDur = isNaN(stopDur) ? 0 : stopDur;
		}
		
		public function updateSpeed(rate:Number):void
		{
			vStart = vStart * (1 + rate);
			vMax = vMax * (1 + rate);
			trace("vStart",vStart,"vMax",vMax)
		}
	}
}