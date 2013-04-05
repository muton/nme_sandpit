package ;
import org.flixel.FlxSprite;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Bullet extends FlxSprite
{
	public var damage:Int = 1;
	public var speed:Int = 300;
	
	public function new() 
	{
		super( 0, 0, "assets/data/logo.png" );
		exists = false;									// exists bool tells engine whether to render or not
	}
	
	public function fire( x:Int, y:Int ) 
	{
		this.x = x;
		this.y = y;
		velocity.y = -speed;
		exists = true;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if ( exists && y < -height ) {
			exists = false;
		}
	}
}