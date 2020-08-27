package tstool.process;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import tstool.layout.IPositionable;
import tstool.layout.IPositionable.Direction;
import tstool.layout.UIInputTfCore;
import openfl.events.MouseEvent;
//import layout.UIInputTf;
import lime.math.Rectangle;
/**
 * ...
 * @author bb
 */

typedef ValidatedInputs = {
	var ereg:EReg;
	var input:Input;
}
typedef Input = {
	var ?buddy:String;
	var width:Int;
	var prefix:String;
	var ?position:Array<Direction>;
} 
 
class MultipleInput implements IFlxDestroyable
{
	var parent:Process;
	var tabOrder:Array<String>;
	public var focus(get, null):UIInputTfCore;
	//public var first(get, null): UIInputTfCore;
	public var inputs(get, null): Map<String, UIInputTfCore>;
	public var positionings:Map<String,Input>;

	public function new(parent:Process, ins: Array<Input>) 
	{
		//first = null;
		this.tabOrder = [];
		this.inputs = [];
		this.positionings = [];
		this.parent = parent;
		
		create(ins);
		
	}
	public function create(ins:Array<Input>):Void
	{
		var tmp:UIInputTfCore = null;
		var perv:IPositionable= this.parent.question;
		//var tab = 1;
		for ( i in ins)
		{
			tmp = new UIInputTfCore(Std.int(i.width), i.prefix, i.position);
			tmp.addToParent(this.parent);
			tabOrder.push(i.prefix);
			tmp.focusSignal.add( onChildFocus );
			inputs.set(i.prefix, tmp);
			positionings.set(i.prefix, i);
			
		}
		
	}
	public function clearFocusText()
	{
		if (focus == null) return;
		else focus.clearText();
	}
	public function getNextFocus():UIInputTfCore
	{
		if (focus == null)
		{
			focus = inputs.get(tabOrder[0]);
		}
		else{
			var i = this.tabOrder.indexOf( focus._label );
			if ( i + 1 < tabOrder.length)
			{
				focus = inputs.get(tabOrder[i+1]);
			}
			else{
				focus = inputs.get(tabOrder[0]);
			}
			
		}
		FlxG.stage.focus = focus.inputtextfield;
		return focus;
	}
	
	function onChildFocus(child:UIInputTfCore):Void 
	{
		focus = child;
		#if debug
			//trace(focus);
		#end
		FlxG.stage.focus = focus.inputtextfield;
	}
	
	//function onTfClicked(e:MouseEvent):Void 
	//{
		//#if debug
		//trace(e.currentTarget);
		//#end
	//}
	
	function get_inputs():Map<String, UIInputTfCore>
	{
		return inputs;
	}
	
	public function positionThis()
	{
		var ui = null;
		for ( k => v in positionings)
		{
			ui = inputs.get(k);
			if (v.buddy == "" || v.buddy == null)
			{
				ui.positionMe(this.parent.question.boundingRect);
			}
			else{
				ui.positionMe(inputs.get(v.buddy).boundingRect);
			}
		}
		/*
		var current:UIInputTfCore = inputs.get(tabOrder[0]);
		var tmp:UIInputTfCore = current;
		current.positionMe( new Rectangle(this.parent.question.x, this.parent.question.y, this.parent.question.width, this.parent.question.height), this.parent._padding);
		//trace(tmp.boundingRect);
		//trace(tmp._label);
		for ( i in 1...tabOrder.length)
		{
			
			current = inputs.get(tabOrder[i]);
			#if debug
			trace(current.imputLabel.text);
			trace(current.positionsToParent);
			trace("parent : "+ tmp.imputLabel.text);
			trace(tmp.boundingRect);
			
			#end
			current.positionMe( tmp.boundingRect, this.parent._padding);
			tmp = current;
		}
		*/
	}
	
	//function get_first():UIInputTfCore 
	//{
		//return first;
	//}
	
	public function setStyle()
	{
		for (i in inputs)
		{
			i.setStyle();
		}
		
	}
	
	function get_focus():UIInputTfCore 
	{
		return focus;
	}
	
	public function destroy()
	{
		for (i in this.inputs)
		{
			//tmp.inputtextfield.removeEventListener(MouseEvent.CLICK, onTfClicked);
			
			i.destroy();
		}
	}
}