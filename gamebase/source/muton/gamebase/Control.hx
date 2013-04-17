package muton.gamebase;
import org.flixel.FlxG;
import org.flixel.system.input.FlxKeyboard;

/**
 * ...
 * @author tim@muton.co.uk
 */

typedef CtrlState = {
	up:Bool,
	down:Bool,
	left:Bool,
	right:Bool,
	fireA:Bool,
	fireB:Bool
}
 
class Control {

	public static inline function state():CtrlState {
		var st:CtrlState = {
			up: pressedUp(),
			down: pressedDown(),
			left: pressedLeft(),
			right: pressedRight(),
			fireA: pressedFireA(),
			fireB: pressedFireB()
		}
		return st;
	}
	
	public static inline function pressedUp():Bool {
		return FlxG.keys.UP || FlxG.keys.W;
	}
	
	public static inline function pressedDown():Bool {
		return FlxG.keys.DOWN || FlxG.keys.S;
	}
	
	public static inline function pressedLeft():Bool {
		return FlxG.keys.LEFT || FlxG.keys.A;
	}
	
	public static inline function pressedRight():Bool {
		return FlxG.keys.RIGHT || FlxG.keys.D;
	}
	
	public static inline function pressedFireA():Bool {
		return FlxG.keys.CONTROL || FlxG.keys.M;
	}
	
	public static inline function pressedFireB():Bool {
		return FlxG.keys.SHIFT || FlxG.keys.N;
	}
	
}