import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Stage;
import starling.animation.Tween;
import starling.events.EnterFrameEvent;
import flash.geom.Rectangle;
import flash.geom.Point;

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
	var sizeX = 8;
	var sizeY = 20;
	public function onEnterFrame(event:EnterFrameEvent)
	{

	}
	public function new(root:Sprite)
	{		
        this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        super();
	}
	
	public function startGame(root:Sprite)
    {    	
		var stage = Starling.current.stage;
        var stageXCenter:Float = Starling.current.stage.stageWidth / 2;
        var stageYCenter:Float = Starling.current.stage.stageHeight / 2;

        this.rootSprite = root;
		var left = stageXCenter - sizeX * 16;
		var top = stageYCenter - sizeY * 16;
 
		for(x in 0...sizeX)
		{
			for(y in 0...sizeY)
			{
				if(y==2){
					tile_bottom_red = new Image(Root.assets.getTexture("TileBottomRed"));
					var tile_bottom_red = new Grid(Root.assets.getTexture("TileBottomRed"), left+x*32, top+y*32);
					gridList.add(tile_bottom_red);
					this.addChild(tile_bottom_red);
				}
				else if(y==3){
					tile_top_red = new Image(Root.assets.getTexture("TileTopRed"));
					var tile_top_red = new Grid(Root.assets.getTexture("TileTopRed"), left+x*32, top+y*32);
					gridList.add(tile_top_red);
					this.addChild(tile_top_red);
				}
				else{
					tile = new Image(Root.assets.getTexture("Tile"));
					var tile = new Grid(Root.assets.getTexture("Tile"), left+x*32, top+y*32);
					gridList.add(tile);
					this.addChild(tile);
					}
			}
		
		}
		rootSprite.addChild(this);


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
