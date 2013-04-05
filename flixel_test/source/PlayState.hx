package ;
import nme.display.Bitmap;
import nme.display.BitmapData;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxRect;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;

/**
 * ...
 * @author tim@muton.co.uk
 */

class PlayState extends FlxState
{
	private var debug:FlxText;
	private var controls:FlxText;
	
	private var touchUI:TouchUI;

	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		// init registry
		Registry.init();
		
		controls = new FlxText( 0, 0, 360, "Press Ctrl to Fire! ---------- Press 1 / 2 / 3 to change Fire Type!" );
		debug = new FlxText( 0, 20, 200, "" );
		
		add( Registry.bullets );
		add( Registry.player );
		
		add( debug );
		add( controls );
		
		touchUI = new TouchUI();
		add( touchUI );
	}
	
	private function onClickBtn() 
	{
		
	}
	
	override public function update():Void {
		
		//debug.text = "Bullet pool: " + Registry.bullets.countLiving() + " / " + Registry.bullets.members.length;
		var player = Registry.player;
		var keys = FlxG.keys;
		
		if ( keys.justPressed( "ONE" ) ) {
			player.fireType = 1;
		} else if ( keys.justPressed( "TWO" ) ) {
			player.fireType = 2;
		} else if ( keys.justPressed( "THREE" ) ) {
			player.fireType = 3;
		}
		
		super.update();
	}
	
}