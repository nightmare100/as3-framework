package com.aspectgaming.game.module.gamble.control
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class CardReversal
	{
		private var defoutSpeed:int;
		private var card:MovieClip;
		private var _nextFrame:int;
		public function CardReversal(_mc:MovieClip)
		{
			card = _mc;
			reversalBack(true);
		}
		public function reversalBack(force:Boolean = false):void
		{
			_nextFrame = 5;
			if(force){
				card.gotoAndStop(5);
			}else{
				turnHalf()
			}
		}
		public function reversal(cv:int,force:Boolean = false):void
		{
			_nextFrame = cv;
			if(force){
				card.gotoAndStop(cv);
			}else{
				turnHalf()
			}
		}
		private function turnHalf():void{
			TweenMax.to(card,0.3,{rotationY:-90,y:card.y-2,onComplete:changeCard})
		}
		private function changeCard():void{
			card.gotoAndStop(_nextFrame);
			card.rotationY = 90;
			TweenMax.to(card,0.3,{rotationY:0,y:card.y+2})
		}
	}
}