package tstool.process;
import tstool.layout.History;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import tstool.layout.History.Interactions;
//import flixel.addons.ui.FlxUIButton;
/**
 * ...
 * @author
 */
class Triplet extends Process
{
	// var _buttonYesTxt(default, set):String = "Yes";
	var _buttonYesTxt(default, set):String = Main.tongue.get("$defaultBtn_UI3","meta");
	var _buttonMidTxt(default, set):String = Main.tongue.get("$defaultBtn_UI2","meta");
	// var _buttonNoTxt(default, set):String = "No";Main.tongue.get(
	var _buttonNoTxt(default, set):String = Main.tongue.get("$defaultBtn_UI1","meta");
	var _nextNoProcesses:Array<Process> = [];
	var _nextYesProcesses:Array<Process> = [];
	var _nextMidProcesses:Array<Process> = [];
	var btnNo:FlxButton;
	var btnYes:FlxButton;
	var btnMid:FlxButton;
	//var seperator:flixel.addons.display.shapes.FlxShapeBox;
	override public function new()
	{
		super();
		_buttonYesTxt = translate(_buttonYesTxt, "RIGHT-BTN");
		_buttonMidTxt = translate(_buttonMidTxt, "MID-BTN");
		//_buttonYesTxt = " \u2B62";
		_buttonNoTxt =  translate(_buttonNoTxt, "LEFT-BTN") ;
	}
	override public function create():Void
	{
		super.create();
		btnYes = new FlxButton(0, 0, _buttonYesTxt, onYesClick);
		registerButton(btnYes);	
		btnMid = new FlxButton(0, 0, _buttonMidTxt, onMidClick);
		registerButton(btnMid);
		btnNo = new FlxButton(0, 0, _buttonNoTxt, onNoClick);
		registerButton(btnNo);
		//seperator = new FlxShapeBox(0, 0, FlxG.width, 8, {thickness:4, color: 0x111111}, 0xff0000);
		btnNo.loadGraphic("assets/images/ui/left.png", true, 50, 40);
		btnYes.loadGraphic("assets/images/ui/right.png", true, 50, 40);
		btnMid.loadGraphic("assets/images/ui/down.png", true, 50, 40);
		//btnNo.setGraphicSize(50);
		//btnYes.setGraphicSize(50);
		var ptNo:FlxPoint = new FlxPoint( 0, -_padding);
		btnYes.labelOffsets= [ptNo, ptNo, ptNo];
		btnNo.labelOffsets = [ptNo, ptNo, ptNo];
		btnMid.labelOffsets = [ptNo, ptNo, ptNo];
		btnYes.labelAlphas = [1,1,1];
		btnNo.labelAlphas = [1,1,1];
		btnMid.labelAlphas = [1,1,1];
		btnYes.label.setFormat(Main.INTERACTION_FMT.font, Main.INTERACTION_FMT.size);
		btnNo.label.setFormat( Main.INTERACTION_FMT.font, Main.INTERACTION_FMT.size);
		btnMid.label.setFormat( Main.INTERACTION_FMT.font, Main.INTERACTION_FMT.size);
		//btnNo.label.color = Main.INTERACTION_FMT.color;
		//btnYes.label.color = Main.INTERACTION_FMT.color;
		//btnNo.label.size = Main.INTERACTION_FMT.size;
		//btnYes.label.size = Main.INTERACTION_FMT.size;

		//add(seperator);
		add(btnYes);
		add(btnNo);
		add(btnMid);

		btnNo.label.wordWrap = false;
		btnYes.label.wordWrap = false;
		btnMid.label.wordWrap = false;
		btnNo.label.autoSize = true;
		btnYes.label.autoSize = true;
		btnMid.label.autoSize = true;
		btnYes.updateHitbox();
		btnNo.updateHitbox();
		btnMid.updateHitbox();
		positionThis();
	}
	function positionThis()
	{
		//var btnSep = (2 * FlxG.width / 3) / 3;
		//btnNo.x = FlxG.width / 3 + _padding;
		//btnMid.x = btnNo.x + btnSep;
		//btnYes.x =  btnMid.x + btnSep;
//
		//btnMid.y = btnNo.y = btnYes.y = this.question.y + this.question.height + (_padding * 2);
		positionMain(  [btnNo,btnMid,btnYes] );
	}
	override public function setStyle()
	{
		super.setStyle();
		btnNo.label.color = Main.THEME.interaction;
		btnYes.label.color = Main.THEME.interaction;
		btnMid.label.color = Main.THEME.interaction;
	}
	public function onMidClick():Void
	{
		pushToHistory(_buttonMidTxt, Interactions.Mid);
		if (this._nextMidProcesses.length > 0) // @todo remove after full refactor
		{
			move_to_next(this._nextMidProcesses, Interactions.Mid);
		}
	}
	public function onYesClick():Void
	{
		pushToHistory(_buttonYesTxt, Interactions.Yes);
		if (this._nextYesProcesses.length > 0) // @todo remove after full refactor
		{
			move_to_next(this._nextYesProcesses, Interactions.Yes);
		}
	}

	public function onNoClick():Void
	{
		pushToHistory(_buttonNoTxt,Interactions.No);
		if (this._nextNoProcesses.length > 0) // @todo remove after full refactor
		{
			move_to_next(this._nextNoProcesses, Interactions.No);
		}
	}
	override public function update(elapsed:Float):Void
	{
		//seperator.redrawShape();
		if ( FlxG.keys.justReleased.RIGHT )
		{
			onYesClick();
		}
		if ( FlxG.keys.justReleased.LEFT)
		{
			onNoClick();
		}
		if ( FlxG.keys.justReleased.DOWN)
		{
			onMidClick();
		}
		super.update(elapsed);

	}
	function set__buttonYesTxt(value:String):String
	{
		return _buttonYesTxt = value;
	}

	function set__buttonNoTxt(value:String):String
	{
		return _buttonNoTxt = value;
	}
	
	function set__buttonMidTxt(value:String):String 
	{
		return _buttonMidTxt = value;
	}

}