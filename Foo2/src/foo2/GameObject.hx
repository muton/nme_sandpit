package foo2;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Rectangle;

/**
 * ...
 * @author tim@muton.co.uk
 */

class GameObject extends Sprite {

	private static var bounds:Rectangle = new Rectangle( 0, 0, 500, 400 );
	
	private var velocityX:Float = 0;
	private var velocityY:Float = 0;
	
	public function new() {
		super();
		
		velocityX = Math.random() * 10 - 5;
		velocityY = Math.random() * 10 - 5;
		
		graphics.beginFill( 0xff0000, Math.random() );
		graphics.drawCircle( 0, 0, Math.random() * 20 );
		graphics.endFill();
		
		x = bounds.left + Math.random() * bounds.width;
		y = bounds.top = Math.random() * bounds.height;
	}
	

	
	public function tick() {
		x += velocityX;
		y += velocityY;
		
		if ( x < bounds.left ) {
			velocityX *= -1;
			x = bounds.left + ( bounds.left - x );
		} else if ( x > bounds.right ) {
			velocityX *= -1;
			x = bounds.right - ( x - bounds.right );
		}
		
		if ( y < bounds.top ) {
			velocityY *= -1;
			y = bounds.top + ( bounds.top - y );
		} else if ( y > bounds.bottom ) {
			velocityY *= -1;
			y = bounds.bottom - ( y - bounds.bottom );
		}
	}
}

