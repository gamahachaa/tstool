package tstool.layout;

import flixel.system.FlxBasePreloader;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author ...
 */
//@:bitmap("assets/images/CustomPreload/default.png") class LogoImage extends BitmapData { }
//@:font("assets/data/GameBoy.ttf") class CustomFont extends Font {}
class SaltPreloader extends FlxBasePreloader
{
	var text:TextField;
	var logo:Sprite;
	public function new(MinDisplayTime:Float=0, ?AllowedURLs:Array<String>)
	{
		super(MinDisplayTime, AllowedURLs);

	}
	override function create():Void
	{
		var ratio:Float = this._width / 800; //This allows us to scale assets depending on the size of the screen.
       
        //logo = new Sprite();
        //logo.addChild(new Bitmap(new LogoImage(0,0))); //Sets the graphic of the sprite to a Bitmap object, which uses our embedded BitmapData class.
        //logo.scaleX = logo.scaleY = ratio;
        //logo.x = 640 - logo.width/2;
        //logo.y = 50;
        //addChild(logo); //Adds the graphic to the NMEPreloader's buffer.
		
		text = new TextField();
		text.defaultTextFormat = new TextFormat("Verdana",36, SaltColor.LIGHT_BLUE);
		text.width = 300;
		//text.textColor = 0xffffff;
		text.selectable = false;
		text.multiline = false;
		text.x =1200/2;
		text.y = 800/2;
		//text.width = _width;
		addChild(text);
	}
	override function update(Percent:Float):Void
	{
		text.text = "Loading " + Std.int(Percent * 100) + "%";
		super.update(Percent);
	}
}