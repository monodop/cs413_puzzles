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
    var transitionSpeed = 0.5;
    public var bgcolor = 0;
    var rootSprite:Sprite;
    var snake:Image;
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
        snake = new Image(Root.assets.getTexture("Snake"));
        this.rootSprite = root;
        snake.x = (Starling.current.stage.stageWidth / 2) - (snake.texture.width / 2);
        snake.y = (Starling.current.stage.stageHeight / 2) - (snake.texture.height / 2);
        this.addChild(snake);


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
