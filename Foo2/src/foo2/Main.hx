package foo2;

import foo2.GameObject2;
import nme.display.Shape;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Rectangle;
import nme.Lib;
import nme.system.Capabilities;
import nme.text.TextField;

import rpkit.utils.FPSCounter;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Main extends Sprite 
{
	private static var USE_CANVAS:Bool = true;
	
	private var gObjects:Array<GameObject>;
	private var gObject2s:Array<GameObject2>;
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, this_onAddedToStage);
	}

	private function init() 
	{
		// entry point
		
		// new to Haxe NME? please read *carefully* the readme.txt file!
		
		
		var rect:Shape = new Shape();
		rect.graphics.beginFill( 0x00ff00, 1 );
		rect.graphics.drawRect( 0, 0, 300, 300 );
		rect.graphics.endFill();
		addChild( rect );
		
		var tf:TextField = new TextField();
		tf.y = 20;
		tf.width = 300;
		tf.wordWrap = true;
		tf.multiline = true;
		tf.text = "Hello world";
		tf.text += "\nDPI: " + Capabilities.screenDPI;
		tf.text += "\nresX: " + Capabilities.screenResolutionX + ", resY: " + Capabilities.screenResolutionY;
		tf.text += "\nStage width: " + stage.stageWidth + ", height: " + stage.stageHeight;

		addChild( tf );

		
		GameObject.bounds = GameObject2.bounds = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );
		
		gObjects = new Array<GameObject>();
		gObject2s = new Array<GameObject2>();
		
		for ( i in 0...500 ) {
			if ( USE_CANVAS ) {
				var gobj2 = new GameObject2();
				gObject2s.push( gobj2 );
			} else {
				var gobj = new GameObject();
				gObjects.push( gobj );
				addChild( gobj );
			}
		}
	
		if ( USE_CANVAS ) {
			addEventListener( Event.ENTER_FRAME, onEnterFrame2 );
		} else {
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		

		var fps:FPSCounter = new FPSCounter();
		addChild( fps );

		resize ();
		
		stage.addEventListener (Event.RESIZE, stage_onResize);
	}
	
	private function onEnterFrame( ev:Event ):Void {
		for ( gobj in gObjects ) {
			gobj.tick();
		}
	}

	private function resize ()
	{
	}

	private function stage_onResize (event:Event):Void
	{	
		resize ();
	}

	private function this_onAddedToStage (event:Event):Void
	{	
		init ();	
	}
	
	private function onEnterFrame2( ev:Event ):Void {
		graphics.clear();
		for ( gobj in gObject2s ) {
			gobj.tick();
			gobj.paint( graphics );
		}
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}
