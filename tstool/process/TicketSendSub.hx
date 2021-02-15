package tstool.process;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;


/**
 * ...
 * @author bb
 */
class TicketSendSub extends FlxSubState
{
	var spritesheet:flixel.FlxSprite;
	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT)
	{
		super(BGColor);
	}
	override public function create():Void
	{
		super.create();
		spritesheet = new FlxSprite();
		spritesheet.loadGraphic("assets/images/ui/mail.png", true, 200, 200);
		spritesheet.screenCenter();
		spritesheet.animation.add("send", [0, 1, 2, 3, 4, 5], 60, true);
		spritesheet.animation.play("send");
		add(spritesheet);
	}
	
}