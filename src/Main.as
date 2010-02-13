package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Thomas Liu
	 */
	public class Main extends FlxGame
	{
		[SWF(width="960", height="480", backgroundColor="#FFFFFF")]
		
		public function Main():void 
		{
			super(320, 160, GameState, 3);
			showLogo = false;

			

			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
	
}