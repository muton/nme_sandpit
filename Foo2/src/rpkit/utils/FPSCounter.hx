package rpkit.utils;

import nme.display.Sprite;
import nme.text.TextField;
import haxe.Timer;
import nme.events.Event;

/**
 * ...
 * @author richard@richarddas.com
 */

class FPSCounter extends Sprite
{
	private var label:TextField;

	private var fpsHistory:Array<Float>;

	private var ticks:Int = 0;

	public function new()
	{
		super();
		init();
	}

	private function init()
	{
		fpsHistory =  [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

		label = new TextField();
		label.border = true;
		label.background = true;
		label.backgroundColor = 0xffffff;
		label.selectable = false;
		label.width = 40;
		label.height = 20;
		label.text = "FPS";

		addChild( label );

		fpsHistory.push( Timer.stamp() );
	    fpsHistory.shift();

		addEventListener( Event.ENTER_FRAME, onEnterFrame );
	}

	private function onEnterFrame( ev:Event ):Void
	{
		ticks++;

		var now:Float = Timer.stamp();
        var delta:Float = now - fpsHistory[ fpsHistory.length - 1 ];

        var fps:Float = ticks / delta;
		fps = Math.round( fps );
        label.text = Std.string ( fps ) + " fps";
        ticks = 0;

	    fpsHistory.push( now );
	    fpsHistory.shift();
	}

}		
