package tstool.layout;

//import tstool.layout.UIInputTfCore;
import tstool.layout.IPositionable.Direction;
import tstool.layout.SaltColor;
import flixel.FlxG;
//import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxSignal.FlxTypedSignal;
import lime.utils.Assets;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
//import openfl.utils.Function;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import js.html.ClipboardEvent;
import lime.math.Rectangle;
import tstool.process.Process;
/**
 * ...
 * @author bb
 */

class UIInputTfCore implements IFlxDestroyable implements IPositionable
{
	//var _autoFocus:Bool;
	public var focusSignal(get, null):FlxTypedSignal<UIInputTfCore->Void>;
	public var positionsToParent(get, null):Array<Direction>;
	public var _label(get, null):String;
	public var _labelValidator(default, set):String;
	public var inputtextfield(get, null):TextField;
	public var imputLabel(get, null):FlxText;
	public var height(get, null):Float;
	public var width(get, null):Float;
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var boundingRect(get, null):Rectangle;
	//
	static var textFieldFormat:TextFormat;
	//
	public function new(textFieldWidth:Int, inputPrefix:String, positionsToParent:Array<Direction>)
	{
		if (textFieldFormat == null) textFieldFormat = new TextFormat(Assets.getFont("assets/fonts/JetBrainsMono-Regular.ttf").name, 13);
		focusSignal = new FlxTypedSignal<UIInputTfCore->Void>();
		this.positionsToParent = positionsToParent;
		//var dummy:UIInputTf = null;
		_label = inputPrefix;
		_labelValidator = "";

		imputLabel = new FlxText(0, 0, textFieldWidth, _label + " :", 20);
		imputLabel.setFormat(Main.INTERACTION_FMT.font, Main.INTERACTION_FMT.size-2);

		//inputtextfield = new FlxInputText(0, 0, textFieldWidth, 14);
		inputtextfield = new TextField();
		inputtextfield.height = 20;
		inputtextfield.width = textFieldWidth;
		inputtextfield.addEventListener(MouseEvent.CLICK, onClick);

		boundingRect = new Rectangle();
	}

	function onClick(e:MouseEvent):Void
	{
		#if debug
		//trace(this._label);
		//trace(e.currentTarget);
		#end
		this.blink(false);
		this.focusSignal.dispatch(this);
	}

	public function addToParent(parent:Process)
	{

		parent.add(imputLabel);

		FlxG.addChildBelowMouse( inputtextfield);

	}
	//public function positionMe(parent:Rectangle, ?padding:Int=20, ?direction:Direction=null)
	//public function positionMe(parent:Rectangle, ?padding:Int=20, ?directions:Array<Direction>=null)
	public function positionMe(parent:Rectangle, ?padding:Int=4, ?directions:Array<Direction>=null):Void
	{
		
		//trace(parent);
		//trace(parent.y + parent.height + (padding / 4));
		var d:Array<Direction> = directions == null ? this.positionsToParent : directions;
		var p = parent;
		//trace(parent);
		//trace(d);
		switch (d[0])
		{
			case bottom:
				//trace("bottom");
				//trace(d[1] == right? "right":"left");
				inputtextfield.x  = imputLabel.x = p.x + (d[1] == right ? p.width + (padding/4): 0);
				imputLabel.y = p.y + p.height /*+ (padding / 4)*/;
				inputtextfield.y = this.imputLabel.y + this.imputLabel.height;
			case top :
				//trace("top");
				inputtextfield.x  = imputLabel.x = p.x + (d[1] == right ? p.width + (padding/4): 0);
				imputLabel.y = p.y;
				inputtextfield.y = this.imputLabel.y + this.imputLabel.height;
			case left:
				//trace("left");
				inputtextfield.x  = imputLabel.x = parent.x - Math.max(inputtextfield.width, imputLabel.width ) + (padding/2);
				imputLabel.y = (d[1] == top ? 0 : p.height + (padding/2) ) + p.y;
				inputtextfield.y = this.imputLabel.y + this.imputLabel.height;
			case right:
				//trace("right");
				inputtextfield.x  = imputLabel.x = parent.x + p.width + (padding/4);
				imputLabel.y = (d[1] == top ? 0 : p.height + (padding/2) ) + p.y;
				inputtextfield.y = this.imputLabel.y + this.imputLabel.height;

		}
		this.boundingRect.x = this.imputLabel.x;
		this.boundingRect.y = this.imputLabel.y;
		this.boundingRect.width = Math.max(this.imputLabel.width, this.inputtextfield.width);
		this.boundingRect.height = this.imputLabel.height + this.imputLabel.height;
		//trace(this.boundingRect);
		//trace("---");
	}
	function onPaste(e: ClipboardEvent):Void
	{
		//onFocus();
		//if (inputtextfield.hasFocus)
		//{
		//inputtextfield.text = e.clipboardData.getData("text/plain");
		//e.stopPropagation();
		//}

	}
	function get_inputtextfield():TextField
	{
		return inputtextfield;
	}

	function get_imputLabel():FlxText
	{
		return imputLabel;
	}
	//function onFocus()
	//{
	//if (!_autoFocus){
	//Browser.document.addEventListener("paste", onPaste);
	//}
	//if (FlxFlicker.isFlickering(imputLabel))
	//{
	//blink(false);
	//}
	//}
	//function onFocusLost()
	//{
	//if (!_autoFocus){
	//Browser.document.removeEventListener("paste", onPaste);
	//}
	//}
	public function setStyle()
	{
		imputLabel.color = Main.THEME.meta;

		inputtextfield.setTextFormat(textFieldFormat);
		inputtextfield.multiline = false;
		inputtextfield.type = TextFieldType.INPUT;
		inputtextfield.backgroundColor = SaltColor.WHITE;
		inputtextfield.textColor = SaltColor.BLACK;
		//inputtextfield.text = memoDefault;
		inputtextfield.border = true;
		inputtextfield.borderColor = SaltColor.BLACK;
		inputtextfield.background = true;
	}

	public function clearText()
	{
		var t = inputtextfield.text.split("");
		t.pop();
		inputtextfield.text = t.join("");
		//inputtextfield.caretIndex = t.length;
		//inputtextfield.draw();
		//inputtextfield.drawFrame(true);
	}
	public function blink( start:Bool )
	{
		if (start)
		{
			_labelValidator != "" ? imputLabel.text = _labelValidator : _label;
			FlxFlicker.flicker(imputLabel, 0, .5);
			//inputtextfield.hasFocus = true;
		}
		else
		{
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
	//public function hasFocus():Bool
	//{
	//return this.inputtextfield.hasFocus;
	//}

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

	function get_focusSignal():FlxTypedSignal<UIInputTfCore->Void>
	{
		return focusSignal;
	}

function get_positionsToParent():Array<Direction> 
{
	return positionsToParent;
}

	public function destroy()
	{
		this.inputtextfield.removeEventListener(MouseEvent.CLICK, onClick);
		this.inputtextfield = null;
		this.imputLabel.destroy();
	}
}