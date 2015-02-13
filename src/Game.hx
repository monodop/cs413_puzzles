import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Stage;
import starling.animation.Tween;
import starling.events.EnterFrameEvent;
import starling.events.KeyboardEvent;
import starling.text.TextField;
import starling.text.BitmapFont;
import starling.utils.Color;
import flash.ui.Keyboard;
import flash.geom.Rectangle;
import flash.geom.Point;
import haxe.Timer;

class Game extends Sprite
{
	var gridList:List<Grid> = new List<Grid>();
    var transitionSpeed = 0.5;
    public var bgcolor = 0;
    var rootSprite:Sprite;
    var snake:Image;
	var tile:Image;
	var tile_top_red:Image;
	var tile_bottom_red:Image;
	
	public var top : Float;
	public var left : Float;
	public var sizeX = 8;
	public var sizeY = 20;
	
	public var blocks : List<BlockTile>;
	public var objGrid : Array<Array<Tile>>;
	public var nextSnake : Snake;
	public var activeSnake : Snake;
	public var bg : Image;
	public var liveSnakes : List<Snake>;
	
	public var keyLeft = false;
	public var keyRight = false;
	public var keyDown = false;
	
	public var multiplier = 1;
	public var score = 0;
	public var highScore = 0;
	public var level = 0;

	public var scoreField:TextField = new TextField(490, 700, "Score: 0\nMult: 1x\nLevel: 0", "font");
	var gameClock:Timer;
	public var ticksPerSecond = 10;
	public var numberColors = 4;
	public var maxLength = 5;
	public var blockChance = 50; // 1 time per 50 seconds
	public var blockDuration = 20; // block lasts 20 seconds
	var offTick = false;
	
	var levelThresholds = [0, 1000, 3000, 6000, 12000, 18000, 25000, 50000];
	
