import starling.display.Sprite;

class Snake extends Sprite {
	
	public var tiles:List<SnakeTile>;	// The tiles within the snake
	public var length:Int;				// The length of the snake
	public var type:Int;				// The color of the snake
	public var controllable:Bool;		// Whether the player is controlling the snake
	
	public function new(length, type) {
		tiles = new List<SnakeTile>();
		this.x = 0;
		this.y = 0;
		this.length = length;
		this.type = type;
		this.controllable = false;
	}
	
	// Call this whenever the snake needs to run one "step"
	public function step() {
		
		if (tiles.length == 0) {
			// Brand new snake. we need to place the snake
			var s = new SnakeTile(type, this);
			
			// TODO: Place randomly in board at top
			s.x = 0;
			s.y = 0;
			
			this.addChild(s);
			tiles.add(s);
			
		} else if (tiles.length < length) {
			// Existing snake. Place a new body piece
			var s = new SnakeTile(type, this);
			
			// TODO: Place at top of board
			s.x = tiles[tiles.length - 1].x;
			s.y = 0;
			
			this.addChild(s);
			tiles.add(s);
		}
		
		if (tiles[0].canMove()) {
			
			var head = tiles[0];
			var tx = head.x;
			var ty = head.y;
			
			// TODO: Map to left/right controls
			var left = false;
			var right = false;
			
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
			
			for (var x = 1; x < tiles.length; x++) {
				var tx2 = tiles[x].x;
				var ty2 = tiles[x].y;
				// TODO: Move tiles[x] from (tx2, ty2) to (tx, ty)
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