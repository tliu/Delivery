package 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Rain extends FlxSprite
	{
		[Embed("../images/rain.png")]
		protected var RainGraphic:Class;
		protected var mapBlocks:FlxTilemap;
		protected var playerSprite:FlxSprite;
		protected var gameState:GameState;
		public function Rain(mapBlocks:FlxTilemap, playerSprite:FlxSprite, gameState:GameState):void {
			loadGraphic(RainGraphic, true, true, 1, 8);
			this.mapBlocks = mapBlocks;
			this.playerSprite = playerSprite;
			this.gameState = gameState;
			
			x = Math.random() * 125;
			y = -50;
			alpha = 0.75;
		}
		
		override public function update():void {
			mapBlocks.collide(this);
			if (playerSprite.overlaps(this)) {
				spawnSplash();
			}
			
			velocity.y = 150;
			super.update();
		}
		
		private function spawnSplash(): void {
			var s:Splash = new Splash();
			s.alpha = 0.5;
			s.x = x;
			s.y = y+4;
			gameState.add(s);
			kill();
		}
		
		override public function hitFloor(Contact:FlxCore = null):Boolean {
			spawnSplash();
			return super.hitFloor();
		}
	}
	
}

