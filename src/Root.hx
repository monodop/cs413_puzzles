import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Stage;
import starling.events.EnterFrameEvent;

class Root extends Sprite {

    public static var assets:AssetManager;
    public var rootSprite:Sprite;

	public static function init() {
		
	}
	
    public function new() {
        rootSprite = this;
        super();
    }
	
    public function start(startup:Startup) {

        assets = new AssetManager();
        assets.enqueue("assets/Snake.png");
        assets.enqueue("assets/SnaketrisSprites.png");
        assets.enqueue("assets/SnaketrisSprites.xml");
        /*
            The sprite sheet contains the following items (png):
            Credits, Help, NewGame, Title, blue, green, purple, red, yellow
        */
		
        assets.loadQueue(function onProgress(ratio:Float) {
            haxe.Log.clear();
            trace(ratio);
            if (ratio == 1) {
                haxe.Log.clear();
                startup.removeChild(startup.loadingBitmap);
                var menu = new Main(rootSprite);
                menu.start();                
            }

        });
		
    }
}
