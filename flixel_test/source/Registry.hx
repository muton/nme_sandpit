package ;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Registry 
{
	public static var touch_left:Bool;
	public static var touch_right:Bool;
	public static var touch_fire:Bool;
	
	public static var player:Player;
	public static var bullets:BulletManager;

	public static function init() {
		player = new Player();
		bullets = new BulletManager();
	}

}