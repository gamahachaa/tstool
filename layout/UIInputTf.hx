package tstool.layout;

//import flixel.FlxBasic;
//import flixel.group.FlxGroup.FlxTypedGroup;
//import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.ui.FlxInputText;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import js.Browser;
import js.html.ClipboardEvent;
import lime.math.Rectangle;

import tstool.process.Process;

/**
 * ...
 * @author bb
 */
enum Direction{
	left;
	right;
	bottom;
	up;	
}
class UIInputTf
{
	var _autoFocus:Bool;
	var positoinToParent:Direction;
	public var _label(get, null):String;
	public var _labelValidator(default, set):String;
	public var inputtextfield(get, null):FlxInputText;
	public var imputLabel(get, null):FlxText;
	public var height(get, null):Float;
	public var width(get, null):Float;
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var boundingRect(get, null):Rectangle;
	public function new(textFieldWidth:Int, inputPrefix:String, ?positoinToParent:Direction=bottom)
	{
		this.positoinToParent = positoinToParent;
		_label = inputPrefix;
		_labelValidator = "";
		
		imputLabel = new FlxText(0, 0, textFieldWidth, _label + " :", 20);
		imputLabel.setFormat(Main.INTERACTION_FMT.font, Main.INTERACTION_FMT.size-2);
		inputtextfield = new FlxInputText(0, 0, textFieldWidth, 14);
		inputtextfield.focusGained = onFocus;
		inputtextfield.focusLost = onFocusLost;
		boundingRect = new Rectangle();
	}
		
	public function addToParent(parent:Process, ?autoFocus:Bool = true)
	{
		_autoFocus = autoFocus;
		
		parent.add(imputLabel);
		parent.add(inputtextfield);
		if (_autoFocus)
		{
			inputtextfield.hasFocus = true;
			Browser.document.addEventListener("paste", onPaste);
		}
	}
	public function positionMe(parent:Rectangle, ?padding:Int=20 , ?direction:Direction=null)
	{
		//trace(direction);
		//trace(parent);
		//trace(parent.y + parent.height + (padding / 4));
		var d:Direction = direction == null ? positoinToParent : direction;
		switch (d)
		{
			case bottom:
				//trace("bottom");
				inputtextfield.x  = imputLabel.x = parent.x;
				imputLabel.y = parent.y + parent.height + (padding / 4);
				inputtextfield.y = this.imputLabel.y + this.imputLabel.height;
			case up :
				//trace("up");
				inputtextfield.x  = imputLabel.x = parent.x;
				imputLabel.y = parent.y - (imputLabel.height + inputtextfield.height) + (padding/4);
				inputtextfield.y = this.imputLabel.y + this.imputLabel.height;
			case left:
				//trace("left");
				inputtextfield.x  = imputLabel.x = parent.x - Math.max(inputtextfield.width, imputLabel.width ) + (padding/2);
				imputLabel.y = parent.y;
				inputtextfield.y = this.imputLabel.y + this.imputLabel.height;
			case right:
				//trace("right");
				inputtextfield.x  = imputLabel.x = parent.x + parent.width + (padding/4);
				imputLabel.y = parent.y;
				inputtextfield.y = this.imputLabel.y + this.imputLabel.height;
				
		}
		this.boundingRect.x = this.imputLabel.x;
		this.boundingRect.y = this.imputLabel.y;
		this.boundingRect.width = Math.max(this.imputLabel.width, this.inputtextfield.width);
		this.boundingRect.height = this.imputLabel.height + this.imputLabel.height;
	}
	function onPaste(e: ClipboardEvent):Void
	{
		onFocus();
		if (inputtextfield.hasFocus)
		{
			inputtextfield.text = e.clipboardData.getData("text/plain");
			e.stopPropagation();
		}
		
	}
	function get_inputtextfield():FlxInputText
	{
		return inputtextfield;
	}

	function get_imputLabel():FlxText
	{
		return imputLabel;
	}
	function onFocus()
	{
		if (!_autoFocus){
			Browser.document.addEventListener("paste", onPaste);
		}
		if (FlxFlicker.isFlickering(imputLabel))
		{
			blink(false);
		}
	}
	function onFocusLost() 
	{
		if (!_autoFocus){
			Browser.document.removeEventListener("paste", onPaste);
		}
	}
	public function setStyle()
	{
		imputLabel.color = Main.THEME.meta;
	}

	public function clearText()
	{
		var t = inputtextfield.text.split("");
		t.pop();
		inputtextfield.text = t.join("");
		inputtextfield.caretIndex = t.length;
		inputtextfield.draw();
		inputtextfield.drawFrame(true);
	}
	public function blink( start:Bool )
	{
		if (start){
			_labelValidator != "" ? imputLabel.text = _labelValidator : _label;
			FlxFlicker.flicker(imputLabel, 0, .5);
			inputtextfield.hasFocus = true;
		}
		else{
			imputLabel.text = _label;
			FlxFlicker.stopFlickering(imputLabel);
		}
		
	}
	
	function get__label():String 
	{
		return _label;
	}
	
	public function getInputedText()
	{
		return inputtextfield.text;
	}
	
	function set__labelValidator(value:String):String 
	{
		return _labelValidator = value;
	}
	public function hasFocus():Bool
	{
		return this.inputtextfield.hasFocus;
	}
	
	function get_height():Float 
	{
		return this.inputtextfield.y + this.inputtextfield.height - this.imputLabel.y;
	}
	
	function get_width():Float 
	{
		return Math.max(this.imputLabel.width, this.inputtextfield.width);
	}
	
	function get_x():Float 
	{
		return this.imputLabel.x;
	}
	function get_y():Float 
	{
		return this.imputLabel.y;
	}
	
	function get_boundingRect():Rectangle 
	{
		return boundingRect;
	}
	
	public function toggleFocus()
	{
		this.inputtextfield.hasFocus = !this.inputtextfield.hasFocus;
	}
}