import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
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
import starling.events.KeyboardEvent;
import Std;

class Main extends Sprite {
	
	public var rootSprite:Sprite;
	private var selection:Int;
	private var buttons:Array<Image>;
	private var title:Image;
	private var snakeLogo:Image;
	private var rotateSpeed = 0.3;
	private var transitionSpeed = 0.5;
	private var tween:Tween;
	public var bgcolor = 255;
	public var bg:Image;
	public var center = new Vector3D(Starling.current.stage.stageWidth / 2.5, Starling.current.stage.stageHeight / 2.5);
	private var highScore:Int = 10000;
	public var highScore_rcrd:TextField;

	public var sound:Sound = new Sound();
	public var soundReq:URLRequest = new URLRequest("assets/Snaketris.mp3");
	public var soundChannel:SoundChannel;

	public function new(rootSprite:Sprite, highScore:Int) {
		this.rootSprite = rootSprite;
		this.highScore = highScore;
		super();
	}
	
	public function start() {
		

		this.pivotX = center.x;
		this.pivotY = center.y;
		this.x = center.x;
		this.y = center.y;
		this.scaleX = 8;
		this.scaleY = 8;

		bg = new Image(Root.assets.getTexture("background"));


		Root.assets.playSound("Snaketris", 0, 9999);
		/*
		sound.load(soundReq);
		soundChannel = sound.play();
		soundChannel.addEventListener(Event.SOUND_COMPLETE, soundLoop);
		*/
		title = new Image(Root.assets.getTexture("Title"));
		title.x = center.x - 200;
		title.y = center.y - 300;
		title.scaleX = 3;
		title.scaleY = 3;
		this.addChild(bg);
		this.addChild(title);
		/*
		var title:TextField = new TextField(490, 700, "Snaketris", "font");
		title.fontSize = 100;
		title.color = Color.WHITE;
		title.x = center.x - 150;
		title.y = -250;
		this.addChild(title);
		*/
		buttons = [new Image(Root.assets.getTexture("NewGame")), new Image(Root.assets.getTexture("Help")), new Image(Root.assets.getTexture("Credits"))];
		for (i in 0...buttons.length) {
			var button = buttons[i];
			button.x = center.x - 200;
			button.y = 300  + (i * 150);
			this.addChild(button);
		}
		
		//Enlarge the first highlighted option by default
		buttons[0].scaleX = 1.5;
		buttons[0].scaleY = 1.5;
		
		highScore_rcrd = new TextField(500, 500, "Game Over!", "font");
		highScore_rcrd.text = "High Score:\n" + Std.string(highScore);
		highScore_rcrd.x = center.x - 150;
		highScore_rcrd.y = center.y + 150;
		highScore_rcrd.fontSize = 24;
        highScore_rcrd.color = 0x66FF33;
		this.addChild(highScore_rcrd);
		
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		
		selection = 0;
		
		rootSprite.addChild(this);
		startAnim();
		transitionIn();

	}
	/*
	private function soundLoop(evt:Event) {
		soundChannel = sound.play();
		soundChannel.addEventListener(Event.SOUND_COMPLETE, soundLoop);
	}
	*/
	private function handleInput(event:KeyboardEvent){
		
		if (event.keyCode == Keyboard.SPACE){
		
			if (selection == 0) {
				// NewGame
				var game = new Game(rootSprite, highScore);
				game.bgcolor = this.bgcolor;
				game.startGame(rootSprite);
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
				Root.assets.removeSound("Snaketris");
				transitionOut(function() {
					this.removeFromParent();
					this.dispose();
				});
			}
			else if (selection == 1) {
				// Help
				var help = new Help(rootSprite, highScore);
				help.bgcolor = this.bgcolor;
				help.start();
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
				Root.assets.removeSound("Snaketris");
				helpTrans(function() {
					this.removeFromParent();
					this.dispose();
				});

			}
			else if (selection == 2) {
				// Credits
				var credits = new Credits(rootSprite, highScore);
				credits.bgcolor = this.bgcolor;
				credits.start();
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
				Root.assets.removeSound("Snaketris");
				creditTrans(function() {
					this.removeFromParent();
					this.dispose();

				});

			}
		}
		else if (tween == null || tween.isComplete)
		{	
			// Only allow moving if the current tween does not exist.
			if (event.keyCode == Keyboard.UP) {
				Root.assets.playSound("SelectOption");
				
				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("scaleX", 1.0);
				tween.animate("scaleY", 1.0);
				Starling.juggler.add(tween);

				selection = arithMod(--selection, buttons.length);

				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("scaleX", 1.5);
				tween.animate("scaleY", 1.5);
				Starling.juggler.add(tween);
			}
			else if (event.keyCode == Keyboard.DOWN) {
				Root.assets.playSound("SelectOption");

				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("scaleX", 1.0);
				tween.animate("scaleY", 1.0);
				Starling.juggler.add(tween);

				selection = arithMod(++selection, buttons.length);
				
				tween = new Tween(this.buttons[selection], rotateSpeed, Transitions.EASE_IN_OUT);
				tween.animate("scaleX", 1.5);
				tween.animate("scaleY", 1.5);
				Starling.juggler.add(tween);
			}
		}
	}
	private function startAnim(){
		toLeft();

	}

	private function toLeft(){
		var t = new Tween(title, 0.619, Transitions.EASE_IN_OUT);
		t.animate("x", title.x - 80);
		t.onComplete = toRight;
		Starling.juggler.add(t);
	}

	private function toRight(){
		var t = new Tween(title, 0.619, Transitions.EASE_IN_OUT);
		t.animate("x", title.x + 80);
		t.onComplete = toLeft;
		Starling.juggler.add(t);
	}
	private function helpTrans(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("x", 1200);
		//t.animate("scaleY", 10);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}


	private function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("x", 1000);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
	
	private function transitionIn(?callBack:Void->Void) {
		
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("scaleX", 1);
		t.animate("scaleY", 1);
		t.animate("bgcolor", 0);
		t.onUpdate = function() {
			Starling.current.stage.color = this.bgcolor | this.bgcolor << 8 | this.bgcolor << 16;
		};
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}
	
	private function creditTrans(?callBack:Void->Void) {
		
		var t = new Tween(this, 0.3, Transitions.LINEAR);
		t.animate("y", -300);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}

    public static function deg2rad(deg:Int)
    {
        return deg / 180.0 * Math.PI;
    }
	
	public static function arithMod(n:Int, d:Int) : Int {
		
		var r = n % d;
		if (r < 0)
			r += d;
		return r;
		
	}
	
}
