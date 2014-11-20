package com.aspectgaming.globalization.managers 
{
	import com.aspectgaming.constant.TrackPath;
	import com.aspectgaming.constant.TrackType;
	import com.aspectgaming.core.IServer;
	import com.aspectgaming.net.vo.request.DataTrackMessageC2S;
	import com.aspectgaming.net.vo.request.SendPaymentTrackMessageC2S;
	import com.aspectgaming.utils.LoggerUtil;

	/**
	 * ...
	 * @author zoe.jin
	 */
	public class TrackManager 
	{
		public static var path:String;
			
		/**
		 * Track server对象 引用
		 */
		public static var trackServer:IServer;
		
		public function TrackManager() 
		{
			
		}
		
		public static function clearPath(str:String):void
		{
			path = path.replace(str, "");
			//LoggerUtil.traceNormal("clearPath", path)
		}
		
		public static function sendTrackPath(path:String):void
		{
			LoggerUtil.traceNormal("sendTrackPath", path)
			var requestData:*;
			if (path.indexOf(TrackPath.DAILY_BONUS) != -1)
			{
				requestData = new DataTrackMessageC2S();
				requestData.msgId = "dataTrackMessage";
				requestData.playerId = Number(ClientManager.lobbyModel.facebookUser.playerID);
				requestData.trackPath = path;
				requestData.trackType = TrackType.DAILY_BONUS;
				trackServer.sendRequest("dataTrackMessage", requestData);
			}
			else if (path.indexOf(TrackPath.FTUE) != -1)
			{
				requestData = new DataTrackMessageC2S();
				requestData.msgId = "dataTrackMessage";
				requestData.playerId = Number(ClientManager.lobbyModel.facebookUser.playerID);
				requestData.trackPath = path;
				requestData.trackType = TrackType.FTUE;
				trackServer.sendRequest("dataTrackMessage", requestData);
			}
			else if (path.indexOf(TrackPath.BUY_GIFT_FOR) != -1)
			{
				requestData = new DataTrackMessageC2S();
				requestData.msgId = "dataTrackMessage";
				requestData.playerId = Number(ClientManager.lobbyModel.facebookUser.playerID);
				requestData.trackPath = path;
				requestData.trackType = TrackType.GIFT;
				trackServer.sendRequest("dataTrackMessage", requestData);
			}
			else
			{
				requestData = new SendPaymentTrackMessageC2S();
				requestData.msgId = "sendPaymentTrackMessage";
				requestData.playerId = Number(ClientManager.lobbyModel.facebookUser.playerID);
				requestData.trackPath = path;
				trackServer.sendRequest("sendPaymentTrackMessage", requestData);
			}
			
		}
		
		public static function clearPathFrom(str:String):void
		{
			if (path == null)	return;
			var idx:int = path.indexOf(str)
			if(idx!=-1)
			{
				path = path.substring(0, idx);
			}
		}
		
		public static function isLoginPromo(str:String):Boolean
		{
			if (str)
			{
				return str.indexOf(TrackPath.LOBBY_LOGIN_PROMO) != -1;
			}
			else
			{
				return false;
			}
		}
		
	}

}