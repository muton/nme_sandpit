package ;
import org.flixel.FlxSprite;

/**
 * ...
 * @author tim@muton.co.uk
 */

class AlienBlob extends FlxSprite {

	public function new() {
		super( 0, 0, null );
		exists = true;									// exists bool tells engine whether to render or not
		
		loadGraphic( "assets/alienblob_sheet.png", true, false, 30, 30 );
		addAnimation( "basic", [0, 1, 2, 1], 10, true );
		
		play( "basic" );
		
	}
	
}