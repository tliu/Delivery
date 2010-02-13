package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Camera extends FlxSprite
	{
		
		public function Camera():void
		{
			alpha = 0;
			x = 100;
			y = 50;
		}
		
		override public function update():void {
			velocity.x = 60;
			super.update();
		}
		
	}

}