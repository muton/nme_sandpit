package ;
import nme.Lib;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Player extends FlxSprite
{

	private var bulletDelay = 75;
	private var lastFired = 0;
	private var xSpeed:Float = 200;
	private var ySpeed:Float = 200;
	public var fireType = 1;
	
	public function new() 
	{
		//super( FlxG.width / 2, FlxG.height - 16, "assets/data/cursor.png" );
		super( FlxG.width / 2, FlxG.height - 16, null );
		
		loadGraphic( "assets/triangle_sheet.png", true, true, 100, 50, true );
		addAnimation( "basic", [0, 1, 2], 1, true );
		
		play( "basic" );
	}
	
	override public function update():Void 
	{
		super.update();
		
		velocity.x = 0;
		velocity.y = 0;
		
		var keys = FlxG.keys;
		
		var maxX = FlxG.width - width;
		
		if ( ( keys.LEFT || Registry.touch_left ) && x > 0 ) {
			moveLeft();
		}
		if ( ( keys.RIGHT || Registry.touch_right ) && x < maxX ) {
			moveRight();
		}
		if ( keys.UP && y >= 100 ) {
			velocity.y -= ySpeed;
			if ( y < 100 ) {
				y = 100;
			}
		}
		if ( keys.DOWN && y < FlxG.height - height ) {
			velocity.y += ySpeed;
		}
		if ( x < 0 ) { 
			x = 0; 
		} else if ( x > maxX ) {
			x = maxX;
		}
		
		if ( ( keys.CONTROL || Registry.touch_fire ) && Lib.getTimer() > lastFired + bulletDelay ) {
           fire(); 
		}
	}
	
	public function fire():Void 
	{
		switch (fireType)
		 {
			 case 1:
				 Registry.bullets.fire(Std.int(x + 5), Std.int(y) );
	
			 case 2:
				 Registry.bullets.fire(Std.int(x), Std.int(y));
				 Registry.bullets.fire(Std.int(x + 10), Std.int(y));
	
			 case 3:
				 Registry.bullets.fire(Std.int(x - 8), Std.int(y));
				 Registry.bullets.fire(Std.int(x), Std.int(y - 4));
				 Registry.bullets.fire(Std.int(x + 10), Std.int(y - 4));
				 Registry.bullets.fire(Std.int(x + 18), Std.int(y));
		 }
		 //Use the awsome nme get timer that will work on all supported runtimes
		 lastFired = Lib.getTimer();			
	
	}
	
	public function moveLeft():Void 
	{
		velocity.x -= xSpeed;
	}
	
	public function moveRight():Void 
	{
		velocity.x += xSpeed;
	}
	
}