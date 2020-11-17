package tstool.process;
import tstool.layout.History;
import flixel.FlxG;
import flixel.util.FlxSignal.FlxTypedSignal;
import tstool.layout.History.Interactions;
import tstool.layout.UIInputTfCore;
import tstool.process.MultipleInput.ValidatedInputs;

/**
 * @todo factorise all multiple inputredundancy
 * ...
 * @author bb
 */
class TripletMultipleInput extends Triplet 
{
	//var yesValidator:EReg;
	//var noValidator:EReg;
	//var midValidator:EReg;
	//
	//var singleInput:process.SingleInput;
	//var textFieldWidth:Int;
	//var inputPrefix:String;
	
	var inputs:Array<ValidatedInputs>;
	var multipleInputs:MultipleInput;
	//var itetateme:Iterator<UIInputTfCore>;
	//var _focus:UIInputTfCore;
	
	public var yesValidatedSignal(get, null):FlxTypedSignal<Bool->Void>;
	public var noValidatedSignal(get, null):FlxTypedSignal<Bool->Void>;
	public var midValidatedSignal(get, null):FlxTypedSignal<Bool->Void>;
	
	public function new(inputs:Array<ValidatedInputs>) 
	{
		super();
		this.inputs = inputs;
		yesValidatedSignal = new FlxTypedSignal<Bool->Void>();
		noValidatedSignal = new FlxTypedSignal<Bool->Void>();
		midValidatedSignal = new FlxTypedSignal<Bool->Void>();
		//_focus == null;
	}
	override public function create( ):Void
	{
		multipleInputs = new MultipleInput(this, [for (i in inputs) i.input]);
		//itetateme = multipleInputs.inputs.iterator();
		super.create();
	}
	override public function update(elapsed)
	{
	
		super.update(elapsed);

		if ( FlxG.keys.justReleased.TAB)
		{
			multipleInputs.getNextFocus();
		}
		else if (FlxG.keys.justReleased.BACKSPACE)
		{
			//_focus.clearText();
			multipleInputs.clearFocusText();
		}
		else if (multipleInputs.focus == null)
		{
			multipleInputs.getNextFocus();
			//FlxG.stage.focus = _focus.inputtextfield;
		}
	
	}
	override public function setStyle()
	{
		super.setStyle();
		multipleInputs.setStyle();
	}
	override function positionThis()
	{
		super.positionThis();
		//trace(this.question.height);
		var p = multipleInputs.positionThis();
		//positionButtons(p);
		positionBottom(p);
	}
	override function pushToHistory( buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>= null)
	{
		
		super.pushToHistory( buttonTxt, interactionType, values== null ? [for (k=>v in multipleInputs.inputs) k => v.getInputedText()]: values);
	}
	override public function onYesClick():Void
	{
		if (validateYes())
		{
			super.onYesClick();
		}
	}
	override public function onNoClick():Void
	{
		//#if debug
		//super.onNoClick(); // test only
		//#else
		if (validateNo())
		{
			super.onNoClick();
		}
		
		//#end
	}
	override public function onMidClick():Void
	{
		//#if debug
		//super.onMidClick(); // test only
		//#else
		if (validateMid())
		{
			super.onMidClick();
		}
		
		//#end
	}
/**
	 * Override by final child if need different behaviour based on the fields content
	 */
	function validateYes()
	{
		return validate(Yes);
	}
	/**
	 * Override by final child if need different behaviour based on the fields content
	 */
	function validateNo()
	{
		return validate(No);
	}
	/**
	 * Override by final child if need different behaviour based on the fields content
	 */
	function validateMid()
	{
		return validate(Mid);
	}
	function validate(interaction:Interactions)
	{
		var inp:UIInputTfCore = null;
		for ( i in this.inputs)
		{
			//trace(i);
			if (i.ereg == null) continue;
			if (i.input.mustValidate != null && i.input.mustValidate.indexOf(interaction) == -1) continue;
			inp = this.multipleInputs.inputs.get(i.input.prefix);
			if (!i.ereg.match(inp.getInputedText()))
			{
				inp.blink(true);
				return false;
			}
		}
		return true;
	}
	
	function get_yesValidatedSignal():FlxTypedSignal<Bool->Void> 
	{
		return yesValidatedSignal;
	}
	
	function get_noValidatedSignal():FlxTypedSignal<Bool->Void> 
	{
		return noValidatedSignal;
	}
	
	function get_midValidatedSignal():FlxTypedSignal<Bool->Void> 
	{
		return midValidatedSignal;
	}
	
	//function validateNo()
	//{
		//if (!noValidator.match(singleInput.uiInput.getInputedText()))
		//{
			//singleInput.uiInput._labelValidator = Main.tongue.get("$" + this._name + "_NO", "validators");
			//singleInput.uiInput.blink(true);
			//return false;
		//}
		//return true;
	//}
}