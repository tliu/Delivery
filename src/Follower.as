package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Follower extends FlxSprite
	{
		
		public var follows:FlxSprite;
		protected var leftOffset:Number;
		protected var rightOffset:Number;
		public function Follower(x:Number, y:Number, gfx:Class, gfxWidth:Number, gfxHeight:Number, leftOffset:Number, rightOffset:Number, follows:FlxSprite) : void
		{
			super(x, y);
			loadGraphic(gfx, false, false, gfxWidth, gfxHeight);
			speed = follows.speed;
			this.follows = follows;
			this.leftOffset = leftOffset;
			this.rightOffset = rightOffset;
		}
		
		
		override public function update():void 
		{
			super.update();
			velocity.x = 0;
			switch(follows.facing) {
				case RIGHT:
					if (x < follows.x - rightOffset) {
						velocity.x = follows.speed;
						facing = RIGHT;
					}		
				case LEFT:
					if (x > follows.x + leftOffset) {
						velocity.x = follows.speed * -1;
						facing = LEFT;
					}
			}

			acceleration.y = 350;
		}
	}

}