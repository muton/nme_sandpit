package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.tweens.FlxTween;
import org.flixel.tweens.motion.LinearMotion;
import org.flixel.tweens.util.Ease;

/**
 * ...
 * @author tim@muton.co.uk
 */

class AlienBlob extends FlxSprite {

	public function new() {
		super( 0, 0, null );
		exists = true;									// exists bool tells engine whether to render or not
		
		loadGraphic( "assets/alienblob_sheet.png", true, false, 30, 30 );
		//loadRotatedGraphic( "assets/alienblob_sheet.png", 16, 3, false, false );
		addAnimation( "basic", [0, 1, 2, 1], 10, true );
		//addAnimation( "dead", [3], 1 );
		
		play( "basic" );
		
	}
	
	public function playDead() {
		loadRotatedGraphic( "assets/alienblob_sheet.png", 45, 3, false, false );
		
		var m = new LinearMotion( null, FlxTween.ONESHOT );
		m.setObject( this );
		m.setMotion( x, y, x + 30, FlxG.height - 10, 1 );
		//m.start();
		addTween( m, true );
		angularVelocity = 120;
	}
	
	override public function update():Void {
		super.update();
		
		var m = FlxG.mouse;
		
		if ( m.pressed()
			&& m.x > x && m.x < x + width
			&& m.y > y && m.y < y + height ) {
				
			playDead();
		}
	}
	
}