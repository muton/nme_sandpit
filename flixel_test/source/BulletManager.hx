package ;
import org.flixel.FlxGroup;

/**
 * ...
 * @author tim@muton.co.uk
 */

class BulletManager extends FlxGroup
{
	public function new( poolSize:Int = 40 ) 
	{
		super( poolSize );
		
		for ( i in 0...poolSize ) {
			add( new Bullet() );
		}
	}
	
	/** Fire bullet from pool */
	public function fire( x:Int, y:Int ) 
	{
		var obj = getFirstAvailable();
		if ( null != obj ) {
			cast( obj, Bullet ).fire( x, y );
		}
	}
}