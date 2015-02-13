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

	public var scoreField:TextField = new TextField(490, 700, "Score: 0\nMult: 1x", "Verdana");
	var gameClock:Timer;
	var ticksPerSecond = 20;
	var offTick = false;
	
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
	}
	public function updateScoreField() {
		scoreField.text = "Score: " + Std.string(this.score) +
						"\nMult: " + Std.string(this.multiplier) + "x";
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
		scoreField.y = -300;
		scoreField.fontSize = 35;
		scoreField.color = 0xFF6600;
		this.addChild(scoreField);

		objGrid = new Array<Array<Tile>>();
 
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
		gameClock.stop;
		gameClock = new Timer(Std.int(1 / ticksPerSecond * 1000));
		gameClock.run = gameTick;
	}
	
	function gameTick() {
		
		if (offTick) {
			if (keyDown && activeSnake.canMove())
				activeSnake.step(true);
		} else {

			for (i in 0...activeSnake.tiles.length) {
				var tile = activeSnake.tiles[i];
				if (tile.boardY < 3) {
					// Lose
					cleanup();
					var gameover = new GameOver(rootSprite);
					gameover.start();
					transitionOut(function() {
						this.removeFromParent();
						this.dispose();
					});
				}
			}
		}
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
						var menu = new Main(rootSprite);
						menu.start();                
						transitionOut(function() {
							this.removeFromParent();
							this.dispose();
						});
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
				
				// TODO: Reset multiplier
				this.multiplier = 1;
				updateScoreField();
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
