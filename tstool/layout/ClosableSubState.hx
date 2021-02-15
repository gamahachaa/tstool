package tstool.layout;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;

/**
 * ...
 * @author bb
 */
class ClosableSubState extends FlxSubState 
{
	var closeBtn:FlxButton;
	public var signal:FlxSignal;
	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		signal = new FlxSignal();
	}
	override public function update(elapsed:Float)
	{
		if ( FlxG.keys.justReleased.ESCAPE )
		{
			signal.dispatch
();
			close();
		}
		if ( FlxG.mouse.justReleased )
		{
			var h = closeBtn.getHitbox();
			if ( 
				(FlxG.mouse.x  - h.x > 0 &&  FlxG.mouse.x - h.x < h.width) 
				&& ( FlxG.mouse.y - h.y> 0 && FlxG.mouse.y - h.y < h.height))
			{
				signal.dispatch
();
				close();
			}
			
		}
		super.update( elapsed );
	}
	override public function create():Void
	{
		
		closeBtn = new FlxButton(0, 0, "" );
		closeBtn.loadGraphic("assets/images/ui/close.png", true, 40, 40);
		add(closeBtn);
		closeBtn.x = FlxG.width - closeBtn.width - 20;
		closeBtn.y = 20;
		super.create();
	}
}