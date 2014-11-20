package com.aspectgaming.game.animation
{
	import com.aspectgaming.game.constant.asset.AnimationDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.GameGlobalRef;
	import com.aspectgaming.game.data.progressive.ProgressiveInfo;
	import com.aspectgaming.game.net.SlotAmfCommand;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class ProgressiveAnimation extends BaseGameAnimation
	{
		private const START_ROLL_FRAME:uint = 5;
		private const END_ROOL_FRAME:uint = 221;
		
		private var _numMc:MovieClip;
		private var _numText:TextField;
		
		private var _levelTxt:TextField;
		
		private var _currentIndex:uint;
		
		public function ProgressiveAnimation()
		{
			super();
		}
		
		override protected function onBeforeStart():void
		{
			_currentIndex = (progressInfo.levelInfo.length > 0)?(progressInfo.levelInfo.length - 1):0;
			_mc.gotoAndStop(1);
			updateLevelWord();
			_numMc.visible = false;
			_numText.text = "";
		}
		
		private function updateLevelWord():void
		{
			_levelTxt.text = progressInfo.levelInfo[_currentIndex].progressiveLevelName.toLocaleUpperCase();
		}
		
		override protected function init():void
		{
			_mc = GameAssetLibrary.getMovieClip(AnimationDefined.PROGRESSIVE);
			_numMc = _mc["num"];
			_numText = _numMc["_txt"];
			_levelTxt = _mc["str"]["level"]["_txt"];
			
			_numMc.visible = false;
			super.init();
		}
		
		public function get progressInfo():ProgressiveInfo
		{
			return _data as ProgressiveInfo;
		}
		
		public function get totalRollTime():uint
		{
			return END_ROOL_FRAME - START_ROLL_FRAME;
		}
		
		public function get currentRollTime():int
		{
			return _mc.currentFrame - START_ROLL_FRAME;
		}
		
		public function get timeTickToChangeWord():uint
		{
			return totalRollTime / progressInfo.levelInfo.length;
		}
		
		override protected function onAnimaing():void
		{
			if (_mc.currentFrame == START_ROLL_FRAME)
			{
				if (!_numMc.visible)
				{
					_numMc.visible = true;
				}
				updateLevelWord();
			}
			if (_mc.currentFrame > START_ROLL_FRAME && _mc.currentFrame < END_ROOL_FRAME)
			{
				_numText.text = (currentRollTime / totalRollTime * progressInfo.levelInfo[_currentIndex].rewardWinAmount / 100).toFixed(2);
			}
			if (_mc.currentFrame == END_ROOL_FRAME)
			{
				_numText.text = (progressInfo.levelInfo[_currentIndex].rewardWinAmount / 100).toFixed(2);
				if(_currentIndex > 0){
					_currentIndex--;
					_mc.gotoAndPlay(1);
				}
			}
			if (_mc.currentFrame == (_mc.totalFrames - 1))
			{
				GameGlobalRef.gameServer.sendRequest(SlotAmfCommand.CMD_GAME_PROGRESSIVE_END);
			}
			super.onAnimaing();
		}
	}
}