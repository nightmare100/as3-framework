package com.aspectgaming.game.animation
{
	import com.aspectgaming.game.constant.asset.AnimationDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;

	public class RetriggerAnimation extends BaseGameAnimation
	{
		public function RetriggerAnimation()
		{
			super();
		}
		
		override protected function init():void
		{
			_mc = GameAssetLibrary.getMovieClip(AnimationDefined.RETRIGGER)
			_mc.gotoAndStop(1);
		}
		
		override protected function onBeforeStart():void
		{
			_mc["W1"].visible = false;
			_mc["W2"].visible = false;
			_mc["W3"].visible = false;
			
			_mc["W" + (_data - 2)].visible = true;
		}
		
		
	}
}