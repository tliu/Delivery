package  
{
	import flash.geom.ColorTransform;
	import org.flixel.*;
	/**
	 * ...
	 * @author ...
	 */
	public class Particle extends FlxSprite
	{
		[Embed("../images/pixel.png")]
		protected var pixelGfx:Class;
		
		protected var life:Number;
		protected var fireAngle:Number;
		protected var PARTICLE_MAX_LIFE:Number = 25;
		
		public function Particle(parent:FlxSprite, fireAngle:Number, speed:Number): void
		{
			loadGraphic(pixelGfx, false, false, 1, 1);
			alpha = Math.random();
			x = parent.x;
			if (parent.facing == LEFT) {
				x += parent.width;
			}
			y = parent.y + parent.height -1;
			velocity.x = Math.cos(fireAngle) * speed;
			velocity.y = -Math.sin(fireAngle) * speed;
			life = Math.random() * PARTICLE_MAX_LIFE;
			exists = true;
		}
		
		override public function update():void {
			life--;
			if (life <= 0) {
				kill();
			}
			super.update();
		}
	}

}