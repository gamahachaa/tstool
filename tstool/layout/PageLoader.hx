package tstool.layout;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;

/**
 * ...
 * @author bb
 */
class PageLoader extends FlxSubState 
{

	//var spritesheet:flixel.FlxSprite;
	public function new()
	{
		super(SaltColor.BLACK);
	}
	override public function create():Void
	{
		
		var spritesheet = new FlxSprite();
		spritesheet.loadGraphic("assets/images/ui/pageLoader.png", true, 200, 200);
		spritesheet.screenCenter();
		spritesheet.animation.add("send", [0, 1, 2, 3, 4, 5], 6);
		add(spritesheet);
		spritesheet.animation.play("send");
		super.create();
		
	}
	
}