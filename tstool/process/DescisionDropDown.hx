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
		
	}
	override public function create()
	{
		choice = "";
		super.create();
		dp = new FlxUIDropDownMenu(this._padding, this.question.y + this.question.height + _padding, choiceList, function(e){  choice = e; });
		add( dp );
	}
	override public function onYesClick()
	{
		if (validateYes())
		{
			pushToHistory(this._buttonYesTxt, Yes, ["choice"=>choice]);
			super.onYesClick();
		}
		
	}
	override public function onNoClick()
	{
		if (validateNo())
		{
			pushToHistory(this._buttonNoTxt, No, ["choice"=>choice]);
			super.onNoClick();
		}
		
	}
	/**
	 * Override to skip validation
	 * @return
	 */
	function validateYes():Bool
	{
		return validate();
	}
	/**
	 * Override to skip validation
	 * @return
	 */
	function validateNo():Bool
	{
		return validate();
	}
	function validate():Bool
	{
		return StringTools.trim(choice) != "";
	}
}