package 
{
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	import org.flixel.*;
	import org.flashdevelop.utils.FlashConnect;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Prisoner extends Zombie
	{
		[Embed("../images/zombie.png")]
		protected var ZombieGraphic:Class;
	
		[Embed("../images/ball.png")]
		protected var ballGraphic:Class;
		
		[Embed("../images/pixel.png")]
		protected var pixelGfx:Class;
		
		protected var ball:Follower;
		protected var standCounter:int;
		protected var walkCounter:int;
		protected var ballLayer:FlxLayer;
		protected var SPEED:int = 15;
		protected var CHAIN_LENGTH:int = 15;
		
	
		
		public function Prisoner(x:int, y:int, ballLayer:FlxLayer, p:Player ):void {
			super(x, y, p);
			loadGraphic(ZombieGraphic, true, true, 9, 16);
			//fixed = true;
			maxHealth = 2;
			health = 2;
			points = 25;
			addAnimation("stand", [0], 0, false);
			addAnimation("walk", [0, 1, 2], 5, true);
			addAnimation("stand_hurt", [3], 0, false);
			addAnimation("walk_hurt", [3, 4, 5], 5, true);
			addAnimation("head_fade", [6, 7, 8, 9, 10], 30, false);
			addAnimation("die", [11, 12, 13, 14, 15, 16, 17], 30, false);
			addAnimation("revive", [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6], 30, false);
			addAnimation("dead", [0, 1,2], 5, false);
			this.p = p;
			this.ballLayer = ballLayer;
			speed = SPEED;
			colHeight = 0;
			makeBall();
			state = "STAND";
			standCounter = 0;
			walkCounter = 0;
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
		
		override public function hit():void 
		{
			super.hit();
			if (health == 1) {
				colHeight = 8;
			}
		}
		
		override public function revive():void 
		{
			super.revive();
			colHeight = 0;
		}
		
		override public function update():void {
			super.update();
			var stand:String = "stand";
			var walk:String = "walk";
			
			
			if (health == 1) {
				stand = "stand_hurt";
				walk = "walk_hurt";
			}
			if (alive) {
				var rand:int = Math.random();
				if (state == "STAND") {
					walkCounter = 0;
					standCounter++;
					play(stand);
					velocity.x = 0;
					if (rand < 0.03 && standCounter >= 100) {
						state = "WANDER";
					}
				} else if (state == "WANDER") {
					standCounter = 0;
					walkCounter++;
					play(walk);
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

		}
	}
	
}

