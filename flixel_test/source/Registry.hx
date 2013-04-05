package ;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Registry 
{
	
	public static var player:Player;
	public static var bullets:BulletManager;

	public static function init() {
		player = new Player();
		bullets = new BulletManager();
	}

}