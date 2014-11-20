package com.aspectgaming.data.configuration.game
{
	import com.aspectgaming.data.configuration.Configuration;
	import com.aspectgaming.data.configuration.game.constant.PageDefined;
	import com.aspectgaming.globalization.managers.ClientManager;

	//import com.aspectgaming.data.configuration.game.constant.PageDefined;

	/**
	 * 页面信息 布局
	 * @author mason.li
	 * 
	 */	
	public class PageInfo
	{
		public var name:String;
		public var parentName:String;
		public var column:int;
		public var row:int;
		public var vSpace:int;
		public var hSpace:int;
		public var focusHeight:int;
		public var gameInfos:Vector.<GameCellInfo>;
		
		public var defaultPageIndex:uint = 1;
		
		public var isMainPage:Boolean;
		
		public function PageInfo(xml:XML = null)
		{
			if (xml)
			{
				name = String(xml.@name);
				parentName = String(xml.@parent);
				column = int(xml.@column);
				row = int(xml.@row);
				vSpace = int(xml.@vspace);
				hSpace = int(xml.@hspace);
				focusHeight = int(xml.@focusHeight);
				isMainPage = Boolean(uint(xml.@isMainPage));
				
				fullGameCell(xml);
			}
		}
		
		public function get sortedGameInfo():Vector.<GameCellInfo>
		{
			if (name == PageDefined.Slots_Page)
			{
				var result:Vector.<GameCellInfo> = new Vector.<GameCellInfo>();
				var copyVec:Vector.<GameCellInfo> = gameInfos.concat()
				result[0] = copyVec[0];
				copyVec.splice(0, 1);
				copyVec = normalSort(copyVec);
				
				var arr:Array = ClientManager.lobbyModel.playGameIds;
				var idInPlayList:int = ClientManager.lobbyModel.playGameIds.indexOf(result[0].normalGameID);
				
				if (idInPlayList != -1 && !Configuration.gameListConf.hasExistInList(result[0].name, copyVec))
				{
					ClientManager.lobbyModel.playGameIds.splice(idInPlayList, 1);
				}
				
				//玩过的排在前面
				var addCells:Vector.<GameCellInfo> = new Vector.<GameCellInfo>(ClientManager.lobbyModel.playGameIds.length);
				for (var i:uint = 0; i < copyVec.length; i++)
				{
					var idx:int = ClientManager.lobbyModel.playGameIds.indexOf(copyVec[i].normalGameID);
					if (idx != -1)
					{
						addCells[idx] = copyVec[i];
						copyVec.splice(i--, 1);
					}
				}
				for (i = 0; i < addCells.length; i++)
				{
					result.push(addCells[i]);
				}
				
				return result.concat(copyVec);
				//第7个位置 添加 锁住的游戏
//				var lockedRandomCell:GameCellInfo = getRandomLockGame(copyVec);
//				if (lockedRandomCell)
//				{
//					result = result.concat(copyVec);
//					result.splice(6, 0, lockedRandomCell);
//					return result;
//				}
//				else
//				{
//					return result.concat(copyVec);
//				}
			}
			else
			{
				return gameInfos;
			}
		}
		
		private function getRandomLockGame(cells:Vector.<GameCellInfo>):GameCellInfo
		{
			for each (var info:GameCellInfo in cells)
			{
				if (info.isLocked)
				{
					cells.splice(cells.indexOf(info), 1);
					return info;
				}
			}
			return null;
		}
		
		/**
		 * 锁住的游戏 挪到最后  
		 * @param cells
		 * @return 
		 * 
		 */		
		private function normalSort(cells:Vector.<GameCellInfo>):Vector.<GameCellInfo>
		{
			var lockGames:Vector.<GameCellInfo> = new Vector.<GameCellInfo>();
			var comingGames:Vector.<GameCellInfo> = new Vector.<GameCellInfo>();
			for (var i:uint = 0 ;i < cells.length; i++)
			{
				if (cells[i].isLocked)
				{
					lockGames.push(cells[i]);
					cells.splice(i--, 1);
				}
				else if (cells[i].gameName.indexOf("comming soon") != -1)
				{
					comingGames.push(cells[i]);
					cells.splice(i--, 1);
				}
			}
			
			return cells.concat(lockGames).concat(comingGames);
		}
		
		private function fullGameCell(xml:XML):void
		{
			gameInfos = new Vector.<GameCellInfo>();
			
			for (var i:uint = 0; i < xml.children().length(); i++)
			{
				gameInfos.push(new GameCellInfo(xml.children()[i], name));
			}
		}
		
		public function getCellByGameID(gameID:String):GameCellInfo
		{
			for each (var info:GameCellInfo in gameInfos)
			{
				if (info.gameID == gameID || info.normalGameID == gameID || info.jackpotGameID == gameID)
				{
					return info.clone();
				}
			}
			return null;
		}
	}
}