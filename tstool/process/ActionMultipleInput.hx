package tstool.process;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxSignal.FlxTypedSignal;
import tstool.layout.UIInputTfCore;
import tstool.layout.History.Interactions;
import tstool.process.MultipleInput.ValidatedInputs;
//import openfl.events.Event;
//import layout.UIInputTf;

/**
 *  @todo factorise all multiple input redundancy
 * @author bb
 */

class ActionMultipleInput extends Action 
{
	var inputs:Array<ValidatedInputs>;
	var multipleInputs:MultipleInput;
	
	public var nextValidatedSignal(get, null):FlxTypedSignal<Bool->Void>;//keep
	
	public function new(inputs:Array<ValidatedInputs>) 
	{
		super();
		this.inputs = inputs;
		nextValidatedSignal = new FlxTypedSignal<Bool->Void>();//keep
	}
	//keep
	override public function onClick():Void
	{
		if (validate(Next))
		{
			nextValidatedSignal.dispatch(true);
			super.onClick();
		}
		else
			nextValidatedSignal.dispatch(false);

	}
	function get_nextValidatedSignal():FlxTypedSignal<Bool->Void> 
	{
		return nextValidatedSignal;
	}
	////////////////////////////////////////////////////////////////////
	override public function create( ):Void
	{
		/**/
		for (j in inputs)
		{
			if ( j.hasTranslation!=null && j.hasTranslation) j.input.titleTranslated = translate(this._name, j.input.prefix, "headers");
		}
		/**/
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
		else if(multipleInputs.focus == null){
			multipleInputs.getNextFocus();
		}
	}
	
	override function positionThis(?offSet:FlxPoint)
	{
		super.positionThis();
		var p = multipleInputs.positionThis();
		positionButtons(p);
		positionBottom(p);

	}
	override public function setStyle()
	{
		super.setStyle();
		multipleInputs.setStyle();
	}
	override public function pushToHistory(buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null):Void
	{
		super.pushToHistory(buttonTxt, interactionType, values==null?[for (k=>v in multipleInputs.inputs) k => v.getInputedText()]:values);
	}
	
	
	
	function validate(?interaction:Interactions=Next)
	{
		var inp:UIInputTfCore = null;
		for ( i in this.inputs)
		{
			//trace(i);
			
			if (i.ereg == null) continue;
			if (i.input.mustValidate != null && i.input.mustValidate.indexOf(interaction) == -1) continue;
			inp = this.multipleInputs.inputs.get(i.input.prefix);
			inp.blink(false);
			if (!i.ereg.match(inp.getInputedText()))
			{
				inp.blink(true);
				return false;
			}
		}
		return true;
	}
}