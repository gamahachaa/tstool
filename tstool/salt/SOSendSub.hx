package tstool.salt;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import tstool.layout.UI;


/**
 * ...
 * @author bb
 */
class SOSendSub extends FlxSubState
{
	var spritesheet:flixel.FlxSprite;
	var _sprite:FlxGraphicAsset;
	public function new(sprite:String)
	{
		super(UI.THEME.bg);
		_sprite = "assets/images/" + sprite;
	}
	override public function create():Void
	{
		super.create();
		spritesheet = new FlxSprite();
		spritesheet.loadGraphic(_sprite, true, 200, 200);
		spritesheet.screenCenter();
		spritesheet.animation.add("send", [0, 1, 2, 3, 4, 5], 60, true);
		spritesheet.animation.play("send");
		add(spritesheet);
	}
	
}