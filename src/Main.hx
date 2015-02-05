
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.geom.Vector3D;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.Image;

class Main extends Sprite {
	
	public var rootSprite:Sprite;
	
	public var transitionSpeed = 0.5;
	
	public function new(rootSprite:Sprite) {
		this.rootSprite = rootSprite;
		super();
	}
	
	public function start() {
		
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		
		this.scaleX = 10;
		this.scaleY = 10;
		
		rootSprite.addChild(this);
		
		transitionIn();
	}
	
	private function handleInput(event:KeyboardEvent) {
		
		
		
	}
	
	private function transitionIn(?callBack:Void->Void) {
		
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("scaleX", 1);
		t.animate("scaleY", 1);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}
	
	private function transitionOut(?callBack:Void->Void) {
		
		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("scaleX", 10);
		t.animate("scaleY", 10);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}
	
}
