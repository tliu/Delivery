package 
{
	import org.flixel.*;
	import org.flashdevelop.utils.FlashConnect;
	
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
		
		protected var p:Player;
		
		public function Wizard(x:int, y:int, purple:Boolean, p:Player):void {
			super(x, y);
			this.p = p;
			if (purple)
				loadGraphic(PurpleGraphic, true, true, 14, 22);
			else {
				loadGraphic(OrangeGraphic, true, true, 14, 22);
				facing = LEFT;
			}
			width = 50;
			addAnimation("walk", [0, 1, 2, 3, 4, 5, 6], 30, false);
		}
		
		override public function update():void {
			if (this.overlaps(p)) {
				// Show key press
				if (!p.has_control) {
					if (FlxG.keys.UP) {
						// Up menu
					} else if (FlxG.keys.DOWN) {
						// Down menu
					} else if (FlxG.keys.X) {
						// Select
						p.has_control = true;
					}
				} else if (FlxG.keys.X) {
					p.has_control = false;
					// Show menu
				} 
			}

			super.update();
		}
	}
	
}