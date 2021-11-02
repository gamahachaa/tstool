package tstool.process;
//import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.StrNameLabel;
import tstool.layout.History.Interactions;
import tstool.ui.FlxDDown;

/**
 * ...
 * @author bb
 */
class DescisionDropDown extends Descision 
{
	var dp:FlxDDown;
	var choice:String;
	var choiceList:Array<StrNameLabel>;
	static inline var CHOICE:String = "choice";
	var header:String;
	var size:Int;
	public function new(choices:Array<StrNameLabel>) 
	{
		super();
		choiceList = choices;
		/**
		 * @todo add translation
		 */
		
	}
	override public function create()
	{
		choice = "";
		super.create();
		//var h = new FlxUIDropDownHeader(this.size); 
		//h.text = new FlxUIText(0, 0, this.size, this.header) ;
		dp = new FlxDDown(this._padding, this.question.y + this.question.height + _padding, choiceList, function(e){  choice = e; });
		add( dp );
		
	}
	override public function onYesClick()
	{
		if (validateYes())
		{
			//pushToHistory(this._buttonYesTxt, Yes, [CHOICE=>choice]);
			super.onYesClick();
		}
		else{
			dp.blink(true);
		}
		
	}
	override public function onNoClick()
	{
		if (validateNo())
		{
			//pushToHistory(this._buttonNoTxt, No, [CHOICE=>choice]);
			super.onNoClick();
		}
		else{
			dp.blink(true);
		}
		
	}
	override function pushToHistory( buttonTxt:String, interactionType:tstool.layout.History.Interactions,?values:Map<String,Dynamic>=null)
	{
		super.pushToHistory( buttonTxt, interactionType, [CHOICE => choice]);
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