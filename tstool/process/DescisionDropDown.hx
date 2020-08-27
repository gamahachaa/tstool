package tstool.process;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.StrNameLabel;
import tstool.layout.History.Interactions;

/**
 * ...
 * @author bb
 */
class DescisionDropDown extends Descision 
{
	var dp:FlxUIDropDownMenu;
	var choice:String;
	var choiceList:Array<StrNameLabel>;
	public function new(choices:Array<StrNameLabel>) 
	{
		super();
		choiceList = choices;
		choice = "";
	}
	override public function create()
	{
		
		super.create();
		dp = new FlxUIDropDownMenu(this._padding, this.question.y + this.question.height + _padding, choiceList, function(e){  choice = e; });
		add( dp );
	}
	override public function pushToHistory(buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null):Void
	{
		super.pushToHistory("", Next, ["choice"=>choice]);
	}
	override public function onYesClick()
	{
		if (choice != "")
		{
			super.onYesClick();
		}
		
	}
}