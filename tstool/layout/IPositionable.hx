package tstool.layout;
import flixel.math.FlxPoint;
import lime.math.Rectangle;

/**
 * @author bb
 */
enum Direction
{
	left;
	right;
	bottom;
	top;
}

interface IPositionable 
{
	public var boundingRect(get, null):Rectangle;
	//public function get_boundingRect():Rectangle;
	public function positionMe(parent:Rectangle, ?padding:Int = 4, ?positionsToParent:Array<Direction>=null):FlxPoint;
}