package tstool.process;
import flixel.FlxG;
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
	var mustBeTrue:Array<String>;
	var mustBeFalse:Array<String>;
	var skip:Array<String>;
    public var ckMap:Map<String,BBCheckBox>;
    public var status:Map<String,Bool>;
	public function new(cks:Array<String>, mustBeTrue:Array<String>, mustBeFalse:Array<String>,skipValidation:Array<String>,  ?checkWidth:Int=400) 
	{
		super();
		this.checkWidth = checkWidth;
		this.cks = cks;
		this.mustBeTrue = mustBeTrue;
		this.mustBeFalse = mustBeFalse;
		this.skip = skipValidation;
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
			var ck:BBCheckBox = new BBCheckBox(i, this._name, checkWidth +20);
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
	}
	
	function onChecked(id:String, checked:Bool) 
	{
		stopAllBlinking();
		#if debug 
		trace("onChecked", id, checked);
		#end
	}
	public function allChecked()
	{
		var complete = true;
		var wrongs = [];
		for (k=>v in ckMap)
		{
			if (skip.indexOf(k) == -1){
				if (v.checked && mustBeFalse.indexOf(k) > -1 || !v.checked && mustBeTrue.indexOf(k) > -1)
				{
					 complete = false;
					wrongs.push(k); 
				} 
			}
			status.set(k, v.checked);
		}
		for (i in wrongs)
		{
			ckMap.get(i).blink(true );
		}
		#if debug
		trace(status);
		trace(complete);
		#end
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
		return allChecked();
	}
	override function pushToHistory( buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null)
	{
		super.pushToHistory( buttonTxt, interactionType, status);
	}
	function stopAllBlinking()
	{
		for (i in ckMap)
		{
			i.blink(false );
		}
	}
}