package tstool.layout;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;

/**
 * ...
 * @author bb
 */
class Instructions extends ClosableSubState 
{

	public function new() 
	{
		//var bg = UI.THEME.bg;
		var bg:FlxColor = SaltColor.BLACK_PURE;
		bg.alphaFloat = .8;
		super(bg);
		
	}
	override public function create():Void
	{
		super.create();
		var illustration = new FlxSprite(0, 0, "assets/images/" + MainApp.translator.get("$flow.TutoTree_ILLUSTRATION", "data") + ".png");
		add(illustration);
		illustration.screenCenter();
	}
}