package 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Splash extends FlxSprite
	{
		[Embed("../images/splash.png")]
		protected var SplashGraphic:Class;
		
		public function Splash():void {
			loadGraphic(SplashGraphic, true, true, 5, 4);
			addAnimation("splash", [0, 1, 2, 3, 4], 30, false);
		}
		
		override public function update():void {
			play("splash");
			if (finished) {
				kill();
			}
			super.update();
		}
	}
	
}