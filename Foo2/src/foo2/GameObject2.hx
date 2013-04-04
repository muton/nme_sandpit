package foo2;
import nme.display.Bitmap;
import nme.Assets;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.events.Event;
import nme.geom.Matrix;
import nme.geom.Rectangle;

/**
 * ...
 * @author tim@muton.co.uk
 */

class GameObject2 {

	private static var USE_BITMAP:Bool = true;
	
	public static var bounds:Rectangle = new Rectangle( 0, 0, 500, 400 );
	
	private var radius:Int;
	private var alpha:Float;
	public var x:Float = 0;
	public var y:Float = 0;
	private var velocityX:Float = 0;
	private var velocityY:Float = 0;
	
	private var bmp:BitmapData;
	
	public function new() {
		
		velocityX = Math.random() * 10 - 5;
		velocityY = Math.random() * 10 - 5;
		
		radius = Std.int( 5 + Math.random() * 20 );
		alpha = 0.2 + Math.random() * 0.6;
		x = bounds.left + Math.random() * bounds.width;
		y = bounds.top + Math.random() * bounds.height;
		
		if ( USE_BITMAP ) {
			bmp = Assets.getBitmapData( "img/alien.png" );
		}
	}
	

	public function paint( canvas:Graphics ) {
		if ( USE_BITMAP ) {
			var mtr = new Matrix();
			mtr.tx = x;
			mtr.ty = y;
			canvas.beginBitmapFill( bmp, mtr );
			canvas.drawRect( x, y, 50, 50 );
			canvas.endFill();
		} else {
			canvas.beginFill( 0xff0000, alpha );
			canvas.drawCircle( x, y, radius );
			canvas.endFill();
		}
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

