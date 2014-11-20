package com.aspectgaming.game.data.progressive
{
	import com.aspectgaming.game.net.vo.dto.WinProgressiveDTO;
	import com.aspectgaming.game.net.vo.dto.WinProgressiveLevelDTO;
	import com.aspectgaming.utils.NumberUtil;

	public class ProgressiveInfo
	{
		public var totalReward:Number;
		public var levelInfo:Vector.<WinProgressiveLevelDTO>;
		
		public function parse(dto:WinProgressiveDTO):void
		{
			totalReward = dto.totalRewardWinAmount;
			levelInfo = new Vector.<WinProgressiveLevelDTO>(dto.levels.length);
			for (var i:int = 0; i < dto.levels.length; i++ )
			{
				var linfo:WinProgressiveLevelDTO = dto.levels[i];
				linfo.progressiveAmount = linfo.progressiveAmount;
				levelInfo[i] = linfo;
			}
		}
	}
}