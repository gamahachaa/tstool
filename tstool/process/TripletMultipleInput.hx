package tstool.process;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxSignal.FlxTypedSignal;
import tstool.layout.History.Interactions;
import tstool.layout.UIInputTfCore;
import tstool.process.MultipleInput.ValidatedInputs;

/**
 * @todo factorise all multiple input redundancy
 * ...
 * @author bb
 */
class TripletMultipleInput extends Triplet 
{

	
	var inputs:Array<ValidatedInputs>;
	var multipleInputs:MultipleInput;

	
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
		for (j in inputs)
		{
			if ( j.hasTranslation != null && j.hasTranslation) j.input.titleTranslated = translate(this._name, j.input.prefix, "headers");
		}
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
	override function positionThis(?offSet:FlxPoint)
	{
		super.positionThis(offSet);
		var p = multipleInputs.positionThis();
		positionBottom(p);
		positionButtons(p);
	}
	override function pushToHistory( buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>= null)
	{
		
		super.pushToHistory( buttonTxt, interactionType,  [for (k=>v in multipleInputs.inputs) k => v.getInputedText()]);
	}
	override public function onYesClick():Void
	{
		if (validateYes())
		{
			yesValidatedSignal.dispatch(true);
			super.onYesClick();
		}
		else
			yesValidatedSignal.dispatch(false);
	}
	override public function onNoClick():Void
	{
		if (validateNo())
		{
			noValidatedSignal.dispatch(true);
			super.onNoClick();
		}
		else{
			noValidatedSignal.dispatch(false);
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
			midValidatedSignal.dispatch(true);
			super.onMidClick();
		}
		else midValidatedSignal.dispatch(false);
		
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
	function validate(interaction:Interactions):Bool
	{
		var inp:UIInputTfCore = null;
		for ( i in this.inputs)
		{

			if (i.ereg == null) continue;
			if (i.input.mustValidate != null && i.input.mustValidate.indexOf(interaction) == -1) continue;
			inp = this.multipleInputs.inputs.get(i.input.prefix);
			//trace("tstool.process.DescisionMultipleInput::validate::inp", inp );
			if (!i.ereg.match(StringTools.trim(inp.getInputedText())))
			{
				inp.blink(true);
				return false;
			}
		}
		return true;
		//#end
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
}