import starling.display.Sprite;

class SnakeTile extends Tile {
	
	public var snake : Snake;	// The parent snake
	public var type : Int;		// The color of the snake
	var blue:Image;
	
	public function new(type, snake) {
		this.x = 0;
		this.y = 0;
		this.type = type;
		this.snake = snake;
		this.tileType = "Snake";
		
		// TODO: Load the texture into this sprite
	}
	
	public function moveDown() {
		// TODO: Move tile from (x, y) to (x, y-1)
		checkClearing();
	}
	
	public function moveLeft() {
		// TODO: Move tile from (x, y) to (x-1, y)
		checkClearing();
	}
	
	public function moveRight() {
		// TODO: Move tile from (x, y) to (x+1, y)
		checkClearing();
	}
	
	public function canMove() : Bool {
		return this.canMoveDown() ||
				this.canMoveRight() ||
				this.canMoveLeft();
	}
	
	public function canMoveDown() : Bool {
		// TODO: Check board for collision / out of bounds
		return false;
	}
	public function canMoveRight() : Bool {
		// TODO: Check board for collision / out of bounds
		return false;
	}
	public function canMoveLeft() : Bool {
		// TODO: Check board for collision / out of bounds
		return false;
	}
	
	public function move() {
		if (canMoveDown())
			moveDown();
		else if (canMoveLeft())
			moveLeft();
		else if (canMoveRight())
			moveRight();
	}
	
	public function checkClearing() {
		// TODO: Get tiles left, right, up, down from snake
		var left;
		var right;
		var down;
		var up;
		
		// TODO: Destroy snakes adjacent similarly colored snakes to this one.
	}
	
}