import starling.display.Sprite;
import starling.core.Starling;

class Snake extends Sprite {
	
	public var tiles:Array<SnakeTile>;	// The tiles within the snake
	public var length:Int;				// The length of the snake
	public var type:Int;				// The color of the snake
	public var controllable:Bool;		// Whether the player is controlling the snake
	public var sizeX = 8;
	public var sizeY = 20;
	
	public var game:Game;
	
	public function new(game:Game, length:Int, type:Int) {
        super();
		this.game = game;
		tiles = new Array<SnakeTile>();
		this.x = 0;
		this.y = 0;
		this.length = length;
		this.type = type;
		this.controllable = false;
	}
	
	public static function generateRandom(game:Game) {
		
		var length = Std.random(5) + 4;
		var type = Std.random(1);
		
		var s = new Snake(game, length, type);
		return s;
	}
	
	// Call this whenever the snake needs to run one "step"
	public function step() {
		
		if (tiles.length == 0) {
			// Brand new snake. we need to place the snake
			var s = new SnakeTile(game, type, this, true);
			
			// Place randomly in board at top
			var stage = Starling.current.stage;
			var stageXCenter:Float = Starling.current.stage.stageWidth / 2;
			var stageYCenter:Float = Starling.current.stage.stageHeight / 2;
			var left = stageXCenter - sizeX * 16;
			//var top = stageYCenter - sizeY * 16;
			s.x = Std.random(Std.int(left+sizeX+1));
			//I don't think that we want this s.y = random(top+sizeY+1:Int):Int;
			
			this.addChild(s);
			tiles.push(s);
			
		} else if (tiles.length < length) {
			// Existing snake. Place a new body piece
			var s = new SnakeTile(game, type, this, false);
			
			// TODO: Place at top of board
			s.x = tiles[tiles.length - 1].x;
			s.y = 0;
			
			this.addChild(s);
			tiles.push(s);
		}
		
		if (tiles[0].canMove()) {
			
			var head = tiles[0];
			var tx = head.boardX;
			var ty = head.boardY;
			
			// TODO: Map to left/right controls
			var left = game.keyLeft;
			var right = game.keyRight;
			
			if (controllable) {
				var canMoveLeft = head.canMoveLeft();
				var canMoveRight = head.canMoveRight();
				var canMoveDown = head.canMoveDown();
				if (left && canMoveLeft)
					head.moveLeft();
				else if (right && canMoveRight)
					head.moveRight();
				else if (canMoveDown)
					head.moveDown();
				else
					head.move();
			} else
				head.move();
			
			for(x in 1...tiles.length) {
				var tx2 = tiles[x].boardX;
				var ty2 = tiles[x].boardY;
				// TODO: Move tiles[x] from (tx2, ty2) to (tx, ty)
					
				if (tx > tx2)
					tiles[x].moveRight(tiles[x-1]);
				else if (tx < tx2)
					tiles[x].moveLeft(tiles[x-1]);
				else
					tiles[x].moveDown(tiles[x-1]);
				//tiles[x].setPos(Std.int(tx), Std.int(ty));
				tx = tx2;
				ty = ty2;
			}
			
		}
		
	}
	
	public function canMove() : Bool {
		if (tiles.length == 0)
			return true;
		return tiles[0].canMove();
	}
	
}