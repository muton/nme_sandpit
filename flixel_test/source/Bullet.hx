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
		super( 0, 0, null );
		exists = false;									// exists bool tells engine whether to render or not
		
		loadGraphic( "assets/puff_sheet.png", true, false, 50, 50, true );
		addAnimation( "basic", [0, 1, 2, 3, 4], 7, true );
		
		play( "basic" );
		
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