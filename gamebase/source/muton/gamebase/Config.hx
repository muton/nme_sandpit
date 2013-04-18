package muton.gamebase;
import haxe.Json;
import nme.Assets;

/**
 * ...
 * @author tim@muton.co.uk
 */

typedef GameConf = {
	enemies:Array<EnemyInfo>,
	levels:Array<LevelInfo>,
	collectibles:Array<CollectibleInfo>
}

typedef AnimInfo = {
	frameList:Array<Int>,
	fps:Float,
	?loop:Bool
}

typedef EnemyInfo = {
	id:String,
	health:Float,
	mass:Float,
	spritePath:String,
	spriteWidth:Int,
	spriteHeight:Int,
	flyAnim:AnimInfo,
	deadFrame:Int
}

typedef LevelInfo = {
	id:String,
	mapPath:String,
	items:Array<ItemPosition>
}

typedef CollectibleInfo = {
	id:String,
	spritePath:String,
	spriteWidth:Int,
	spriteHeight:Int,
	anim:AnimInfo
}

typedef ItemPosition = {
	id:String,
	x:Int,
	y:Int
}

class Config {

	public var enemies:Hash<EnemyInfo>;
	public var levels:Array<LevelInfo>;
	public var collectibles:Hash<CollectibleInfo>;
	
	public function new( path:String ) {
		var conf:GameConf = Json.parse( Assets.getText( path ) );
		
		enemies = new Hash<EnemyInfo>(); 
		for ( ei in conf.enemies ) {
			enemies.set( ei.id, ei );
		}
		
		collectibles = new Hash<CollectibleInfo>();
		for ( ci in conf.collectibles ) {
			collectibles.set( ci.id, ci );
		}
		
		levels = conf.levels;
	}
	
}