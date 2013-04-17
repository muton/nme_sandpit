package muton.gamebase.states;

import muton.gamebase.game.Player;
import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxDisplay;

class GameState extends FlxState {
	
	private var map:FlxTilemap;
	
	private var player:Player;
	
	override public function create():Void {
		super.create();
		
		map = new FlxTilemap();
		map.loadMap( 
			Assets.getText( "assets/pathfinding/pathfinding_map.txt" ), 
			Assets.getBitmapData( "assets/tiles/autotiles_16x16.png" ),
			16, 16, FlxTilemap.ALT );
		add( map );
		
	
		player = new Player( 20, 20 );
		add( player );
	}
	
	override public function destroy():Void {
		super.destroy();
	}

	override public function update():Void {
		super.update();
	}	
}