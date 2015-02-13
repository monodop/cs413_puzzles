import flash.system.ImageDecodingPolicy;
import starling.display.Sprite;
import starling.display.Image;
import starling.textures.Texture;
import starling.core.Starling;

class BlockTile extends Tile{

	public var block:Block;
	
	public var texBlock:Texture;
	public var sprite:Image;

	
	public function new(){
		super(game);
		this.texBlock = Root.assets.getTexture("armor_block");
		this.sprite = new Image(texBlock);
		this.addChild(this.sprite);
	}
	

}