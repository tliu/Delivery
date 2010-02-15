package 
{
	import flash.geom.Point;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Player extends FlxSprite 
	{
		[Embed("../images/player.png")]
		protected var PlayerGraphic:Class;
		
		[Embed(source = "../sound/step.mp3")] 
		public static var stepSound:Class;
		
		
		protected var MAX_PARTICLES:int = 2;
		protected var MAX_PARTICLE_SPEED:Number = 50;
		protected var gameState:GameState;
		protected var upsideDown:Boolean = false;
		protected var platVelocity:int;
		protected var onPlatform:Boolean = false;
		public var MAX_JUMPS:int = 1;
		public var SPEED:int = 80;
		public var JUMP_HEIGHT:int = 130;
		protected var jumps:int = MAX_JUMPS;
		
		public function Player(gameState:GameState):void {
			loadGraphic(PlayerGraphic, true, true, 8, 17);
			addAnimation("normal", [0], 1, false);
			addAnimation("run", [1, 2, 3, 4, 5, 6], 10, true);
			addAnimation("jump", [7], 10, false);
			speed = SPEED;
			this.gameState = gameState;
		}
		
		override public function update():void {
			velocity.x = 0;
			
			if (onPlatform) {
				velocity.x = platVelocity;
			}
			
			if (FlxG.keys.RIGHT) {
				facing = RIGHT;
				velocity.x = SPEED;
				if (!velocity.y) {
					play("run");
				}
			}
			
			if (FlxG.keys.LEFT) {
				facing = LEFT;
				velocity.x = SPEED * -1;
				if (!velocity.y)
					play("run");
			}
			
			if (FlxG.keys.justReleased("RIGHT") || FlxG.keys.justReleased("LEFT")) {
				play("normal");
			}
			
			if (jumps == MAX_JUMPS && velocity.y && MAX_JUMPS > 1) {
				jumps--;
			}
			
			if (FlxG.keys.justPressed("X") && jumps > 0) {
				if ((jumps == MAX_JUMPS && !velocity.y) || (jumps < MAX_JUMPS)) {
					play("jump");
					onPlatform = false;
					velocity.y = JUMP_HEIGHT * -1;
					jumps--;
				}
				
			}
			
			acceleration.y = 350;
			super.update();
		}
		
		override public function hitFloor(Contact:FlxCore = null):Boolean {			
			jumps = MAX_JUMPS;
			if (velocity.x == 0)
				play("normal");
			if (Contact is Platform) {
				onPlatform = true;
				var plat:Platform = Contact as Platform;
				platVelocity = plat.velocity.x;
			} else {
				onPlatform = false;
			}
		
			return super.hitFloor();
		}
	}
	
}


