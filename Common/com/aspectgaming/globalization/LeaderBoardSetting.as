package com.aspectgaming.globalization 
{
	import flash.utils.Dictionary;

	/**
	 * LeaderBoard设置
	 * @author Evan.Chen
	 */
	public class LeaderBoardSetting 
	{
		public static var ONE_PAGE_SHOW:uint = 4;		//facebook 大厅暂时不用此参数 后期有时间修改
		
		public static var friendListReflushTime:uint;	//好友列表刷新 时间
		public static var tournamentRefulshTime:uint;	//tournamentRefulsh时间;
		private static var _langDic:Dictionary = new Dictionary();
		private static var _reflushSecond:uint;			//刷新时间
		
		init();

		public static function get reflushSecond():uint
		{
			return _reflushSecond;
		}
		
		public static function parseConfig(xml:XMLList):void
		{
			_reflushSecond = uint(xml.@reflushTime) == 0?30: uint(xml.@reflushTime);
			friendListReflushTime = uint(xml.@reflushFriendTime) == 0?30: uint(xml.@reflushFriendTime);
			tournamentRefulshTime = uint(xml.@touramentReflush) == 0 ? 5: uint(xml.@touramentReflush);
		}

		private static function init():void
		{
			_langDic["en_US"] = {
				rank: "RANK",
				userName: "NAME",
				level: "LEVEL",
				balance: "BALANCE",
				winnings:"WINNINGS",
				shareWord:"I'm in the Chip Leader Competition at Grand Orient Casino! Are you?",
				shareBouns:"I was a winner in the Grand Orient Casion chip leader competition! Come join the fun!"
			}
			_langDic["th_TH"] = {
				rank: "อันดับ",
				userName: "ชื่อ",
				level: "เลเวล",
				balance: "ยอดเงิน",
				winnings:"จำนวนชิพที่ชนะ",
				shareWord:"ฉันกำลังอยู่ระหว่างการแข่งขันจำนวนชิพในแกรนด์โอเรียนท์คาสิโน! แล้วคุณล่ะ?",
				shareBouns:"ฉันเคยเป็นผู้ชนะในการแข่งขันจำนวนชิพ ของเกมแกรนด์ออเรียนท์คาสิโน!มาร่วมสนุกด้วยกันสิ!"
			}
			_langDic["zh_TW"] = {
				rank: "排名",
				userName: "玩家名字",
				level: "等級",
				balance: "現金",
				winnings:"贏得",
				shareWord:"我在 Grand Orient Casino的籌碼競賽中！你呢？",
				shareBouns:"我是Grand Orient Casino中籌碼競賽的贏家！快來一起玩!"
			}
			
			_langDic["es_ES"] = {
				rank: "Puesto",
				userName: "Nombre",
				level: "Nivel",
				balance: "Saldo",
				winnings:"Ganancias",
				shareWord:"¡Estoy participando en el concurso del Líder de fichas en Grand Orient Casino! ¿Y tú?",
				shareBouns:"¡He ganado la competición del líder de fichas en Grand Orient Casino!¡Ven y pásatelo en grande!"
			}
			
			
		}
		
		public static function getTitleWord(lang:String, word:String):String
		{
			if (_langDic[lang])
			{
				return _langDic[lang][word];
			}
			return "";
		}
	}
}
