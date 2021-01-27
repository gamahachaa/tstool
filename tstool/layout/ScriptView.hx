package tstool.layout;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTextField;
import flixel.text.FlxText;
import flixel.util.FlxColor;
//import flixel.util.FlxSignal;

/**
 * ...
 * @author bb
 */
class ScriptView extends ClosableSubState 
{
	var text:String;
	

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
		var t = new FlxText(UI.PADDING,UI.PADDING,FlxG.width-(UI.PADDING*2), text, UI.BASIC_FMT.size -2, true);
		t.setFormat( UI.BASIC_FMT.font, UI.BASIC_FMT.size);
		t.applyMarkup(text, [UI.THEME.basicStrong, UI.THEME.basicEmphasis]);
		add(t);
		
		super.create();
		
	}
	
}