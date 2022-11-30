package tstool.process;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIText;
import flixel.math.FlxPoint;
import tstool.layout.BBCheckBox;
import tstool.layout.History.Interactions;
//import flixel.text.FlxText;
import tstool.layout.UI;

/**
 * ...
 * @author bb
 */

class ActionCheck extends Action 
{
	var cks:Array<String>;
	var checkWidth:Int;
    public var ckMap:Map<String,BBCheckBox>;
    public var status:Map<String,Bool>;
	public function new(cks:Array<String>, ?checkWidth=null) 
	{
		super();
		this.checkWidth = checkWidth;
		this.cks = cks;
		ckMap = [];
		status = [];
	}
	override public function create():Void 
	{
		super.create();
		var p:FlxPoint = new FlxPoint(this.question.x, this.question.y + this.question.height + _padding);
		//var Y0 = ;
		for (i in cks)
		{
			var ck:BBCheckBox = new BBCheckBox(i, this._name, checkWidth);
			ck.signal.add(onChecked);
			//ck.callback = ()->trace(i, ck.checked);
			ck.x = p.x;
			ck.y = p.y;
			p.y += 32;
			ckMap.set(i, ck);
			status.set(i, false);
			add(ck);
		}
		
		//p.y = Y0;
		p.x = checkWidth; // set it to the width of the check boxes
		positionButtons(p);
		positionBottom(p);
		/*var ck: FlxUICheckBox = new FlxUICheckBox(200, 200, null, null, "", 600, null);
		ck.callback = ()->trace(ck.text, ck.checked);
		
		//ck.textX = 100;
		ck.textY = -8;
		ck.button.setLabelFormat(UI.BASIC_FMT.font, UI.TITLE_FMT.size-4);
		ck.text = "Yo label super nice";
		add(ck);*/
	}
	
	function onChecked(id:String, checked:Bool) 
	{
		#if debug 
		trace("onChecked", id, checked);
		#end
	}
	public function allChecked()
	{
		var missings = [];
		var complete = true;
		for (k=>v in ckMap)
		{
			if (v.checked == false) complete;
			status.set(k, v.checked);
		}
		//trace(status);
		return complete;
	}
	override public function onClick():Void 
	{
		//trace();
		if (validate())
		{
			super.onClick();
		}
		
	}
	/**
	 * ovrride me
	 */
	function validate() 
	{
		return !allChecked();
	}
	override function pushToHistory( buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null)
	{
		super.pushToHistory( buttonTxt, interactionType, status);
	}
}