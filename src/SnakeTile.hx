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
		
		var colorLookup = ["Blue", "Green", "Orange", "Purple", "Red", "Yellow"];
		var color = colorLookup[type];
		
		this.texHead = Root.assets.getTexture("Snakehead" + color);
		this.texStraight = Root.assets.getTexture("SnakeBody" + color);
		this.texCorner = Root.assets.getTexture("Corner_Tile_" + color);
		
		this.direction = Direction.DOWN;
		
		if (isHead)
			this.sprite = new Image(texHead);
		else
			this.sprite = new Image(texStraight);
		this.sprite.pivotX = 16;
		this.sprite.pivotY = 16;
		this.sprite.x = 16;
		this.sprite.y = 16;
		this.addChild(this.sprite);
	}
	
	public function moveDown(?next:SnakeTile) {
		
		setPos(boardX, boardY + 1);
		checkClearing();
		
		direction = Direction.DOWN;
		
		if (!isHead) {
			if (direction == next.direction) {
				sprite.texture = texStraight;
				sprite.rotation = 0;
			} else {
				sprite.texture = texCorner;
				switch(next.direction) {
					case Direction.LEFT:
						sprite.rotation = 3 * Math.PI / 2;
					default:
						sprite.rotation = 0;
				}
			}
		} else
			sprite.rotation = getRotation(direction);
	}
	
	public function moveLeft(?next:SnakeTile) {
		
		setPos(boardX - 1, boardY);
		checkClearing();
		
		direction = Direction.LEFT;
		
		if (!isHead) {
			if (direction == next.direction) {
				sprite.texture = texStraight;
				sprite.rotation = Math.PI / 2;
			} else {
				sprite.texture = texCorner;
				switch(next.direction) {
					case Direction.DOWN:
						sprite.rotation = Math.PI / 2;
					default:
						sprite.rotation = 0;
				}
			}
		} else
			sprite.rotation = getRotation(direction);
	}
	
	public function moveRight(?next:SnakeTile) {
		setPos(boardX + 1, boardY);
		checkClearing();
		
		direction = Direction.RIGHT;
		
		if (!isHead) {
			if (direction == next.direction) {
				sprite.texture = texStraight;
				sprite.rotation = Math.PI / 2;
			} else {
				sprite.texture = texCorner;
				switch(next.direction) {
					case Direction.DOWN:
						sprite.rotation = Math.PI;
					default:
						sprite.rotation = 0;
				}
			}
		} else
			sprite.rotation = getRotation(direction);
	}
	
	public function canMove() : Bool {
		return this.canMoveDown() ||
				this.canMoveRight() ||
				this.canMoveLeft();
	}
	
	public function canMoveDown() : Bool {
		if (boardY >= game.sizeY - 1)
			return false;
		if (game.objGrid[boardX][boardY + 1] != null)
			return false;
		return true;
	}
	public function canMoveRight() : Bool {
		if (boardX >= game.sizeX - 1)
			return false;
		if (game.objGrid[boardX + 1][boardY] != null)
			return false;
		return true;
	}
	public function canMoveLeft() : Bool {
		if (boardX <= 0)
			return false;
		if (game.objGrid[boardX - 1][boardY] != null)
			return false;
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
		
		var left:Tile = null;
		var right:Tile = null;
		var down:Tile = null;
		var up:Tile = null;
		
		if(boardX > 0)
			left = game.objGrid[boardX - 1][boardY];
		if (boardX < game.sizeX - 1)
			right = game.objGrid[boardX + 1][boardY];
			
		if(boardY > 0)
			up = game.objGrid[boardX][boardY - 1];
		if (boardY < game.sizeY - 1)
			down = game.objGrid[boardX][boardY + 1];
		
		if (left != null && Std.is(left, SnakeTile)) {
			var s : SnakeTile = cast left;
			if (s.snake != this.snake && s.snake.type == this.type)
				s.snake.clear();
		}
		if (right != null && Std.is(right, SnakeTile)) {
			var s : SnakeTile = cast right;
			if (s.snake != this.snake && s.snake.type == this.type)
				s.snake.clear();
		}
		if (down != null && Std.is(down, SnakeTile)) {
			var s : SnakeTile = cast down;
			if (s.snake != this.snake && s.snake.type == this.type)
				s.snake.clear();
		}
		if (up != null && Std.is(up, SnakeTile)) {
			var s : SnakeTile = cast up;
			if (s.snake != this.snake && s.snake.type == this.type)
				s.snake.clear();
		}
			
		
		// TODO: Destroy snakes adjacent similarly colored snakes to this one.
	}
	
	private function getRotation(dir:Direction) : Float {
		switch(dir) {
			case Direction.DOWN:
				return 0;
			case Direction.RIGHT:
				return 3 * Math.PI / 2;
			case Direction.LEFT:
				return Math.PI / 2;
		}
		return 0;
	}
	
}

enum Direction {
	RIGHT;
	DOWN;
	LEFT;
}