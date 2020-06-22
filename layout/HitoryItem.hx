package tstool.layout;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxSpriteButton;

/**
 * ...
 * @author ...
 */
class HitoryItem extends FlxText
{
	public var index(get, null):Int;

	function get_index():Int
	{
		return index;
	}

	public function new(index:Int, X:Float=0, Y:Float=0, FieldWidth:Float=0, ?Text:String, Size:Int=8, EmbeddedFont:Bool=true)
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		this.index = index;
		
	}

}