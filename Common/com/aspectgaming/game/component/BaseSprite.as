package com.aspectgaming.game.component 
{
	import com.aspectgaming.core.IDisposable;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Evan.Chen
	 */
	public class BaseSprite extends Sprite implements IDisposable 
	{
		
		public function dispose():void {
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
	}

}