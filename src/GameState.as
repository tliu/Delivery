package {
	import flash.accessibility.AccessibilityProperties;
	import org.flashdevelop.utils.FlashConnect;
	import flash.geom.Point;
	import org.flixel.*;
	public class GameState extends FlxState {
		[Embed(source = "../maps/test.txt", mimeType = "application/octet-stream")] public static var data_map:Class;
		[Embed(source = "../images/map.png")] public static var data_tiles:Class;
		[Embed(source = "../sound/thunder.mp3")] public static var ThunderMusic:Class;
		[Embed(source = "../images/bg.png")] public static var bgImage:Class;
		[Embed(source = "../images/blank.png")] public static var blankImage:Class;
		[Embed(source = "../images/house.png")] public static var HouseGraphic:Class;
		
		protected var map:FlxTilemap = new FlxTilemap();
		protected var leftWizardMap:FlxTilemap = new FlxTilemap();
		protected var rightWizardMap:FlxTilemap = new FlxTilemap();
		protected var zombieMap:FlxTilemap = new FlxTilemap();
		protected var player:Player;
		protected var cam:Camera;
		protected var bg:FlxSprite;
		
		protected var zombieLayer:FlxLayer;
		protected var zombieMapLayer:FlxLayer;
		protected var mapLayer:FlxLayer;
		protected var wizardLayer:FlxLayer;
		protected var bgLayer:FlxLayer;
		protected var platformLayer:FlxLayer;
		protected var ballLayer:FlxLayer;
		protected const dirtTiles:Array = [50, 50, 50, 50, 50, 50, 50, 33, 41, 42, 43, 44, 45, 46, 47, 48, 49, 32, 32, 32, 32, 34, 34, 34, 34, 35, 35, 35, 35, 36, 36, 36, 36, 37, 37, 37, 37, 38, 38, 38, 38, 39, 39, 39, 39, 40, 40, 40, 40];
		protected const PLATFORM_BEGIN:int = 1;
		protected const PLATFORM_END:int = 1;
		public const TILE_SIZE:int = 16;
		protected const MAX_PLATFORM_SPEED:int = 70;
		protected const MIN_PLATFORM_SPEED:int = 40;
		protected const MAX_PLAT_LENGTH:int = 10;
		protected const SCREEN_HEIGHT:int = 10;
		protected const MAX_PLAT_HEIGHT:int = SCREEN_HEIGHT - 3;
		protected const MAX_GAP_LENGTH:int = 3;
		protected const MAX_GAP_WITH_PLAT_LENGTH:int = 10;
		protected const MIN_GAP_WITH_PLAT_LENGTH:int = 6;
		protected const WIZARD_HEIGHT:int = 22;
		protected const HOUSE_HEIGHT:int = 48;
		protected const DEFAULT_PLAT_HEIGHT:int = 4;
		public const MAP_WIDTH:int = 50;
		protected const ZOMBIE_TYPES:int = 2;
		protected const ZOMBIE_KILL_POINTS:int = 50;
		protected var time:Number = 0;
		protected var scoreText:FlxText = new FlxText(0, 0, 200, "Score: ");
		
		
		
		public function GameState():void {
			FlxG.score = 0;
			
			// Layer init.
			zombieLayer = new FlxLayer();
			zombieMapLayer = new FlxLayer();
			wizardLayer = new FlxLayer();
			mapLayer = new FlxLayer();
			bgLayer = new FlxLayer();
			platformLayer = new FlxLayer();
			ballLayer = new FlxLayer();
			
			// Add layers.
			this.add(bgLayer);
			this.add(zombieMapLayer);
			this.add(mapLayer);
			this.add(wizardLayer);
			this.add(zombieLayer);
			this.add(platformLayer);
			this.add(ballLayer);
						
			// bg init.
			bg = new FlxSprite(0, 0, bgImage);
			bg.scrollFactor = new Point(0, 0);
			bgLayer.add(bg);
			
			cam = new Camera();
			this.add(cam);
			
			player  = new Player(this);
			this.add(player);
			
			var startingHeight:int = int(Math.random() * 5) + 1;
			var rightWizardMapLength:int = int(Math.random() * 10) + 10;
			var leftWizardMapLength:int = int(Math.random() * 10) + 10;
			var leftWizardGenerated:Array = generateWizardMap(startingHeight, false, leftWizardMapLength, rightWizardMapLength);
			var leftWizardMapString:String = leftWizardGenerated[0];

			leftWizardMap.loadMap(leftWizardMapString, data_tiles, 16, 16);


			var generated:Array = generateMap(MAP_WIDTH, leftWizardMapLength, rightWizardMapLength, startingHeight);
			var mapString:String = generated[0];
			var	zombies:Array = generated[1];
			var zombieWallsString:String = generated[2];
			var endingHeight:int = generated[3];
			
						
			var rightWizardGenerated:Array = generateWizardMap(endingHeight, true, rightWizardMapLength, leftWizardMapLength);
			var rightWizardMapString:String = rightWizardGenerated[0];
			
			rightWizardMap.loadMap(rightWizardMapString, data_tiles, 16, 16);
			
			
			// new data_map
			map.loadMap(mapString, data_tiles, 16, 16);
			zombieMap.loadMap(zombieWallsString, blankImage, 16, 16);
			zombieMap.collideIndex = 1;
			
			var platformLocations:Array = new Array();
			
			for (var x:int = 0; x < map.widthInTiles; x++) {
				for (var y:int = 0; y < map.heightInTiles; y++) {
					if (map.getTile(x, y) == PLATFORM_BEGIN || map.getTile(x, y) == PLATFORM_END) {
						platformLocations.push([x, y]);
					}
				}
			}
			
			var house:Boolean = true;
			for (x = 0; x < leftWizardMap.widthInTiles; x++) {
				for (y = 0; y < leftWizardMap.heightInTiles; y++) {
					
					if (leftWizardMap.getTile(x, y) == PLATFORM_BEGIN || leftWizardMap.getTile(x, y) == PLATFORM_END) {
						if (house) {
							bgLayer.add(new FlxSprite(x * TILE_SIZE, (y + 1) * TILE_SIZE - HOUSE_HEIGHT, HouseGraphic));
							house = false;
						} else { 
							wizardLayer.add(new Wizard(x * TILE_SIZE, (y + 1) * TILE_SIZE - WIZARD_HEIGHT, true));
						}
						// random grass tile
						leftWizardMap.setTile(x, y, int(Math.random() * 15) + 12);
					}
				}
			}
			
			house = true;
			for (x = 0; x < rightWizardMap.widthInTiles; x++) {
				for (y = 0; y < rightWizardMap.heightInTiles; y++) {
					
					if (rightWizardMap.getTile(x, y) == PLATFORM_BEGIN || leftWizardMap.getTile(x, y) == PLATFORM_END) {

						if (house) {
							wizardLayer.add(new Wizard(x * TILE_SIZE, (y + 1) * TILE_SIZE - WIZARD_HEIGHT, false));
							house = false;
						} else {
							bgLayer.add(new FlxSprite(x * TILE_SIZE, (y + 1) * TILE_SIZE - HOUSE_HEIGHT, HouseGraphic));
						}
						// random grass tile
						rightWizardMap.setTile(x, y, int(Math.random() * 15) + 12);
					}
				}
			}
			
			
			var offset:int = leftWizardMapLength * TILE_SIZE + 16;
			
			makePlatforms(platformLocations, 0);
			makeZombies(zombies, 0);
			
			map.collideIndex = 32;
			map.fixed = true;
			//rightWizardMap.x = offset + MAP_WIDTH * TILE_SIZE;
			//map.x = offset;
			//zombieMap.x = offset;
			
			leftWizardMap.collideIndex = 32;
			leftWizardMap.fixed = true;
			
			rightWizardMap.collideIndex = 32;
			rightWizardMap.fixed = true;
			
		
			mapLayer.add(leftWizardMap);
			mapLayer.add(rightWizardMap);
			mapLayer.add(map);
			
			
			zombieMapLayer.add(zombieMap);
	
			player.y = 75;
			player.x = 100;
			
			FlashConnect.trace("w: " + MAP_WIDTH);
			FlashConnect.trace("l: " + leftWizardMapLength);
			FlashConnect.trace("r: " + rightWizardMapLength);
			
			FlxG.followBounds( 0, 0, TILE_SIZE * (MAP_WIDTH + leftWizardMapLength + rightWizardMapLength), 160);
			
			FlxG.follow(player);
			this.add(scoreText);
			scoreText.scrollFactor = new Point(0, 0);
			
		}
		
		public function makeZombies(zombies:Array, offset:int): void {
			for (var i:int = 0; i < zombies.length; i++) {
				for (var j:int = 0; j < zombies[i].length; j++) {
					if (zombies[i][j] > 0) {
						switch(zombies[i][j]) {
							case 1:
								zombieLayer.add(new Zombie(j * 16 + offset, i * 16 - 16, this, ballLayer, map, player));
								break;
							case 2:
								zombieLayer.add(new Soldier(j * 16 + offset, i * 16 - 16, this, ballLayer, map, player));
								break;
						}
					}
				}
			}
		}
		
		public function makePlatforms(platformLocations:Array, offset:int):void {
			platformLocations.reverse();
			while(platformLocations.length >= 2) {
				var begin:Array = platformLocations.pop();
				var end:Array = platformLocations.pop();
				var minX:int = begin[0] * TILE_SIZE + offset;
				var maxX:int = end[0] * TILE_SIZE + offset;
				var y:int = begin[1] * TILE_SIZE;
				var speed:int = MIN_PLATFORM_SPEED + int(Math.random() * (MAX_PLATFORM_SPEED - MIN_PLATFORM_SPEED));
				platformLayer.add(new Platform(int(Math.random() * (maxX - minX) + minX), 
								  y, 
								  minX, 
								  maxX, 
								  speed,
								  player));
			}
		}
		
		public function generateWizardMap(height:int, flip:Boolean, length:int, rightLength:int) : Array {
			var map:Array = new Array();
			for (var i:int = 0; i < length + MAP_WIDTH; i++) {
				map.push(new Array());
			}
			
			for (i = 0; i < length + MAP_WIDTH + rightLength; i++) {
				for (var j:int = 0; j < SCREEN_HEIGHT; j++) {
					map[j][i] = 0;
				}
			}
			
			for (i = 0; i < length - 1; i++) {
				for (j = 0; j < SCREEN_HEIGHT; j++) {
					if (j == SCREEN_HEIGHT - height - 1) {
						// Environment tiles.
						//if (Math.random() < 1.0) {
						map[j][i] = int(Math.random() * 15) + 12;
						//}
					}
					if (j >= SCREEN_HEIGHT - height) {
						map[j][i] = dirtTiles[Math.round(Math.random() * (dirtTiles.length - 1))];
					}
				}
			}
			
			// House
			map[SCREEN_HEIGHT - height - 1][3] = PLATFORM_BEGIN;
			// Wizard
			map[SCREEN_HEIGHT - height - 1][5] = PLATFORM_END;
			
			if (flip) {
				for (i = 0; i < map.length; i++) {
					(map[i] as Array).reverse();
				}
			}
			
			// Map to string.
			var out:String = "";
			for (i = 0; i < 10 ; i++) {
				for (j = 0; j < length + MAP_WIDTH + rightLength; j++) {
					if (map[i][j] < 10) {
						out += "0";
					}
					
					out += map[i][j];
					if (j < length + MAP_WIDTH + rightLength -1)
						out += ",";
				}
				out += "\n";
			}
			FlashConnect.trace(out);
			return [out];
		}
		
		
		public function generateMap(length:int, leftOffset:int, rightOffset:int, startingHeight:int) : Array {
			var map:Array = new Array();
			var zombies:Array = new Array();
			var zombieWalls:Array = new Array();
			
			
			for (var i:int = 0; i < 10; i++) {
				map.push(new Array);
				zombies.push(new Array);
				zombieWalls.push(new Array);
			}
			
			// Clear the map
			for (i = 0; i < 10 ; i++) {
				for (var j:int = 0; j < length + rightOffset + leftOffset; j++) {
					map[i][j] = 0;
					zombies[i][j] = 0;
					zombieWalls[i][j] = 0;
				}
			}			
			
			var platHeight:int = startingHeight;
			var platLength:int = (Math.random() * MAX_PLAT_LENGTH) + 1;
			var oldPlatLength:int = platLength;
			var oldDelta:int;
			var gapLength:int = 0;
			var dirBias:String = "DOWN";
			zombieWalls[SCREEN_HEIGHT - platHeight - 1][leftOffset-1] = 1;
			for (i = leftOffset; i < length + leftOffset - 1; i++) {
				if (gapLength == 1) {
					zombieWalls[SCREEN_HEIGHT - platHeight - 1][i] = 1;
				}
				if (gapLength > 0) {
					gapLength--;
					continue;
				}

				if (platLength > 0) {
					for (j = 0; j < SCREEN_HEIGHT; j++) {
						if (j == SCREEN_HEIGHT - platHeight - 1) {
							// Environment tiles.
							if (Math.random() < 0.75) {
								map[j][i] = int(Math.random() * 28) + 2;
							}
						}
						if (j >= SCREEN_HEIGHT - platHeight) {
							map[j][i] = dirtTiles[Math.round(Math.random() * (dirtTiles.length - 1))];
						}
					}
					platLength--;
				} if (i == length + leftOffset - 2) {
					zombieWalls[SCREEN_HEIGHT - platHeight - 1][i + 1] = 1;
				} if (platLength == 0) {
			
					zombieWalls[SCREEN_HEIGHT - platHeight - 1][i + 1] = 1;
					var delta:int;
					if (platHeight == 1) {
						delta = 1;			
						dirBias = "UP";
					} else if (platHeight == MAX_PLAT_HEIGHT) {
						delta = -1;
						dirBias = "DOWN";
					} else {
						var deltaSet:Array;
						deltaSet = [ -1, -1, 0, 1, 1];
						if (dirBias == "DOWN") {
							deltaSet = [ -1, -1, -1, -1, 0, 1, 1];
						} else if (dirBias == "UP") {
							deltaSet = [ -1, -1, 0, 1, 1, 1, 1];
						}
						delta = deltaSet[Math.round(Math.random () * (deltaSet.length - 1))];
					}
					platHeight += delta;
					platLength = Math.random() * MAX_PLAT_LENGTH + 1;
					oldPlatLength = platLength;
					oldDelta = delta;					
					
					var gaplens:Array = [0, 1, 2, 2, 3, 3, 3];
					gapLength = gaplens[Math.round(Math.random() * (gaplens.length - 1))];
					if (Math.random() < 0.3 &&  i + platLength < length + leftOffset - 1) {
						gapLength = Math.round(Math.random() * (MAX_GAP_WITH_PLAT_LENGTH - MIN_GAP_WITH_PLAT_LENGTH)) + MIN_GAP_WITH_PLAT_LENGTH;
						if (delta <= 0) {
							map[SCREEN_HEIGHT - platHeight - 1][i + int(Math.random() * 1) + 2] = PLATFORM_BEGIN;
							map[SCREEN_HEIGHT - platHeight - 1][i + gapLength - int(Math.random() * 1) - 2] = PLATFORM_END;
						} else {
							map[SCREEN_HEIGHT - platHeight + 1][i + int(Math.random() * 1) + 2] = PLATFORM_BEGIN;
							map[SCREEN_HEIGHT - platHeight + 1][i + gapLength - int(Math.random() * 1) - 2] = PLATFORM_END;
						}
					} 
					if (delta < 1 && i + gapLength + platLength < length + leftOffset - 1) {
						zombies[SCREEN_HEIGHT - platHeight - 1][i + gapLength + int(Math.random() * platLength) + 1] = int(Math.random() * ZOMBIE_TYPES) + 1;
					}
				}
			}
			
			
			// Map to string.
			var out:String = "";
			for (i = 0; i < 10 ; i++) {
				for (j = 0; j < length + rightOffset + leftOffset; j++) {
					if (map[i][j] < 10) {
						out += "";
					}
					if (map[i][j] < 10)
						out += "0";
					out += map[i][j];
					if (j < length + rightOffset + leftOffset-1)
						out += ",";
				}
				out += "\n";
			}
			
			var zombieWallsOut:String = "";
			for (i = 0; i < 10 ; i++) {
				for (j = 0; j < length + rightOffset + leftOffset; j++) {
					if (zombieWalls[i][j] < 10) {
						zombieWallsOut += "";
					}
					zombieWallsOut += zombieWalls[i][j];
					if (j < length + rightOffset + leftOffset-1)
						zombieWallsOut += ",";
				}
				zombieWallsOut += "\n";
			}
			FlashConnect.trace(out);
			return [out, zombies, zombieWallsOut, platHeight];
			
		}
		
		override public function update():void {
			//FIXME
			if (!player.onScreen()) {
				restart();
			}
			time += FlxG.elapsed;
			if (time > 1) {
				time--;
				FlxG.score += 10;
			}
			scoreText.text = "Score: " + FlxG.score;
			//leftWizardMap.collide(player);
			FlxG.collideArray(mapLayer.children(), player);
			FlxG.collideArrays(zombieLayer.children(), zombieLayer.children());
			FlxG.collideArrays(mapLayer.children(), ballLayer.children());
			FlxG.collideArrays(mapLayer.children(), zombieLayer.children());
			FlxG.collideArrays(zombieMapLayer.children(), zombieLayer.children());
			FlxG.overlapArray(zombieLayer.children(), player, zombieCollidePlayer);
			super.update();
			
		}
		
		private function zombieCollidePlayer(zombie:FlxCore, player:FlxCore): void {
			//FIXME
			if (player.y + player.height - 2 < zombie.y) {
				zombie.kill();
				FlxG.score += ZOMBIE_KILL_POINTS;
				(player as Player).velocity.y = -100;
			} else {
				this.restart();
			}
		}
		
		public function restart(): void {
			player.y = 30;
			player.x = 50;
			cam.x = 40;
			
			//map.loadMap(generateMap(500), data_tiles, 16, 16);
		}

	}
}


