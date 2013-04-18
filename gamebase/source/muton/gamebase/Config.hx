package muton.gamebase;
import haxe.Json;
import nme.Assets;

/**
 * ...
 * @author tim@muton.co.uk
 */

typedef GameConf = {
	enemies:Array<EnemyInfo>
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

typedef CollectibleInfo = {
	id:String,
	spritePath:String,
	spriteWidth:Int,
	spriteHeight:Int,
	anim:AnimInfo
}
 
class Config {

	public var enemies:Hash<EnemyInfo>;
	
	public function new( path:String ) {
		var dvrConf:GameConf = Json.parse( Assets.getText( path ) );
		
		enemies = new Hash<EnemyInfo>(); 
		for ( ei in dvrConf.enemies ) {
			enemies.set( ei.id, ei );
		}
	}
	
}