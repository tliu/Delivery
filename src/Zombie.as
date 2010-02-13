package 
{
	import org.flixel.FlxSprite;
	import org.flixel.*;
	import org.flashdevelop.utils.FlashConnect;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Zombie extends FlxSprite
	{
		[Embed("../images/zombie.png")]
		protected var ZombieGraphic:Class;
	
		[Embed("../images/ball.png")]
		protected var ballGraphic:Class;
		
		[Embed("../images/pixel.png")]
		protected var pixelGfx:Class;
		
		protected var ball:Follower;
		protected var mapTiles:FlxTilemap;
		protected var gameState:GameState;
		protected var state:String;
		protected var standCounter:int;
		protected var walkCounter:int;
		protected var ballLayer:FlxLayer;
		protected var SPEED:int = 15;
		protected var CHAIN_LENGTH:int = 15;
		
		protected var p:Player;
	
		
		public function Zombie(x:int, y:int, gameState:GameState, ballLayer:FlxLayer, mapTiles:FlxTilemap, p:Player ):void {
			super(x, y);
			loadGraphic(ZombieGraphic, true, true, 9, 16);
			//fixed = true;
			addAnimation("stand", [0], 0, false);
			addAnimation("walk", [0, 1,2], 5, true);
			this.mapTiles = mapTiles;
			this.p = p;
			this.gameState = gameState;
			this.mapTiles = mapTiles;
			this.ballLayer = ballLayer;
			speed = SPEED;
			makeBall();
			state = "STAND";
			standCounter = 0;
			walkCounter = 0;
			facing = RIGHT;
			if (Math.random() < 0.5) {
				facing = LEFT;
			}
		}
		
		protected function makeChain(offset:int) : Follower {
			var f:Follower;
			if (offset < CHAIN_LENGTH) {
				f = new Follower(x, y, pixelGfx, 1, 1, 1, 1, makeChain(offset + 1));
			} else {
				f = new Follower(x, y, pixelGfx, 1, 1, 5, -1, this);
			}
			f.color = 0x111111 * Math.ceil(Math.random() * 14);
			ballLayer.add(f);
			return f;
		}
		
		protected function makeBall():void {
			var chainEnd:Follower = makeChain(1);
			this.ball = new Follower(x, y, ballGraphic, 5, 5, 0, 4, chainEnd);			
			ballLayer.add(this.ball);
		}
		
		
		override public function kill():void 
		{
			super.kill();
		}
		
		override public function update():void {
			super.update();
			velocity.x = 0;
			//velocity.x = (Math.random() * 60) - 30;

			//velocity.x = 1;
			//FlxG.elapsed;
			

			acceleration.y = 350;
			
			var rand:int = Math.random();
			if (state == "STAND") {
				walkCounter = 0;
				standCounter++;
				play("stand");
				velocity.x = 0;
				if (rand < 0.03 && standCounter >= 100) {
					state = "WALK";
				}
			} else if (state == "WALK") {
				standCounter = 0;
				walkCounter++;
				play("walk");
				if (facing == RIGHT)
					velocity.x = SPEED;
				else if (facing == LEFT)
					velocity.x = SPEED * -1;
				if (rand < 0.01 && walkCounter >= 75) {
					state = "STAND";
				}
			} if (rand > 0.999) {
				if (facing == RIGHT)
					facing = LEFT;
				else if (facing == LEFT)
					facing = RIGHT;
			}

		}
		override public function hitWall(Contact:FlxCore = null):Boolean 
		{
			switch (facing) {
				case RIGHT:
					facing = LEFT;
					break;
				case LEFT:
					facing = RIGHT;
					break;
			}
			return super.hitWall(Contact);
		}

	}
	
}

