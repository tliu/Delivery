package 
{
	import org.flixel.FlxSprite;
	import org.flixel.*;
	import org.flashdevelop.utils.FlashConnect;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Soldier extends Zombie
	{
		[Embed("../images/soldier.png")]
		protected var ZombieGraphic:Class;
		
		protected var dirCounter:Number;
		protected var SPEED:int = 40;
	
		
		public function Soldier(x:Number, y:Number, p:Player ):void {
			super(x, y, p);
			loadGraphic(ZombieGraphic, true, true, 12, 17);
			//fixed = true;
			maxHealth = 1;
			points = 50;
			colHeight = 0;
			health = 1;
			addAnimation("stand", [0], 0, false);
			addAnimation("walk", [1, 2, 3, 4, 5, 6], 15, true);
			addAnimation("die", [7, 8, 9, 10, 11, 12, 13, 14], 30, false);
			addAnimation("revive", [14, 13, 12, 11, 10, 9, 8, 7], 30, false);
			addAnimation("dead", [14], 15, false);
			this.p = p;
			speed = SPEED;
			state = "WANDER";
			dirCounter = 0;
		}
		
		//override public function die():void 
		//{
		//	super.die();
		//}
		
		override public function update():void {
			super.update();
			if (alive) {
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
				if (state != "WALL") {
					if (Math.abs(distToPlayer) < 80) {
						state = "ATTACK";
					} else {
						state = "WANDER";
					}
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
	
}

