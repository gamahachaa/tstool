package tstool.process;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxSignal.FlxTypedSignal;
import tstool.layout.History.Interactions;
import tstool.layout.UIInputTfCore;
import tstool.process.MultipleInput.ValidatedInputs;
import tstool.process.Process.ProcessContructor;

/**
 * @todo refactor to avoid duplication of code with othe Multiple inputs using a decorator
 * @author bb
 */
class DescisionMultipleInputLoop extends DescisionLoop 
{
	var inputs:Array<ValidatedInputs>;
	var multipleInputs:MultipleInput;

	public function new(
		inputs:Array<ValidatedInputs>, 
		?yesProcess:ProcessContructor, 
		?noProcess:ProcessContructor) 
	{
		super(yesProcess, noProcess);
		this.inputs = inputs;
		//yesValidatedSignal = new FlxTypedSignal<Bool->Void>();//keep
		//noValidatedSignal = new FlxTypedSignal<Bool->Void>();//keep
	}
	override public function onYesClick():Void
	{
		if (validateYes())
		{
			//yesValidatedSignal.dispatch(true);
			super.onYesClick();
		}
		else {}
			//yesValidatedSignal.dispatch(false);
		//#end
	}
	override public function onNoClick():Void
	{
		if (validateNo())
		{
			//noValidatedSignal.dispatch(true);
			super.onNoClick();
		}
		else{
			//noValidatedSignal.dispatch(false);
		}
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
	/*function get_yesValidatedSignal():FlxTypedSignal<Bool->Void>
	{
		return yesValidatedSignal;
	}

	function get_noValidatedSignal():FlxTypedSignal<Bool->Void>
	{
		return noValidatedSignal;
	}*/
	//////////////////////////////
	override public function create( ):Void
	{
		for (j in inputs)
		{
			if ( j.hasTranslation != null && j.hasTranslation) j.input.titleTranslated = MainApp.translator.translate(_name,this._name, j.input.prefix, "headers");
		}
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
			multipleInputs.clearFocusText();
		}
		else if (multipleInputs.focus == null)
		{
			multipleInputs.getNextFocus();
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
	override function pushToHistory( buttonTxt:String, interactionType:tstool.layout.History.Interactions,?values:Map<String,Dynamic>=null)
	{
		super.pushToHistory( buttonTxt, interactionType, [for (k=>v in multipleInputs.inputs) k => v.getInputedText()]);
	}
	override public function destroy()
	{
		super.destroy();
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
	
}