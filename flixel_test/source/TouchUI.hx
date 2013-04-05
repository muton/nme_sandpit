package ;
import nme.display.BitmapData;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxRect;
import org.flixel.FlxSprite;

/**
 * @author tim@muton.co.uk
 */

class TouchUI extends FlxGroup
{
	private var leftBtn:FlxSprite;
	private var rightBtn:FlxSprite;
	private var fireBtn:FlxSprite;
	
	public function new() {
		super();
		
		var bmpd = new BitmapData( 50, 50, true, 0x330000ff );
		leftBtn = new FlxSprite( 10, FlxG.height - 60, bmpd );
		rightBtn = new FlxSprite( 70, leftBtn.y, bmpd );
		fireBtn = new FlxSprite( FlxG.width - 60, leftBtn.y, bmpd );
		leftBtn.active = rightBtn.active = fireBtn.active = false;	// flixel won't call update() now
		
		add( leftBtn );
		add( rightBtn );
		add( fireBtn );
	}
	
	override public function update() {
		var touches = FlxG.touchManager.touches;
		
		Registry.touch_left = Registry.touch_right = Registry.touch_fire = false;
		
		for ( t in touches ) {
			if ( !t.isActive() ) { continue; };
			if ( leftBtn.overlapsPoint( t ) ) {
				Registry.touch_left = true;
			}
			if ( rightBtn.overlapsPoint( t ) ) {
				Registry.touch_right = true;
			}
			if ( fireBtn.overlapsPoint( t ) ) {
				Registry.touch_fire = true;
			}
		}		
	}
	
}