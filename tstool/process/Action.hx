package tstool.process;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import tstool.layout.History;
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
	public function new()
	{
		super();
		_buttonTxt = translate( _buttonTxt, "MID-BTN" );
	}
	override public function create():Void
	{
		super.create();

		btn = new FlxButton(0, 0, _buttonTxt, onClick);
		registerButton(btn);
		btn.loadGraphic("assets/images/ui/down.png", true, 50, 40);
		btn.setGraphicSize(50);
		var ptNo:FlxPoint = new FlxPoint( 0, -_padding);
		btn.labelOffsets = [ptNo, ptNo, ptNo];
		btn.labelAlphas = [1, 1, 1];
		btn.label.setFormat(Main.INTERACTION_FMT.font, Main.INTERACTION_FMT.size);
		btn.label.wordWrap = false;
		btn.label.autoSize = true;
		btn.updateHitbox();
		add(btn);
		positionThis();
	}
	function positionThis(?offSet:FlxPoint)
	{
		
		positionMain( [btn], offSet );
		//btn.x =  2*FlxG.width / 3 + _padding;
		//btn.y = this.question.y + this.question.height + _padding ;

		//btn.y = (this.illustration == null ? this.details.y + this.details.height :  Math.max( this.details.y + this.details.height, this.illustration.y + this.illustration.height)) + _padding;
		//btn.x = FlxG.width /2;

	}
	override public function setStyle()
	{
		super.setStyle();
		btn.label.color = Main.THEME.interaction;
	}
	public function onClick():Void
	{
		pushToHistory(_buttonTxt, Interactions.Next);
		
		if (this._nextProcesses.length > 0) // @todo 
		{
			/**
			 * @todo  REMOVE ONCE CLAss refactor is cleared
			 */
			move_to_next(_nextProcesses, Interactions.Next);
		}
		else if (this._nexts.length > 0)
		{
			moveToNextClassProcess(Interactions.Next);
		}
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