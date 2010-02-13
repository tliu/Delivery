package 
{
	import org.flixel.FlxSprite;
	import org.flixel.*;
	import org.flashdevelop.utils.FlashConnect;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Soldier extends FlxSprite
	{
		[Embed("../images/soldier.png")]
		protected var ZombieGraphic:Class;
		
		protected var ball:Follower;
		protected var mapTiles:FlxTilemap;
		protected var gameState:GameState;
		protected var state:String;
		protected var dirCounter:Number;
		protected var ballLayer:FlxLayer;
		protected var SPEED:int = 40;
		
		protected var p:Player;
	
		
		public function Soldier(x:Number, y:Number, gameState:GameState, ballLayer:FlxLayer, mapTiles:FlxTilemap, p:Player ):void {
			super(x, y);
			loadGraphic(ZombieGraphic, true, true, 12, 17);
			//fixed = true;
			addAnimation("stand", [0], 0, false);
			addAnimation("walk", [1, 2, 3, 4, 5, 6], 15, true);
			this.mapTiles = mapTiles;
			this.p = p;
			this.gameState = gameState;
			this.mapTiles = mapTiles;
			this.ballLayer = ballLayer;
			speed = SPEED;
			state = "WANDER";
			dirCounter = 0;
		}
		
		override public function kill():void 
		{
			super.kill();
		}
		
		override public function update():void {
			super.update();
			velocity.x = 0;			

			acceleration.y = 350;
			
			var rand:Number = Math.random();
			var distToPlayer:int = p.x - x;
			
			dirCounter++;
			play("walk");
			if (facing == LEFT) {
				velocity.x = -speed;
			} else if (facing == RIGHT) {
				velocity.x = speed;
			}
			if (state == "WANDER") {
				if (dirCounter >= int(Math.random() * (200 - 180) + 180)) {
					if (facing == LEFT)
						facing = RIGHT;
					else if (facing == RIGHT)
						facing = LEFT;
					dirCounter = 0;
				}
			}
			
			if (Math.abs(distToPlayer) < 80) {
				state = "ATTACK";
			} else {
				state = "WANDER";
			}
			if (state == "ATTACK") {
				if (distToPlayer < 0) {
					facing = LEFT;
				} else {
					facing = RIGHT;
				}
			}			

		}
	}
	
}

