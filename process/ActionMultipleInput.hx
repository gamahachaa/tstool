package tstool.process;
import flixel.FlxG;
import flixel.util.FlxSignal.FlxTypedSignal;
import tstool.layout.UIInputTfCore;
import tstool.layout.History.Interactions;
import tstool.process.MultipleInput.ValidatedInputs;
//import openfl.events.Event;
//import layout.UIInputTf;

/**
 * ...
 * @author bb
 */

class ActionMultipleInput extends Action 
{
	var inputs:Array<ValidatedInputs>;
	var multipleInputs:MultipleInput;
	public var nextValidatedSignal(get, null):FlxTypedSignal<Bool->Void>;
	
	public function new(inputs:Array<ValidatedInputs>) 
	{
		super();
		this.inputs = inputs;
		
		nextValidatedSignal = new FlxTypedSignal<Bool->Void>();
		//_focus == null;
	}
	override public function create( ):Void
	{
		multipleInputs = new MultipleInput(this, [for (i in inputs) i.input]);
		//itetateme = multipleInputs.inputs.iterator();
		
		super.create();
		//multipleInputs.getNextFocus();
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
	override public function onClick():Void
	{
		if (validate())
		{
			nextValidatedSignal.dispatch(true);
			super.onClick();
		}
		else
			nextValidatedSignal.dispatch(false);

	}
	override function positionThis()
	{
		super.positionThis();
		multipleInputs.positionThis();

	}
	override public function setStyle()
	{
		super.setStyle();
		multipleInputs.setStyle();
	}
	override public function pushToHistory(buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null):Void
	{
		super.pushToHistory("", interactionType, [for (k=>v in multipleInputs.inputs) k => v.getInputedText()]);
	}
	
	function get_nextValidatedSignal():FlxTypedSignal<Bool->Void> 
	{
		return nextValidatedSignal;
	}
	
	function validate()
	{
		var inp:UIInputTfCore = null;
		for ( i in this.inputs)
		{
			//trace(i);
			
			if (i.ereg == null) continue;
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