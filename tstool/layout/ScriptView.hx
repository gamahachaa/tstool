package tstool.layout;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTextField;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import lime.system.Clipboard;
//import flixel.util.FlxSignal;

/**
 * ...
 * @author bb
 */
class ScriptView extends ClosableSubState 
{
	var text:String;
	var clipBoardBtn:flixel.ui.FlxButton;
	

	public function new(text:String) 
	{
		this.text = text;
		//var bg = UI.THEME.bg;
		var bg:FlxColor = SaltColor.BLACK;
		//bg.alphaFloat = .8;
		super(bg);
		
	}
	override public function create():Void
	{
		var ptNo:FlxPoint = new FlxPoint( -4, -20);
		clipBoardBtn = new FlxButton(FlxG.width/2, 0,"Copy summary");
		clipBoardBtn.loadGraphic("assets/images/ui/clipBoard.png", true, 40, 40);
		var t = new FlxText(UI.PADDING,UI.PADDING,FlxG.width-(UI.PADDING*2),"<b>SUMMARY<b>\n" + text, UI.BASIC_FMT.size -2, true);
		t.setFormat( UI.BASIC_FMT.font, UI.BASIC_FMT.size);
		t.applyMarkup("<b>SUMMARY<b>\n" + text, [UI.THEME.basicStrong, UI.THEME.basicEmphasis]);
		clipBoardBtn.labelOffsets = [ptNo, ptNo, ptNo];
		clipBoardBtn.label.setFormat(UI.META_FMT.font, UI.META_FMT.size);
		clipBoardBtn.label.wordWrap = false;
		clipBoardBtn.label.autoSize = true;
		clipBoardBtn.updateHitbox();
		clipBoardBtn.y = t.height + (UI.PADDING*2);
		add(t);
		add(clipBoardBtn);
		
		super.create();
		
	}
	function onclipBoardClick()
	{
		Clipboard.text = this.text;
		trace("clicked");
	}
	override public function update(elapsed:Float)
	{
		
		
		if ( FlxG.mouse.justReleased )
		{
			var h = clipBoardBtn.getHitbox();
			if ( 
				(FlxG.mouse.x  - h.x > 0 &&  FlxG.mouse.x - h.x < h.width) 
				&& ( FlxG.mouse.y - h.y> 0 && FlxG.mouse.y - h.y < h.height))
			{
				onclipBoardClick();
			}
			
		}
		super.update(elapsed);
	}
}