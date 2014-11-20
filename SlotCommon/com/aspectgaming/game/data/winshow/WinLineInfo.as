package com.aspectgaming.game.data.winshow
{
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.utils.SlotUtil;
	
	/**
	 * 赢钱线 信息 
	 * @author mason.li
	 * 
	 */	
	public class WinLineInfo
	{
		public static const ScatterTag:String = "Scatter";
		
		private var _sourceArr:Array;
		private var _winLineList:Vector.<LineInfo>;
		
		public function WinLineInfo()
		{
			_winLineList = new Vector.<LineInfo>();
		}
		
		public function get winLineList():Vector.<LineInfo>
		{
			return _winLineList;
		}

		public function parseSourceArr(arr:Array, stops:Array):void
		{
			_winLineList.length = 0;
			if (arr && arr.length > 0)
			{
				_sourceArr = arr;
				processInfo(stops);
			}
		}
		
		public function clear():void
		{
			_sourceArr = null;
			_winLineList.length = 0;
		}
		
		public function get hasWinLine():Boolean
		{
			return _winLineList && _winLineList.length > 0;
		}
		
		private function processInfo(stops:Array):void
		{
			for (var i:uint = 0; i < _sourceArr.length; i++)
			{
				var listArr:Array = _sourceArr[i];
				var info:LineInfo = new LineInfo();
				if (listArr[0] == ScatterTag)
				{
					info.isScatter = true;
				}
				else
				{
					info.lineIndex = uint(listArr[0]) + 1;
				}
				
				info.sourceList = GameSetting.getLineInfo(info.lineIndex);
				info.linePos = SlotUtil.getLineWinPos(Number(listArr[1]));
				info.lineWin = Number(listArr[2]);
				info.lineWinTime = uint(listArr[3]);
				info.isSpeical = Boolean(listArr[4]);
				info.setup(stops);
				_winLineList.push(info);
			}
		}
	}
}