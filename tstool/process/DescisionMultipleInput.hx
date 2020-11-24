package tstool.process;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxSignal.FlxTypedSignal;
import tstool.layout.History.Interactions;
import tstool.layout.UIInputTfCore;
import tstool.process.MultipleInput;

/**
 * @todo factorise all multiple input redundancy
 * @author bb
 */
class DescisionMultipleInput extends Descision
{
	
	var inputs:Array<tstool.process.MultipleInput.ValidatedInputs>;
	var multipleInputs:MultipleInput;


	public var yesValidatedSignal(get, null):FlxTypedSignal<Bool->Void>;
	public var noValidatedSignal(get, null):FlxTypedSignal<Bool->Void>;
	public function new(inputs:Array<tstool.process.MultipleInput.ValidatedInputs>)
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
	override function positionThis(?offSet:FlxPoint)
	{
		super.positionThis();
		var p = multipleInputs.positionThis();
		positionBottom(p);
		positionButtons(p);
	}
	override function pushToHistory( buttonTxt:String, interactionType:tstool.layout.History.Interactions,?values:Map<String,Dynamic>=null)
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
	public function validateYes():Bool
	{
		return validate(Yes);
	}
	/**
	 * Override by final child if need different behaviour based on the fields content
	 */
	public function validateNo():Bool
	{
		return validate(No);
	}
	function validate(interaction:Interactions):Bool
	{
		//#if debug
		//trace("DescisionMultipleInput.validate");
		//return true;
		//#else
		var inp:UIInputTfCore = null;
		for ( i in this.inputs)
		{
			#if debug
			//trace(i);
			#end
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

}