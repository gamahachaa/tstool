package tstool.process;
import flixel.FlxG;
import tstool.layout.History;
//import flixel.effects.FlxFlicker;
import flixel.util.FlxSignal.FlxTypedSignal;
import tstool.layout.UIInputTfCore;
import tstool.process.MultipleInput.ValidatedInputs;
//import flixel.util.FlxSignal.FlxTypedSignal;
import tstool.layout.History.Interactions;
//import layout.UIInputTf;
import tstool.process.MultipleInput;

/**
 * ...
 * @author bb
 */
class DescisionMultipleInput extends Descision
{
	//var yesValidator:EReg;
	//var noValidator:EReg;
	//var singleInput:process.SingleInput;
	//var textFieldWidth:Int;
	//var inputPrefix:String;
	// new
	var inputs:Array<ValidatedInputs>;
	var multipleInputs:MultipleInput;
	//var itetateme:Iterator<UIInputTfCore>;
	//var _focus:UIInputTfCore;

	public var yesValidatedSignal(get, null):FlxTypedSignal<Bool->Void>;
	public var noValidatedSignal(get, null):FlxTypedSignal<Bool->Void>;
	public function new(inputs:Array<ValidatedInputs>)
	{
		super();
		this.inputs = inputs;
		yesValidatedSignal = new FlxTypedSignal<Bool->Void>();
		noValidatedSignal = new FlxTypedSignal<Bool->Void>();

	}
	override public function create( ):Void
	{

		multipleInputs = new MultipleInput(this, [for (i in inputs) i.input]);
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
	override public function onYesClick():Void
	{
		//#if debug
		////super.onYesClick(); // test only
		//trace("DescisionMultipleInput.onYesClick");
		//#end
		if (validateYes())
		{
			yesValidatedSignal.dispatch(true);
			super.onYesClick();
		}
		else
			yesValidatedSignal.dispatch(false);
		//#end
	}
	override public function onNoClick():Void
	{
		//#if debug
		//super.onNoClick(); // test only
		//#end
		if (validateNo())
		{
			noValidatedSignal.dispatch(true);
			super.onNoClick();
		}
		else
			noValidatedSignal.dispatch(false);
		//#end
	}
	override function positionThis()
	{
		super.positionThis();
		multipleInputs.positionThis();
	}
	override function pushToHistory( buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null)
	{
		super.pushToHistory( buttonTxt, interactionType, [for (k=>v in multipleInputs.inputs) k => v.getInputedText()]);
	}
	override public function destroy()
	{
		super.destroy();
	}
	/**
	 * Override by final child if need different behaviour based on the fields content
	 */
	function validateYes()
	{
		return validate();
	}
	/**
	 * Override by final child if need different behaviour based on the fields content
	 */
	function validateNo()
	{
		return validate();
	}
	function validate()
	{
		#if debug
		trace("DescisionMultipleInput.validate");
		#end
		var inp:UIInputTfCore = null;
		for ( i in this.inputs)
		{
			#if debug
			trace(i);
			#end
			if (i.ereg == null) continue;
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

}