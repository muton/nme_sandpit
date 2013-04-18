package muton.gamebase;
import haxe.Json;
import nme.Assets;

/**
 * ...
 * @author tim@muton.co.uk
 */

typedef GameConf = {
	enemies:Array<EnemyInfo>,
	levels:Array<LevelInfo>
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
	
}
 
class Config {

	public var enemies:Hash<EnemyInfo>;
	public var levels:Array<LevelInfo>;
	
	public function new( path:String ) {
		var conf:GameConf = Json.parse( Assets.getText( path ) );
		
		enemies = new Hash<EnemyInfo>(); 
		for ( ei in conf.enemies ) {
			enemies.set( ei.id, ei );
		}
		
		levels = conf.levels;
	}
	
}