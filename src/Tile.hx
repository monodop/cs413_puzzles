import starling.display.Sprite;

class Tile extends Sprite {
	
	public var tileType:String; // The type of tile. This can be anything that can be inserted into the board
	
	public var boardX : Int;
	public var boardY : Int;
	
	public var game : Game;
	
	public function new(game:Game) {
		tileType = "Tile";
		this.game = game;
		super();
	}
	
	public function setPos(x:Int, y:Int) {
		game.objGrid[this.boardX][this.boardY] = null;
		this.boardX = x;
		this.boardY = y;
		this.x = game.left + x * 32;
		this.y = game.top  + y * 32;
		game.objGrid[this.boardX][this.boardY] = this;
	}
}