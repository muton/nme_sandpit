package foo2;

import nme.display.Shape;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Rectangle;
import nme.Lib;
import nme.system.Capabilities;
import nme.text.TextField;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Main extends Sprite 
{
	
	private var gObjects:Array<GameObject>;
	
	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e) 
	{
		// entry point
		
		// new to Haxe NME? please read *carefully* the readme.txt file!
		
		
		var rect:Shape = new Shape();
		rect.graphics.beginFill( 0x00ff00, 1 );
		rect.graphics.drawRect( 0, 0, 300, 300 );
		rect.graphics.endFill();
		addChild( rect );
		
		var tf:TextField = new TextField();
		tf.width = 300;
		tf.wordWrap = true;
		tf.multiline = true;
		tf.text = "Hello world";
		tf.text += "\nDPI: " + Capabilities.screenDPI;
		tf.text += "\nresX: " + Capabilities.screenResolutionX + ", resY: " + Capabilities.screenResolutionY;
		tf.text += "\nStage width: " + stage.stageWidth + ", height: " + stage.stageHeight;

		addChild( tf );
		
		GameObject.bounds = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );
		
		gObjects = new Array<GameObject>();
		
		for ( i in 0...100 ) {
			var gobj:GameObject = new GameObject();
			gObjects.push( gobj );
			addChild( gobj );
		}
		
		addEventListener( Event.ENTER_FRAME, onEnterFrame );
	}
	
	private function onEnterFrame( ev:Event ):Void {
		for ( gobj in gObjects ) {
			gobj.tick();
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
