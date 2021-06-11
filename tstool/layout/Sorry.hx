package tstool.layout;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author bb
 */
class Sorry extends FlxState 
{

	override public function create()
	{
		var s = new FlxText(0, 0, 300, "Firefox only ! Sorry ...", 14);
		add(s);
		super.create();
	}
	
}