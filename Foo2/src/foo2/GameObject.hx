package foo2;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Rectangle;

/**
 * ...
 * @author tim@muton.co.uk
 */

class GameObject extends Sprite {

	public static var bounds:Rectangle = new Rectangle( 0, 0, 500, 400 );
	
	private static var USE_BITMAP:Bool = true;
	
	private var velocityX:Float = 0;
	private var velocityY:Float = 0;
	
	private var bmp:Bitmap;
	
	public function new() {
		super();
		
		velocityX = Math.random() * 10 - 5;
		velocityY = Math.random() * 10 - 5;
		
		if ( USE_BITMAP ) {
			bmp = new Bitmap( Assets.getBitmapData( "img/alien.png" ) );
			addChild( bmp );
		} else {
			graphics.beginFill( 0xff0000, 0.2 + Math.random() * 0.6 );
			graphics.drawCircle( 0, 0, 5 + Math.random() * 20 );
			graphics.endFill();
		}
		
		x = bounds.left + Math.random() * bounds.width;
		y = bounds.top + Math.random() * bounds.height;
		
		cacheAsBitmap = true;
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

