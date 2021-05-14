package tstool.process;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import tstool.layout.History.Interactions;
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
	var ?hasTranslation:Bool;
}
typedef Input = {
	var ?buddy:String;
	var width:Int;
	var ?inputHeight:Int;
	var prefix:String;
	var ?position:Array<Direction>;
	var ?debug:String;
	var ?mustValidate:Array<Interactions>;
	var ?titleTranslated:String;
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
		//var perv:IPositionable= this.parent.question;
		//var tab = 1;
		for ( i in ins)
		{
			tmp = new UIInputTfCore(Std.int(i.width), i.prefix, i.position, i.titleTranslated);
			//tmp = new UIInputTfCore(Std.int(i.width), parent.translate(parent._name,i.prefix,"headers"), i.position, i.titleTranslated);
			//tmp = new UIInputTfCore(Std.int(i.width), parent.translate(parent._name,i.prefix,"headers"), i.position, i.titleTranslated);
			tmp.addToParent(this.parent);
			#if debug
			tmp.inputtextfield.text = i.debug == null || i.debug == "" ? "":i.debug;
			#end
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
		//#if debug
		//trace("tstool.process.MultipleInput::getNextFocus::tabOrder", tabOrder );
		//#end
		if (focus == null)
		{
			focus = inputs.get(tabOrder[0]);
		}
		else{
			var i = this.tabOrder.indexOf( focus.id );
			//#if debug
			//trace("tstool.process.MultipleInput::getNextFocus::i", i );
			//#end
			if ( i + 1 < tabOrder.length)
			{
				focus = inputs.get(tabOrder[i+1]);
			}
			else{
				focus = inputs.get(tabOrder[0]);
			}
			//#if debug
			//trace("tstool.process.MultipleInput::getNextFocus::focus", focus );
			//#end
		}
		FlxG.stage.focus = focus.inputtextfield;
		return focus;
	}
	
	function onChildFocus(child:UIInputTfCore):Void 
	{
		focus = child;
		//#if debug
			//trace(focus);
		//#end
		FlxG.stage.focus = focus.inputtextfield;
	}
	
	public function showAll(?yes:Bool=true):Void
	{
		for (i in inputs)
		{
			i.show(yes);
		}
	}
	
	public function getText(id:String):String
	{
		return inputs.get(id).getInputedText();
	}
	public function setInputDefault(id:String, text:String):Void
	{
		inputs.get(id).inputtextfield.text = text;
	}
	function get_inputs():Map<String, UIInputTfCore>
	{
		return inputs;
	}
	
	public function positionThis()
	{
		var ui = null;
		var pt :FlxPoint = new FlxPoint(0, 0);
		for ( k => v in positionings)
		{
			ui = inputs.get(k);
			if (v.buddy == "" || v.buddy == null)
			{
				ui.positionMe(this.parent.question.boundingRect);
			}
			else{
				ui.positionMe(inputs.get(v.buddy).boundingRect);
				#if debug
				trace("tstool.process.MultipleInput::positionThis::v.buddy", v.buddy );
				#end
			}
			//trace(ui.x + ui.width, ui.x + ui.width > pt.x);
			if (ui.x + ui.width > pt.x)
			{
				pt.x = ui.x + ui.width ;
			}
			//trace(ui.y + ui.height, ui.y + ui.height > pt.y);
			if (ui.y + ui.height > pt.y)
			{
				pt.y = ui.y + ui.height;
			}
		}
		//trace(pt);
		return pt;
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