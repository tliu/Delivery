package
{
	import flash.geom.Point;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Platform extends FlxSprite 
	{
		[Embed("../images/platform.png")]
		protected var platformGraphic:Class;
		
		protected var player:Player;
		protected var maxX:Number;
		protected var minX:Number;
		protected var levelBlocks:FlxTilemap;
		
		public function Platform(x:Number, y:Number, minX:Number, maxX:Number, speedX:Number, player:Player):void {
			fixed = true;
			loadGraphic(platformGraphic, false, false, 32, 12);
			specificFrame(Math.random() * 4);
			offset = offset = new Point(0, 2);
			height = 8;
			
			
			facing = LEFT;
			if (Math.random() < 0.5) {
				facing = RIGHT;
			}
			this.x = x;
			this.y = y;
			this.minX = minX;
			this.maxX = maxX;
			this.player = player;
			speed = speedX;
			velocity.x = speedX;
			if (facing == LEFT) {
				velocity.x *= -1;
			}
			
		}
		
		override public function update():void {
			super.update();
			
			if (x < minX && facing == LEFT) {
				velocity.x *= -1;
				facing = RIGHT;
			} else if (x > maxX && facing == RIGHT) {
				velocity.x *= -1;
				facing = LEFT;
			}
			collide(player);
		}
	}
	
}
