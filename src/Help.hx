import starling.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.geom.Vector3D;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.Image;
import starling.text.TextField;
import starling.text.BitmapFont;
import starling.utils.Color;

class Help extends Sprite {

    public var rootSprite:Sprite;
	public var highScore:Int;
    private var transitionSpeed = 0.5;
    public var bgcolor = 255;
    public var bg:Image;
    public var help:TextField = new TextField(768, 1024, "How to play\n \n Control the falling snakes\n with the left and right arrow keys. \n When the snake is finished falling,\n it will attempt to go left then right.\n The objective is to collide\n into matching snake colors.  ", "font");

    public function new(rootSprite:Sprite, highScore:Int) {
        this.rootSprite = rootSprite;
		this.highScore = highScore;
        super();
    }

    public function start() {

        var center = new Vector3D(Starling.current.stage.stageWidth / 2, Starling.current.stage.stageHeight / 2);
        this.pivotX = center.x;
        this.pivotY = center.y;
        this.x = center.x;
        this.y = center.y;
        this.scaleX = 1;
        this.scaleY = 1;
        bg = new Image(Root.assets.getTexture("background"));


        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);

        this.addChild(bg);
        help.fontSize = 40;
        help.color = Color.GREEN;
        help.x = -1200;
        help.y = 0;
        this.addChild(help);
        rootSprite.addChild(this);
        sideTrans();


    }

    private function sideTrans(){
        var helpTween = new Tween(help, 0.37, Transitions.LINEAR);
        helpTween.animate("x", help.x + 1200);
        Starling.juggler.add(helpTween);
    }


    private function handleInput(event:KeyboardEvent) {

        if (event.keyCode == Keyboard.SPACE) {

            // Return
            var menu = new Main(rootSprite, highScore);
            menu.bgcolor = this.bgcolor;
            menu.start();
            Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
            this.removeFromParent();
            this.dispose();

        }

    }

    public static function deg2rad(deg:Int)
    {
        return deg / 180.0 * Math.PI;
    }

}
