import flash.system.ImageDecodingPolicy;
import starling.display.Sprite;
import starling.display.Image;
import starling.textures.Texture;
import starling.core.Starling;

class SnakeTile extends Tile {
	
	public var snake : Snake;	// The parent snake
	public var type : Int;		// The color of the snake
	var blue:Image;
	
	public var texHead : Texture;
	public var texStraight : Texture;
	public var texCorner : Texture;
	
	public var isHead = false;
	public var direction : Direction;
	public var sprite : Image;
	
	public function new(game:Game, type:Int, snake:Snake, isHead:Bool) {
        super(game);
		this.x = 0;
		this.y = 0;
		this.type = type;
		this.snake = snake;
		this.tileType = "Snake";
		this.isHead = isHead;
		
		this.texHead = Root.assets.getTexture("SnakeheadBlue");
		this.texStraight = Root.assets.getTexture("SnakeBodyBlue");
		//this.texCorner = Root.assets.getTexture("Corner_Tile_Blue");
		
		this.direction = Direction.DOWN;
		
		if (isHead)
			this.sprite = new Image(texHead);
		else
			this.sprite = new Image(texStraight);
		this.addChild(this.sprite);
		
		// TODO: Load the texture into this sprite
	}
	
	public function moveDown() {
		// TODO: Move tile from (x, y) to (x, y-1)
		setPos(boardX, boardY - 1);
		checkClearing();
	}
	
	public function moveLeft() {
		// TODO: Move tile from (x, y) to (x-1, y)
		setPos(boardX - 1, boardY);
		checkClearing();
	}
	
	public function moveRight() {
		// TODO: Move tile from (x, y) to (x+1, y)
		setPos(boardX + 1, boardY);
		checkClearing();
	}
	
	public function canMove() : Bool {
		return this.canMoveDown() ||
				this.canMoveRight() ||
				this.canMoveLeft();
	}
	
	public function canMoveDown() : Bool {
		// TODO: Check board for collision / out of bounds
		return true;
	}
	public function canMoveRight() : Bool {
		// TODO: Check board for collision / out of bounds
		return true;
	}
	public function canMoveLeft() : Bool {
		// TODO: Check board for collision / out of bounds
		return true;
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

enum Direction {
	DOWN;
	LEFT;
	RIGHT;
}