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
		protected var state:String;
		public var alive:Boolean;
		protected var deathCounter:Number;
		protected var p:Player;
		protected var maxHealth:int;
		public var points:int = 0;
		public var colHeight:int = 0;
		protected var wallCounter:int = 0;
		
		public function Zombie(x:int, y:int, p:Player ):void {
			super(x, y);
			this.p = p;
			speed = 0;
			facing = RIGHT;
			alive = true;
			deathCounter = 0;
			if (Math.random() < 0.5) {
				facing = LEFT;
			}
		}
	
		
		public function die(): void {
			deathCounter = 0;
			alive = false;
			play("die");
			if (finished)
				play("dead");
		}
		
		public function hit():void {
			health--;
			if (health <= 0) {
				die();
			}
		}
		
		public function revive(): void {
			play("revive");
			if (finished) {
				alive = true;
				health = maxHealth;
			}
		}
		
		override public function update():void {
			super.update();
			velocity.x = 0;
			acceleration.y = 350;
			if (state == "WALL") {
				wallCounter++;
				if (wallCounter >= 100) {
					state = "WANDER";
				}
			}
			if (!alive) {
				deathCounter += FlxG.elapsed;	
				if (deathCounter > 2) {
					revive();
				}
			}

		}
		override public function hitWall(Contact:FlxCore = null):Boolean 
		{
			if (Contact.x > x) {
				facing = LEFT;
			} else {
				facing = RIGHT;
			}

			wallCounter = 0;
			state = "WALL";
			return super.hitWall(Contact);
		}

	}
	
}

