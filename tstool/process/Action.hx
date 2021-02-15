package tstool.process;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import tstool.layout.PageLoader;
import tstool.layout.UI;
//import flixel.util.FlxColor;
import tstool.layout.History;
//import tstool.layout.UI;
import tstool.process.Process.ProcessContructor;

/**
 * ...
 * @author
 */
class Action extends Process
{

	var _buttonTxt(default, set):String = Main.tongue.get("$defaultBtn_UI2","meta");
	var _nextProcesses:Array<Process> = [];
	var _nextClassProcesses:Array<ProcessContructor> = [];
	var btn:FlxButton;

	override public function create():Void
	{
		_buttonTxt = translate( _buttonTxt, "MID-BTN" );
		super.create();

		btn = new FlxButton(0, 0, _buttonTxt, onClick);
		registerButton(btn);
		btn.loadGraphic("assets/images/ui/down.png", true, 50, 40);
		btn.setGraphicSize(50);
		var ptNo:FlxPoint = new FlxPoint( 0, -_padding);
		btn.labelOffsets = [ptNo, ptNo, ptNo];
		btn.labelAlphas = [1, 1, 1];
		btn.label.setFormat(UI.INTERACTION_FMT.font, UI.INTERACTION_FMT.size);
		btn.label.wordWrap = false;
		btn.label.autoSize = true;
		btn.updateHitbox();
		add(btn);
		positionThis();
		setStyle();
		setStyle();
	}
	function positionThis(?offSet:FlxPoint)
	{
		positionMain( [btn], offSet );
	}
	override public function setStyle()
	{
		super.setStyle();
		btn.label.color = UI.THEME.interaction;
	}
	public function onClick():Void
	{
		pushToHistory(_buttonTxt, Interactions.Next);
		moveToNextClassProcess(Interactions.Next);
		
		/*
		if (this._nextProcesses.length > 0) // @todo 
		{
			move_to_next(_nextProcesses, Interactions.Next);
		}
		else if (this._nexts.length > 0)
		{
			moveToNextClassProcess(Interactions.Next);
		}*/
	}

	override public function update(elapsed:Float):Void
	{
		if ( FlxG.keys.justReleased.RIGHT || FlxG.keys.justReleased.DOWN )
		{
			onClick();
		}
		super.update(elapsed);
	}
	function set__buttonTxt(value:String):String
	{
		return _buttonTxt = value;
	}

}