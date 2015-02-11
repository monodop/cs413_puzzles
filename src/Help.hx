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
    private var transitionSpeed = 0.5;
    public var bgcolor = 255;
    public var help:TextField = new TextField(1024, 768, "How to play\n Control the falling snakes with the left and right arrow keys, when the snake is finished falling it will attempt to go left then right.  The objective is to collide into matching snake colors.  ", "font");

    public function new(rootSprite:Sprite) {
        this.rootSprite = rootSprite;
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

        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);

        help.fontSize = 40;
        help.color = Color.GREEN;
        help.x = 0;
        help.y = 0;
        this.addChild(help);
        rootSprite.addChild(this);
    }


    private function handleInput(event:KeyboardEvent) {

        if (event.keyCode == Keyboard.SPACE) {

            // Return
            var menu = new Main(rootSprite);
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