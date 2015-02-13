import starling.display.Sprite;
import starling.core.Starling;
class Block extends Sprite {
	
	public var sizeX = 8;
	public var sizeY = 20;
	
	public var block:BlockTile;
	
	public var game:Game;
	
	public function new(game:Game){
		super();
		this.game = game;
		block = new BlockTile(game, 20);
		this.x = 0;
		this.y = 0;
	}
	
	public function addBlock(){
		var b = new BlockTile(this.game, 20);
		
		var stage = Starling.current.stage;
		var stageXCenter:Float = Starling.current.stage.stageWidth / 2;
		var stageYCenter:Float = Starling.current.stage.stageHeight / 2;
		var left = stageXCenter - sizeX * 16;
		var top = stageYCenter - sizeY * 16;
		b.setPos(Std.random(sizeX), 0);
		b.setPos(Std.random(sizeY), 3);
	
	}




}
