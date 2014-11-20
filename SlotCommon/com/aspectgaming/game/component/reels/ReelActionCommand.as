package com.aspectgaming.game.component.reels
{
	import com.aspectgaming.animation.event.AnimationEvent;
	import com.aspectgaming.animation.iface.IAnimation;
	import com.aspectgaming.animation.sheet.SheetPlayer;
	import com.aspectgaming.game.config.GameSetting;
	import com.aspectgaming.game.constant.ReelActionDefined;
	import com.aspectgaming.game.constant.asset.AssetRefDefined;
	import com.aspectgaming.game.constant.asset.SlotSoundDefined;
	import com.aspectgaming.game.data.GameAssetLibrary;
	import com.aspectgaming.game.data.reel.ReelAction;
	import com.aspectgaming.game.event.SlotEvent;
	import com.aspectgaming.globalization.managers.GameLayerManager;
	import com.aspectgaming.globalization.sound.SoundManager;
	import com.aspectgaming.utils.DisplayUtil;
	import com.aspectgaming.utils.PointUtil;
	import com.aspectgaming.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**
	 * 轮子特殊命令 处理
	 * @author Nightmare
	 * 
	 */	
	internal class ReelActionCommand
	{
		private static var _sheetList:Vector.<IAnimation> = new Vector.<IAnimation>();
		
		public static function execute(action:ReelAction):void
		{
			switch (action.action)
			{
				case ReelActionDefined.CHANGE_SPEED:
					if (action.actionMsg)
					{
						GameLayerManager.gameRoot.dispatch(new SlotEvent(SlotEvent.SHOW_MESSAGE, null, action.actionMsg));
					}
					action.reel.speedInfo = GameSetting.getSpeedInfo(action.actionParm);
					SoundManager.playSound(SlotSoundDefined.REEL_SCATTOR + (action.reelIndex - 2));
					break;
			}
		}
		
		public static function handlerClick(o:DisplayObject):void
		{
			if (o && !StringUtil.isEmptyString(o.name))
			{
				var holeName:String = GameAssetLibrary.symbolLibrary.getSymbloName(o.name);
				var aniObj:MovieClip = GameAssetLibrary.getMovieClip(AssetRefDefined.CLICK_ANI +  holeName);
				if (aniObj)
				{
					var sheetPlayer:SheetPlayer = new SheetPlayer(aniObj);
					sheetPlayer.addEventListener(AnimationEvent.ANIMATION_COMPLETE, onComplete);
					_sheetList.push(sheetPlayer);
					var pt:Point = PointUtil.localToGoble(o, GameLayerManager.rootPoint.x, GameLayerManager.rootPoint.y);
					sheetPlayer.x = pt.x;
					sheetPlayer.y = pt.y;
					GameLayerManager.topLayer.addChild(sheetPlayer);
					sheetPlayer.start();
				}
			}
		}
		
		private static function onComplete(e:AnimationEvent):void
		{
			var sheet:SheetPlayer = e.currentTarget as SheetPlayer;
			sheet.removeEventListener(AnimationEvent.ANIMATION_COMPLETE, onComplete);
			DisplayUtil.removeFromParent(sheet);
			sheet.dispose();
			_sheetList.splice(_sheetList.indexOf(sheet), 1);
		}
		
		public static function clearAllClickAnimation():void
		{
			for each (var s:IAnimation in _sheetList)
			{
				s.removeEventListener(AnimationEvent.ANIMATION_COMPLETE, onComplete);
				s.dispose();
			}
			_sheetList.length = 0;
		}
	}
}