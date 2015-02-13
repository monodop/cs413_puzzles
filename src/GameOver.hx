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
import flash.media.SoundChannel;
import flash.media.Sound;
import flash.media.SoundTransform;

class GameOver extends Sprite {

    public var rootSprite:Sprite;
    public var bg:Image;
    private var transitionSpeed = 1.0;
    public var bgcolor = 255;
    public var gameover:TextField = new TextField(400, 900, "Game Over!", "font");
    public function new(rootSprite:Sprite) {
        this.rootSprite = rootSprite;
        super();
    }

    public function start() {
        var st:SoundTransform = new SoundTransform(0.25, 0);
        var sc:SoundChannel = Root.assets.playSound("Dead");
        sc.soundTransform = st;
        var center = new Vector3D(Starling.current.stage.stageWidth / 2, Starling.current.stage.stageHeight / 2);
        this.pivotX = center.x;
        this.pivotY = center.y;
        this.x = center.x;
        this.y = center.y;
        this.scaleX = 1;
        this.scaleY = 1;
        bg = new Image(Root.assets.getTexture("background"));
        this.addChild(bg);
        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);

        gameover.fontSize = 75;
        gameover.color = 0x66FF33;
        gameover.x = center.x - 200;
        gameover.y = 0;
        this.addChild(gameover);
        rootSprite.addChild(this);
        pulse();

    }

    private function handleInput(event:KeyboardEvent) {

        if (event.keyCode == Keyboard.SPACE) {

// Return
            var menu = new Main(rootSprite);
            menu.bgcolor = this.bgcolor;
            menu.start();
            Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
            transitionSpeed = 0.5;
            transitionOut(function() {
                this.removeFromParent();
                this.dispose();
            });
        };
    }
    private function pulse(){
        var t = new Tween(gameover, 0.15, Transitions.LINEAR);
        t.animate("scaleX", 1.01);
        t.animate("scaleY", 1.01);
        t.onComplete = pulse2;
        Starling.juggler.add(t);
    }
    private function pulse2(){
        var t = new Tween(gameover, 0.15, Transitions.LINEAR);
        t.animate("scaleX", 1);
        t.animate("scaleY", 1);
        t.onComplete = pulse;
        Starling.juggler.add(t);
    }

    private function transitionInLose(?callBack:Void->Void) {


    }

    private function transitionOut(?callBack:Void->Void) {


    }
}
