package tstool.ui;

import flixel.FlxG;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIAssets;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIDropDownMenu.FlxUIDropDownHeader;
import flixel.addons.ui.StrNameLabel;
import flixel.effects.FlxFlicker;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author bb
 */
class FlxDDown extends FlxUIDropDownMenu 
{

	public function new(X:Float=0, Y:Float=0, DataList:Array<StrNameLabel>, ?Callback:String->Void, ?Header:FlxUIDropDownHeader, ?DropPanel:FlxUI9SliceSprite, ?ButtonList:Array<FlxUIButton>, ?UIControlCallback:Bool->FlxUIDropDownMenu->Void) 
	{
		super(X, Y, DataList, Callback, Header, DropPanel, ButtonList, UIControlCallback);

	}
	override private function makeListButton(i:Int, Label:String, Name:String):FlxUIButton
	{
		var t:FlxUIButton = new FlxUIButton(0, 0, Label);
		
		//header.y = header.y  -2;
		header.text.setPosition(2, 2);
		header.text.setFormat(null, 12, 0x333333);
		t.broadcastToFlxUI = false;
		t.onUp.callback = onClickItem.bind(i);

		t.name = Name;

		t.loadGraphicSlice9([FlxUIAssets.IMG_INVIS, FlxUIAssets.IMG_HILIGHT, FlxUIAssets.IMG_HILIGHT], Std.int(header.background.width),
			Std.int(header.background.height), [[1, 1, 3, 3], [1, 1, 3, 3], [1, 1, 3, 3]], FlxUI9SliceSprite.TILE_NONE);
		t.labelOffsets[FlxButton.PRESSED].y -= 1; // turn off the 1-pixel depress on click

		t.up_color = FlxColor.BLACK;
		t.over_color = FlxColor.WHITE;
		t.down_color = FlxColor.WHITE;

		//t.resize(header.background.width - 2, header.background.height - 1);

		t.label.alignment = "left";
		
		t.label.setFormat(null, 12, 0x333333);
		
		t.autoCenterLabel();
		t.x = 1;

		for (offset in t.labelOffsets)
		{
			offset.x += 2;
		}

		return t;
	}
	public function blink( start:Bool )
	{
		if (start)
		{
			FlxFlicker.flicker( this.header.text, 0, .3);
		}
		else
		{
			FlxFlicker.stopFlickering(this.header.text);
		}
	}
	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		#if FLX_MOUSE
		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(this))
			{
				blink(false);
			}
		}
		#end
	}
	
}