package tstool.process;
import tstool.layout.History;
import tstool.layout.PageLoader;
import tstool.layout.UI;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import tstool.layout.History.Interactions;
//import flixel.addons.ui.FlxUIButton;
/**
 * ...
 * @author
 */
class Descision extends Process
{
	// var _buttonYesTxt(default, set):String = "Yes";
	var _buttonYesTxt(default, set):String = MainApp.translator.get("$defaultBtn_UI3","meta");
	// var _buttonNoTxt(default, set):String = "No";Main.tongue.get(
	var _buttonNoTxt(default, set):String = MainApp.translator.get("$defaultBtn_UI1","meta");
	//var _nextNoProcesses:Array<Process> = [];
	//var _nextYesProcesses:Array<Process> = [];
	var btnNo:FlxButton;
	var btnYes:FlxButton;
	//var seperator:flixel.addons.display.shapes.FlxShapeBox;
	override public function new()
	{
		super();
		
	}
	override public function create():Void
	{
		
		_buttonYesTxt = MainApp.translator.translate(_name, _buttonYesTxt, "RIGHT-BTN");
		
		_buttonNoTxt =  MainApp.translator.translate(_name, _buttonNoTxt, "LEFT-BTN") ;
		
		super.create();
		
		/**
		 * @todo SPEARATE layout items
		 */
		btnYes = new FlxButton(0, 0, _buttonYesTxt, onYesClick);
		registerButton(btnYes);
		btnNo = new FlxButton(0, 0, _buttonNoTxt, onNoClick);
		registerButton(btnNo);
		//seperator = new FlxShapeBox(0, 0, FlxG.width, 8, {thickness:4, color: 0x111111}, 0xff0000);
		btnNo.loadGraphic("assets/images/ui/left.png", true, 50, 40);
		btnYes.loadGraphic("assets/images/ui/right.png", true, 50, 40);
		//btnNo.setGraphicSize(50);
		//btnYes.setGraphicSize(50);
		var ptNo:FlxPoint = new FlxPoint( 0, -_padding);
		btnYes.labelOffsets= [ptNo, ptNo, ptNo];
		btnNo.labelOffsets = [ptNo, ptNo, ptNo];
		btnYes.labelAlphas = [1,1,1];
		btnNo.labelAlphas = [1,1,1];
		btnYes.label.setFormat(UI.INTERACTION_FMT.font, UI.INTERACTION_FMT.size);
		btnNo.label.setFormat( UI.INTERACTION_FMT.font, UI.INTERACTION_FMT.size);

		add(btnYes);
		add(btnNo);

		btnNo.label.wordWrap = false;
		btnYes.label.wordWrap = false;
		btnNo.label.autoSize = true;
		btnYes.label.autoSize = true;
		btnYes.updateHitbox();
		btnNo.updateHitbox();
		
		positionThis();
		
		setStyle();
		
		//setStyle();
	}
	function positionThis(?offSet:FlxPoint)
	{
		positionMain( [btnNo,btnYes] , offSet) ;	
	}
	override public function setStyle()
	{
		super.setStyle();
		btnNo.label.color = UI.THEME.interaction;
		btnYes.label.color = UI.THEME.interaction;
	}
	public function onYesClick():Void
	{
		pushToHistory(_buttonYesTxt, Interactions.Yes);
		moveToNextClassProcess(Interactions.Yes);
	}

	public function onNoClick():Void
	{
		pushToHistory(_buttonNoTxt, Interactions.No);
		moveToNextClassProcess(Interactions.No);
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

}