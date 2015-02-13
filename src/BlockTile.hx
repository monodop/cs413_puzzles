import flash.system.ImageDecodingPolicy;
import starling.display.Sprite;
import starling.display.Image;
import starling.textures.Texture;
import starling.core.Starling;

class BlockTile extends Tile{

	public var block:Block;
	
	public var texBlock:Texture;
	public var sprite:Image;
	
	public var duration : Float;

	
	public function new(game:Game, duration:Int){
		super(game);
		this.texBlock = Root.assets.getTexture("armor_block");
		this.sprite = new Image(texBlock);
		this.duration = duration;
		this.addChild(this.sprite);
	}
	
	public function degrade(time:Float) {
		duration -= time;
		if (duration < 0) {
			this.game.objGrid[boardX][boardY] = null;
			this.game.blocks.remove(this);
			this.removeFromParent();
			this.dispose();
		}
	}

}