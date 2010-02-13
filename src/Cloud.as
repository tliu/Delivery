package  
{
	import org.flixel.FlxBlock;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Cloud extends FlxSprite
	{
		[Embed("../images/clouds.png")]
		protected var CloudGraphic:Class;
		
		public function Cloud():void
		{
			x = 50;
			y = 50;
			loadGraphic(CloudGraphic, false, false, 64, 32);
			addAnimation("this", [1], 0, false);
			play("this");
		}
		
		override public function update():void 
		{
			velocity.x = 10;
			super.update();
		}
		
	}

}