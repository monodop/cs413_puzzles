import starling.display.Image;
import starling.textures.Texture;


class Grid extends Image
{
	public var orientation:Float;
	public var xcenter:Float;
	public var ycenter:Float;
	
	public function new(tex:Texture, xcenter, ycenter)
	{
		
		super(tex);
		this.xcenter = xcenter;
		this.ycenter = ycenter;
		x = xcenter;
		y = ycenter;
		
	}
}