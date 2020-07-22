package tstool.layout;

import flixel.text.FlxText;

/**
 * ...
 * @author bb
 */
class Question extends FlxText implements IPositionable 
{

	public function new(X:Float=0, Y:Float=0, FieldWidth:Float=0, ?Text:String, Size:Int=8, EmbeddedFont:Bool=true) 
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		
	}
	
}