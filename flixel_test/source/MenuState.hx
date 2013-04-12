package;

import haxe.Json;
import nme.display.BitmapData;
import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxParticle;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxDisplay;

typedef DVRConf = {
	enemies:Array<EnemyInfo>
}

typedef EnemyInfo = {
	id:String,
	mass:Int,
	validFormations:Array<String>,
	?optionalExtra:String
}


class MenuState extends FlxState
{
	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		add( new FlxText( 0, 0, 100, "Hello World!" ) );
		
		var startBtn =  new FlxButton( 0, 0, "Start", onStartClick );
		add( startBtn );
		FlxDisplay.screenCenter( startBtn, true, true );
		
		add( new Dragon() );
		
		var emitter = new FlxEmitter( 100, 50, 30 );
		var colours:Array<Int> = [ 0xFFFFFF00, 0xFFFFFF00, 0xFFFF8000, 0xFFFF8000, 0xFF00FFFF ];
		var bmpd = new BitmapData( colours.length, 1, false );
		for ( i in 0...colours.length ) {
			bmpd.setPixel( i, 0, colours[i] );
		}
		emitter.makeParticles( bmpd, 50, 0, true );
		emitter.start( false, 1, 0.01 );
		add( emitter );
		
		testJson();
	}
	
	
	private function testJson() {
		
		var teststr:String = '
			{
				"enemies": [
					{
						"id": "boringRobot",
						"mass": 10,
						"validFormations": ["sin", "zigzag"]
					},
					{
						"id": "killerRobot",
						"mass": 40,
						"validFormations": ["sin", "circle"]
					}
				]
			}
		';
		
		var json:Dynamic = Json.parse( teststr );
		
		trace( "json: " + json );		
		
		trace( "json.enemies.boringRobot: " + json.enemies[0] );
		
		var conf:DVRConf = json;
		
		trace( "conf: " + conf );
		
		var einf:EnemyInfo = conf.enemies[0];
		trace( "einf ID: " + einf.id );
	}
	
	private function onStartClick() 
	{
		FlxG.switchState( new PlayState() );
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}	
}