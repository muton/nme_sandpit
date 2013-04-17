package muton.gamebase.util;
import nme.display.BitmapData;
import nme.display.BlendMode;
import nme.display.GradientType;
import nme.display.Sprite;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Lighting {

	private static var bgFill:BitmapData;

	public static inline function redrawBg( bg:FlxSprite, lightSources:Array<FlxPoint>, width:Float, height:Float ) {
		var flxScale = FlxG.camera.zoom;
		var radius:Float = 60 * flxScale;
		
		if ( null == bgFill ) {
			bgFill = new BitmapData( 4, 4, false, 0xFF100500 );
			bgFill.setPixel( 0, 0, 0xFF000000 );
			bgFill.setPixel( 1, 0, 0xFF000000 );
			bgFill.setPixel( 2, 0, 0xFF000000 );
			bgFill.setPixel( 3, 0, 0xFF000000 );
			bgFill.setPixel( 0, 1, 0xFF000000 );
			bgFill.setPixel( 0, 2, 0xFF000000 );
			bgFill.setPixel( 0, 3, 0xFF000000 );
		}
		
		bg.makeGraphic( Std.int( width ), Std.int( height ), 0xFF804000 );
		var bmpd = bg.pixels;
		bmpd.lock();
		
		var pt = new Point( 0, 0 );
		var numX = Std.int( bmpd.width / bgFill.width );
		var numY = Std.int( bmpd.height / bgFill.height );
		var srcRect = new Rectangle( 0, 0, bgFill.width, bgFill.height );
		
		for ( x in 0...numX ) {
			for ( y in 0...numY ) {
				pt.x = x * bgFill.width;
				pt.y = y * bgFill.height;
				bmpd.copyPixels( bgFill, srcRect,	pt );
			}
		}
		
		var mtr = new Matrix();
		mtr.createGradientBox( radius * 2, radius * 2, 0, 0, 0 );
		var circ = new Sprite();
		circ.graphics.beginGradientFill( GradientType.RADIAL, [0xFFFF00, 0xFF8000], [0.7, 0], [0, 255], mtr );
		circ.graphics.drawCircle( radius, radius, radius );
		circ.graphics.endFill();
		var pm = new Matrix();
		
		for ( pt in lightSources ) {
			pm.translate( pt.x * flxScale, pt.y * flxScale );
			bmpd.draw( circ, pm, null, BlendMode.LIGHTEN );
		}
		bmpd.unlock();
		
	}
}