package muton.gamebase.states;

import muton.gamebase.CaptionPlayer;
import muton.gamebase.Config;
import muton.gamebase.CutScenePlayer;
import muton.gamebase.game.Collectible;
import muton.gamebase.game.Enemy;
import muton.gamebase.game.TouchUI;
import muton.gamebase.util.Lighting;
import muton.gamebase.util.TextUtil;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.display.BlendMode;
import nme.display.GradientType;
import nme.display.Sprite;
import muton.gamebase.game.Player;
import nme.Assets;
import nme.display.Graphics;
import nme.events.Event;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxRect;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.FlxTypedGroup;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxDisplay;

class GameState extends FlxState {
	
	private var conf:Config;
	private var captions:CaptionPlayer;
	private var cutScenes:CutScenePlayer;
	
	private var bg:FlxSprite;
	private var floor:FlxTilemap;
	private var map:FlxTilemap;
	private var darkness:FlxSprite;
	private var lighting:FlxSprite;
	
	private var lightSources:Array<FlxPoint>;
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
		
		lightSources = new Array<FlxPoint>();
		lightSources.push( new FlxPoint( 20, 20 ) );
		lightSources.push( new FlxPoint( 100, 40 ) );
		
		bg = new FlxSprite();
		bg.active = false;
		add( bg );
		
		
		map = new FlxTilemap();
		map.loadMap( 
			Assets.getText( conf.levels[0].mapPath ), 
			Assets.getBitmapData( "assets/tiles/autotiles_dark_16x16.png" ),
			//Assets.getBitmapData( "assets/tiles/autotiles_16x16.png" ),
			16, 16, FlxTilemap.ALT );
		//map.follow();	// causes camera bounds to be set too
			
		floor = new FlxTilemap();
		floor.drawDebug();
		floor.widthInTiles = map.widthInTiles;
		floor.heightInTiles = map.heightInTiles;
		var blankArr = new Array<Int>();
		for ( i in 0...map.totalTiles ) { blankArr.push( 0 ); }
		floor.loadMap(
			blankArr, 
			Lighting.genLightMapTileSet( 10, 16, 16, 0.65 ),
			16, 16, FlxTilemap.OFF, 0, 1, 0 );
			
		add( floor );
		add( map );
		
		collectibles = new FlxTypedGroup<Collectible>( 20 );
		add( collectibles );
		
		enemies = new FlxTypedGroup<Enemy>( 20 );
		add( enemies );
		
		player = new Player( 20, 20 );
		add( player );
		
		overlay = new FlxTypedGroup<FlxGroup>( 10 );
		add( overlay );
		captions = new CaptionPlayer( overlay );
		cutScenes = new CutScenePlayer( overlay );
		cutScenes.addEventListener( Event.COMPLETE, onCutSceneComplete, false, 0, true );
		
#if mobile		
		add( new TouchUI( false ) );
#end		

		//darkness = new FlxSprite( 0, 0 );
		//darkness.makeGraphic( FlxG.width, FlxG.height, 0xFF000000 );
		//darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
		//darkness.blend = BlendMode.MULTIPLY;
		//darkness.active = false;
		//add( darkness );
		
		lighting = new FlxSprite( 0, 0 );
		lighting.makeGraphic( 140, 140, 0xff000000 );
		lighting.pixels.draw( Lighting.circSprite( 70 ) );
		lighting.blend = BlendMode.SCREEN;
		
		//FlxG.camera.setBounds( 0, 0, map.width, map.height, true );
		FlxG.camera.follow( player, FlxCamera.STYLE_TOPDOWN, null, 3 );
		// make the world bigger so tilemap collisions work, but camera doesn't stop at edge of play area
		FlxG.worldBounds.copyFrom( new FlxRect( -100, -100, map.width + 100, map.height + 100 ) );
		
		bg.makeGraphic( Std.int( map.width ), Std.int( map.height ), 0xFF000000 );
		//Lighting.redrawBg( bg, lightSources, map.width, map.height );
		
		for ( itm in conf.levels[0].items ) {
			var coll = collectibles.recycle( Collectible );
			coll.setup( conf.collectibles.get( itm.id ) );
			coll.x = itm.x;
			coll.y = itm.y;
		}
		
		for ( en in conf.levels[0].enemies ) {
			var enemy:Enemy = enemies.recycle( Enemy );
			enemy.setup( conf.enemies.get( en.id ) );
			enemy.x = en.x;
			enemy.y = en.y;
			enemy.followPath( Config.routeToPath( en.route ), 100, FlxObject.PATH_LOOP_BACKWARD );
		
		}
		
		//captions.play( conf.capSequences.get( "intro" ) );
		//cutScenes.play( conf.cutScenes.get( "demo" ) );
		playCutScene( "demo" );
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
		
		//var screenXY = player.getScreenXY();
		//darkness.makeGraphic( FlxG.width, FlxG.height, 0xff000000, true );
		//darkness.stamp( lighting, Std.int( screenXY.x - 45 ), Std.int( screenXY.y - 45 ) );
		//
		//floor.setTile( Std.int( player.x / 16 ), Std.int( player.y / 16 ), 9, true );
		
		updateFloorLighting();
		
		Lambda.iter( enemies.members, iter_adjustSprite );
		
		FlxG.collide( player, collectibles, collide_collectItem );
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
				floor.setTile( x, y, 
					map.ray( new FlxPoint( player.x, player.y ), new FlxPoint( x * 16 + 8, y * 16 + 8), null, 2 ) ? tileNum : 0, true );
			}
		}
		
		Lambda.iter( collectibles.members, iter_adjustSprite );
	}
	
	private function iter_adjustSprite( coll:FlxSprite ) {
		if ( coll.exists ) {
			coll.alpha = floor.getTile( Std.int( coll.x / 16 ), Std.int( coll.y / 16 ) ) / 9;
		}
	}
	
	private function collide_collectItem( objPlayer:FlxObject, objCollectible:FlxObject ) {
		objCollectible.exists = false;
		playCutScene( "demo" );
	}
	
}