package 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Wizard extends FlxSprite
	{
		[Embed("../images/orange.png")]
		protected var OrangeGraphic:Class;
		
		[Embed("../images/purple.png")]
		protected var PurpleGraphic:Class;
		
		public function Wizard(x:int, y:int, purple:Boolean):void {
			super(x, y);
			if (purple)
				loadGraphic(PurpleGraphic, true, true, 14, 22);
			else {
				loadGraphic(OrangeGraphic, true, true, 14, 22);
				facing = LEFT;
			}
			addAnimation("walk", [0, 1, 2, 3, 4, 5, 6], 30, false);
		}
		
		override public function update():void {
			super.update();
		}
	}
	
}