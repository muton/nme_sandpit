package muton.gamebase.states;

import muton.gamebase.CaptionPlayer;
import muton.gamebase.Config;
import muton.gamebase.CutScenePlayer;
import muton.gamebase.game.Collectible;
import muton.gamebase.game.Enemy;
import muton.gamebase.game.Player;
import muton.gamebase.game.TouchUI;
import muton.gamebase.util.Lighting;
import nme.Assets;
import nme.events.Event;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxRect;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTilemap;
import org.flixel.FlxTypedGroup;
import org.flixel.FlxU;

class GameState extends FlxState {
	
	private static inline var TILE_WIDTH:Int = 16;
	private static inline var TILE_HEIGHT:Int = 16;
	
	private var conf:Config;
	private var captions:CaptionPlayer;
	private var cutScenes:CutScenePlayer;
	
	private var curLevel:LevelInfo;
	
	private var floor:FlxTilemap;
	private var map:FlxTilemap;
	
	private var collectibles:FlxTypedGroup<Collectible>;
	private var enemies:FlxTypedGroup<Enemy>;
	private var player:Player;
	private var overlay:FlxTypedGroup<FlxGroup>;
	
	private var lastFloorTileX:Int;
	private var lastFloorTileY:Int;
	
	override public function create():Void {
		super.create();

		FlxG.mouse.hide();
		
		conf = new Config( "assets/conf/config.json" );
		
		floor = new FlxTilemap();
		add( floor );
		
		map = new FlxTilemap();
		add( map );
		
		collectibles = new FlxTypedGroup<Collectible>( 20 );
		add( collectibles );
		
		enemies = new FlxTypedGroup<Enemy>( 20 );
		add( enemies );
		
		player = new Player( 0, 0, playerAttack );
		add( player );
		
		overlay = new FlxTypedGroup<FlxGroup>( 10 );
		add( overlay );
		
		captions = new CaptionPlayer( overlay );
		
		cutScenes = new CutScenePlayer( overlay );
		cutScenes.addEventListener( Event.COMPLETE, onCutSceneComplete, false, 0, true );
		
#if mobile		
		add( new TouchUI( false ) );
#end		

		//FlxG.camera.setBounds( 0, 0, map.width, map.height, true );
		FlxG.camera.follow( player, FlxCamera.STYLE_TOPDOWN, null, 3 );
		
		curLevel = conf.levels[0];
		resetLevel();
	}
	
	private function resetLevel() {
		
		map.loadMap( 
			Assets.getText( curLevel.mapPath ), 
			Assets.getBitmapData( "assets/tiles/autotiles_dark_16x16.png" ),
			//Assets.getBitmapData( "assets/tiles/autotiles_16x16.png" ),
			16, 16, FlxTilemap.ALT );
		//map.follow();	// causes camera bounds to be set too
		
		floor.widthInTiles = map.widthInTiles;
		floor.heightInTiles = map.heightInTiles;
		var blankArr = new Array<Int>();
		for ( i in 0...map.totalTiles ) { blankArr.push( 0 ); }
		var floorTile:FlxSprite = new FlxSprite( 0, 0, "assets/tiles/floor_tile_16x16.png" );
		floor.loadMap(
			blankArr, 
			Lighting.genLightMapTileSet( 7, TILE_WIDTH, TILE_HEIGHT, 0.9, floorTile.pixels ),
			TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF, 0, 1, 0 );
			
			
		// make the world bigger so tilemap collisions work, but camera doesn't stop at edge of play area
		FlxG.worldBounds.copyFrom( new FlxRect( -100, -100, map.width + 100, map.height + 100 ) );
		
		Lambda.iter( collectibles.members, iter_unexistSprite );
		
		for ( itm in curLevel.items ) {
			var coll = collectibles.recycle( Collectible );
			coll.setup( conf.collectibles.get( itm.id ) );
			coll.x = itm.x;
			coll.y = itm.y;
			coll.exists = true;
			coll.alive = true;
		}
		
		Lambda.iter( enemies.members, iter_unexistSprite );
		
		for ( en in curLevel.enemies ) {
			var enemy:Enemy = enemies.recycle( Enemy );
			enemy.setup( conf.enemies.get( en.id ) );
			enemy.active = true;
			enemy.exists = true;
			enemy.x = en.x;
			enemy.y = en.y;
			enemy.followPath( Config.routeToPath( en.route ), 100, FlxObject.PATH_LOOP_BACKWARD );
		}
		
		player.x = TILE_WIDTH * curLevel.startTile[0];
		player.y = TILE_HEIGHT * curLevel.startTile[1];
	}
	
	private function playCutScene( sceneId:String ) {
		cutScenes.play( conf.cutScenes.get( sceneId ) );
		FlxG.timeScale = 0.001;
	}
	
	private function onCutSceneComplete( ev:Event ) {
		FlxG.timeScale = 1;
	}
	
	override public function destroy():Void {
		super.destroy();
	}

	override public function update():Void {
		super.update();
		
		captions.update();
		FlxG.collide( player, map );
		
		updateFloorLighting();
		
		Lambda.iter( enemies.members, iter_adjustSpriteBrightness );
		
		FlxG.collide( player, collectibles, collide_collectItem );
		FlxG.collide( player, enemies, collide_hitEnemy );
	}	
		
	private function updateFloorLighting():Void {
		var curTileX = Std.int( player.x / TILE_WIDTH );
		var curTileY = Std.int( player.y / TILE_HEIGHT );
		
		if ( lastFloorTileX == curTileX && lastFloorTileY == curTileY ) { 
			return;
		}
		
		lastFloorTileX = curTileX;
		lastFloorTileY = curTileY;
		
		for ( x in Std.int( Math.max( curTileX - 11, 0 ) )...Std.int( Math.min( curTileX + 12, floor.widthInTiles  ) ) ) {
			for ( y in Std.int( Math.max( curTileY - 11, 0 ) )...Std.int( Math.min( curTileY + 12, floor.heightInTiles ) ) ) {
				var dist = Math.sqrt( Math.pow( curTileX - x, 2 ) + Math.pow( curTileY - y, 2 ) );
				var tileNum = Std.int( Math.ceil( 6 - Math.min( 6, dist ) ) );
				floor.setTile( x, y, 
					map.ray( new FlxPoint( player.x, player.y ), 
					new FlxPoint( x * TILE_WIDTH + 8, y * TILE_HEIGHT + 8), null, 2 ) ? tileNum : 0, true );
			}
		}
		Lambda.iter( collectibles.members, iter_adjustSpriteBrightness );
	}
	
	private function playerAttack( hitPt:FlxPoint ) {
		Lambda.iter( enemies.members, function( enemy:Enemy ):Void { 
			if ( enemy.overlapsPoint( hitPt ) ) {
				enemy.kill();
			}
		} );
	}
	
	private function iter_adjustSpriteBrightness( coll:FlxSprite ) {
		if ( coll.exists ) {
			var factor:Int = Std.int( 0xff * floor.getTile( Std.int( coll.x / 16 ), Std.int( coll.y / 16 ) ) / 7 );
			coll.color = 0xff << 25 | factor << 16 | factor << 8 | factor << 0;
		}
	}
	
	private function iter_unexistSprite( spr:FlxSprite ) {
		spr.exists = false;
	}
	
	private function collide_collectItem( objPlayer:FlxObject, objCollectible:FlxObject ) {
		objCollectible.exists = false;
		playCutScene( "demo" );
	}
	
	private function collide_hitEnemy( objPlayer:FlxObject, objEnemy:FlxObject ) {
		resetLevel();
	}
	
	
}