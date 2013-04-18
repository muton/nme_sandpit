package muton.gamebase.states;

import muton.gamebase.Config;
import muton.gamebase.util.Lighting;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.display.BlendMode;
import nme.display.GradientType;
import nme.display.Sprite;
import muton.gamebase.game.Player;
import nme.Assets;
import nme.display.Graphics;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxDisplay;

class GameState extends FlxState {
	
	private var conf:Config;
	
	private var bg:FlxSprite;
	private var floor:FlxTilemap;
	private var map:FlxTilemap;
	private var darkness:FlxSprite;
	private var lighting:FlxSprite;
	
	private var lightSources:Array<FlxPoint>;
	private var player:Player;
	
	private var lastFloorTileX:Int;
	private var lastFloorTileY:Int;
	
	override public function create():Void {
		super.create();

		conf = new Config( "assets/conf/config.json" );
		
		lightSources = new Array<FlxPoint>();
		lightSources.push( new FlxPoint( 20, 20 ) );
		lightSources.push( new FlxPoint( 100, 40 ) );
		
		bg = new FlxSprite();
		bg.active = false;
		add( bg );
		
		
		map = new FlxTilemap();
		map.loadMap( 
			Assets.getText( "assets/pathfinding/pathfinding_map.txt" ), 
			Assets.getBitmapData( "assets/tiles/autotiles_dark_16x16.png" ),
			16, 16, FlxTilemap.ALT );
			
		floor = new FlxTilemap();
		floor.drawDebug();
		floor.widthInTiles = map.widthInTiles;
		floor.heightInTiles = map.heightInTiles;
		var blankArr = new Array<Int>();
		for ( i in 0...map.totalTiles ) { blankArr.push( 0 ); }
		floor.loadMap(
			blankArr, 
			Lighting.genLightMapTileSet( 10, 16, 16, 0.8 ),
			16, 16, FlxTilemap.OFF, 0, 1, 0 );
			
		add( floor );
		add( map );
		
		player = new Player( 20, 20 );
		add( player );
		
		darkness = new FlxSprite( 0, 0 );
		darkness.makeGraphic( FlxG.width, FlxG.height, 0xFF000000 );
		darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
		darkness.blend = BlendMode.MULTIPLY;
		darkness.active = false;
		//add( darkness );
		
		lighting = new FlxSprite( 0, 0 );
		lighting.makeGraphic( 140, 140, 0xff000000 );
		lighting.pixels.draw( Lighting.circSprite( 70 ) );
		lighting.blend = BlendMode.SCREEN;
		
		FlxG.camera.setBounds( 0, 0, map.width, map.height, true );
		FlxG.camera.follow( player, FlxCamera.STYLE_TOPDOWN, null, 3 );
		
		bg.makeGraphic( Std.int( map.width ), Std.int( map.height ), 0xFF000000 );
		//Lighting.redrawBg( bg, lightSources, map.width, map.height );
	}
	
	
	override public function destroy():Void {
		super.destroy();
	}

	override public function update():Void {
		FlxG.collide( player, map );
		//var screenXY = player.getScreenXY();
		//darkness.makeGraphic( FlxG.width, FlxG.height, 0xff000000, true );
		//darkness.stamp( lighting, Std.int( screenXY.x - 45 ), Std.int( screenXY.y - 45 ) );
		super.update();
		//
		//floor.setTile( Std.int( player.x / 16 ), Std.int( player.y / 16 ), 9, true );
		
		updateFloorLighting();
	}	
		
	private function updateFloorLighting():Void {
		var curTileX = Std.int( player.x / 16 );
		var curTileY = Std.int( player.y / 16 );
		
		if ( lastFloorTileX == curTileX && lastFloorTileY == curTileY ) { 
			return;
		}
		
		lastFloorTileX = curTileX;
		lastFloorTileY = curTileY;
		
		for ( x in Std.int( Math.max( curTileX - 11, 0 ) )...Std.int( Math.min( curTileX + 12, floor.widthInTiles  ) ) ) {
			for ( y in Std.int( Math.max( curTileY - 11, 0 ) )...Std.int( Math.min( curTileY + 12, floor.heightInTiles ) ) ) {
				var dist = Math.sqrt( Math.pow( curTileX - x, 2 ) + Math.pow( curTileY - y, 2 ) );
				var tileNum = Std.int( Math.ceil( 9 - Math.min( 9, dist ) ) );
				//trace( Std.format( 'x:$x y:$y dist:$dist tileNum:$tileNum' ) );
				floor.setTile( x, y, 
					map.ray( new FlxPoint( player.x, player.y ), new FlxPoint( x * 16 + 8, y * 16 + 8), null, 2 ) ? tileNum : 0, true );
			}
		}
	
	}
	
	
	
}