	public function onEnterFrame(event:EnterFrameEvent)
	{

	}
	public function onKeyDown(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.LEFT)
			keyLeft = true;
		else if (event.keyCode == Keyboard.RIGHT)
			keyRight = true;
		else if (event.keyCode == Keyboard.DOWN)
			keyDown = true;
	}
	public function onKeyUp(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.LEFT)
			keyLeft = false;
		else if (event.keyCode == Keyboard.RIGHT)
			keyRight = false;
		else if (event.keyCode == Keyboard.DOWN)
			keyDown = false;
	}
	public function new(root:Sprite)
	{		
        super();
	}
	
	public function addScore(score:Int) {
		this.score += Std.int(score * multiplier * 100);
		this.multiplier += 1;
		updateScoreField();
		
		var level = this.level;
		for (i in level...levelThresholds.length) {
			if (this.score > levelThresholds[i])
				level = i;
		}
		if (level != this.level)
			setLevel(level);
	}
	public function setLevel(level:Int) {
		this.level = level;
		switch(level) {
			case 1:
				numberColors = 5;
				maxLength = 6;
				blockChance = 45;
			case 2:
				changeTickRate(12);
				blockChance = 40;
			case 3:
				numberColors = 6;
				changeTickRate(15);
			case 4:
				maxLength = 7;
				changeTickRate(20);
				blockChance = 30;
			case 5:
				numberColors = 7;
				changeTickRate(25);
				blockDuration = 30;
			case 6:
				numberColors = 8;
				maxLength = 8;
				blockChance = 25;
			case 7:
				changeTickRate(30);
				blockDuration = 35;
		}
		Root.assets.playSound("LevelUp");
	}
	public function updateScoreField() {
		scoreField.text = "Score: " + Std.string(this.score) +
						"\nMult: " + Std.string(this.multiplier) + "x" +
						"\nLevel: " + Std.string(this.level);
	}
	
	public function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        this.removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		gameClock.stop();
	}
	
	public function startGame(root:Sprite)
    {    	
		var stage = Starling.current.stage;
        var stageXCenter:Float = Starling.current.stage.stageWidth / 2;
        var stageYCenter:Float = Starling.current.stage.stageHeight / 2;

		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		bg = new Image(Root.assets.getTexture("background"));
		this.addChild(bg);
        this.rootSprite = root;
		left = stageXCenter - sizeX * 16;
		top = stageYCenter - sizeY * 16;
		scoreField.x = -100;
		scoreField.y = -200;
		scoreField.fontSize = 35;
		scoreField.color = 0xFF6600;
		this.addChild(scoreField);

		objGrid = new Array<Array<Tile>>();
		blocks = new List<BlockTile>();
 
		for(x in 0...sizeX)
		{
			var col = new Array<Tile>();
			for(y in 0...sizeY)
			{
				if(y==2){
					var tile_bottom_red = new Grid(Root.assets.getTexture("TileBottomRed"), left + x * 32, top + y * 32);
					gridList.add(tile_bottom_red);
					this.addChild(tile_bottom_red);
				}
				else if(y==3){
					var tile_top_red = new Grid(Root.assets.getTexture("TileTopRed"), left+x*32, top+y*32);
					gridList.add(tile_top_red);
					this.addChild(tile_top_red);
				}
				else{
					var tile = new Grid(Root.assets.getTexture("Tile"), left+x*32, top+y*32);
					gridList.add(tile);
					this.addChild(tile);
				}
				col.push(null);
			}
			objGrid.push(col);
		
		}
		rootSprite.addChild(this);

		nextSnake = Snake.generateRandom(this);
		activeSnake = Snake.generateRandom(this);
		liveSnakes = new List<Snake>();
		
		addChild(activeSnake);
		
		gameClock = new Timer(Std.int(1 / ticksPerSecond * 1000));
		gameClock.run = gameTick;

    }
	
	function changeTickRate(ticksPerSecond) {
		this.ticksPerSecond = ticksPerSecond;
		gameClock.stop();
		gameClock = new Timer(Std.int(1 / ticksPerSecond * 1000));
		gameClock.run = gameTick;
	}
	
	function gameTick() {
		
		if (offTick) {
			if (keyDown && activeSnake.canMove())
				activeSnake.step(true);
		} else {

			var makeNewSnake = true;
			if (activeSnake.canMove()) {
				activeSnake.step();
				makeNewSnake = false;
			} else {
				for (i in 0...activeSnake.tiles.length) {
					var tile = activeSnake.tiles[i];
					if (tile.boardY < 3) {
						// Lose
						cleanup();

						var gameover = new GameOver(rootSprite, this.score);
						
						gameover.start();
						transitionOut(function() {
							this.removeFromParent();
							this.dispose();
						});
						
						return;
					}
				}
			}
			
			for (snake in liveSnakes) {
				if (snake.canMove()) {
					snake.step();
					makeNewSnake = false;
				}
			}
			
			if(makeNewSnake){
				activeSnake.controllable = false;
				liveSnakes.add(activeSnake);
				activeSnake = nextSnake;
				this.addChild(activeSnake);
				nextSnake = Snake.generateRandom(this);
				
				this.multiplier = 1;
				updateScoreField();
			}
		}
			
		// Place blocks
		var chance = Std.random(ticksPerSecond * blockChance);
		if (chance == 1) {
			// Create new block
			// Determine location
			
			var xPos = 0;
			var yPos = 0;
			var valid = false;
			var attempts = 1000; // prevent infinite loop?
			while (attempts > 0) {
				xPos = Std.random(sizeX);
				yPos = Std.random(sizeY - 3) + 3;
				
				if (objGrid[xPos][yPos] == null) {
					valid = true;
					break;
				}
				
				attempts--;
			}
			
			if (valid) {
				var block = new BlockTile(this, blockDuration);
				block.setPos(xPos, yPos);
				this.addChild(block);
				blocks.add(block);
			}
		}
		
		// Degrade blocks
		for (block in blocks) {
			block.degrade(1 / ticksPerSecond);
		}
		
		offTick = !offTick;
	}
	
	private function transitionIn(?callBack:Void->Void) {
		
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("scaleX", 1);
		t.animate("scaleY", 1);
		t.animate("bgcolor", 255);
		t.onUpdate = function() {
			Starling.current.stage.color = this.bgcolor | this.bgcolor << 8 | this.bgcolor << 16;
		};
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}
	
	private function transitionOut(?callBack:Void->Void) {
		
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("scaleX", 8);
		t.animate("scaleY", 8);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}

}
