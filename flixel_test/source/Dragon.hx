package ;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Dragon extends FlxSprite {

	public function new() {
		super( 10, FlxG.height / 2 );
		
		loadGraphic( "assets/dragon_sheet.png", true, false, 72, 33, true );
		addAnimation( "fly", [0, 1, 2, 1, 0], 2, true );
		
		play( "fly" );
		
	}
	
	override public function update():Void {
		super.update();
	}
	
}