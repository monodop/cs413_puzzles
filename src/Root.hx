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
	public var highScore:Int;

	public static function init() {
		
	}
	
    public function new() {
        rootSprite = this;
        super();
    }
	
    public function start(startup:Startup) {

        assets = new AssetManager();
        assets.enqueue("assets/font/font.png");
        assets.enqueue("assets/font/font.fnt");
        assets.enqueue("assets/Snaketris.mp3");
		assets.enqueue("assets/EraseSnake.mp3");
		assets.enqueue("assets/Crawl.mp3");
		assets.enqueue("assets/GameOver.mp3");
		assets.enqueue("assets/LevelUp.mp3");
		assets.enqueue("assets/SelectOption.mp3");
		assets.enqueue("assets/TouchGround.mp3");
        assets.enqueue("assets/Dead.mp3");
        assets.enqueue("assets/Snake.png");
		assets.enqueue("assets/Tile.png");
		assets.enqueue("assets/TileBottomRed.png");
		assets.enqueue("assets/TileTopRed.png");
		assets.enqueue("assets/armor_block.png");
        assets.enqueue("assets/SnaketrisSprites.png");
        assets.enqueue("assets/SnaketrisSprites.xml");
        assets.enqueue("assets/background.png");
        /*
            The sprite sheet contains the following items (png):
            Credits, Help, NewGame, Title, blue, green, purple, red, yellow
        */
		
        assets.loadQueue(function onProgress(ratio:Float) {
            haxe.Log.clear();
            if (ratio == 1) {
                haxe.Log.clear();
                startup.removeChild(startup.loadingBitmap);
                var menu = new Main(rootSprite, highScore);
                menu.start();                
            }

        });
		
    }
}
