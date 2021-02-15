package tstool.process;
import flixel.math.FlxPoint;
import tstool.layout.History.Interactions;
import tstool.layout.IPositionable;
import tstool.layout.RadioTitle;

/**
 * ...
 * @author bb
 */
typedef RadioDef = {
	var title:String;
	var values:Array<String>;
	var ?labels:Array<String>;
	var ?buddy:IPositionable; //@todo
	var ?position:Array<Direction>;
}
class ActionRadios extends Action 
{
	var status:Map<String,String>;
	var positions:Map<RadioTitle,RadioDef>;
	var rds:Array<RadioTitle>;
	var radios:Array<RadioDef>;
	var radiosMap:Map<String, RadioTitle>;
	static inline var RADIO_PADDING:Int = 4;
	
	public function new( radios:Array<RadioDef> ) 
	{
		super();
		this.radios = radios;
		status = [];
		this.rds = [];
		this.radiosMap = [];
		positions = [];
	}
	override public function create()
	{
		//var p:FlxPoint = new FlxPoint(0, 0);
		var r:RadioTitle;
		//var most:Rectangle = new Rectangle(0, 0,0,0);
		for (i in radios)
		{
			//r = new RadioTitle(i.title, i.values, status);
			r = new RadioTitle(i.title, i.values, i.labels);
			//trace(r.boundingRect.x + r.boundingRect.width > p.x);
			r.changeSignal.add(changeListener);
			rds.push( r );
			positions.set(r, i);
			radiosMap.set(i.title, r);
			
		}
		super.create();
		var dir:Array<Direction>;
		var buddy:IPositionable;
		for (i in 0...rds.length)
		{
			add(rds[i]);
			dir = positions.get(rds[i]).position;
			buddy = positions.get(rds[i]).buddy;
			if (i == 0 )
			{
				//rds[i].positionMe( buddy == null ? this.question.boundingRect : buddy.boundingRect, 4 , dir);
				rds[i].positionMe( this.question.boundingRect, RADIO_PADDING , [bottom,left]);
			}else{
				rds[i].positionMe(buddy == null ? rds[i-1].boundingRect:buddy.boundingRect , RADIO_PADDING ,dir == null ?[top,right]:dir);
			}
		}
		position();

	}
	inline function position()
	{
		var p:FlxPoint = new FlxPoint(0, 0);
		var rd:RadioTitle;
		for (i in 0...rds.length)
		{
			rd = rds[i];
			if (rd.boundingRect.x + rd.boundingRect.width > p.x) {
				p.x = rd.boundingRect.x + rd.boundingRect.width;
			}
			if (rd.boundingRect.y + rd.boundingRect.height > p.y) {
				p.y = rd.boundingRect.y + rd.boundingRect.height;
			}
		}
		//trace(p);
		p.y = p.y + (RADIO_PADDING*3);
		positionButtons(p);
		positionBottom(p);
	}
	function changeListener(radioID:String, value:String)
	{
		//trace("tstool.process.ActionRadios::changeListener::radioID, value", radioID, value );
		status.set(radioID, value);
	}
	public function validate() 
	{
		for (i in rds)
		{
			//trace(i.titleUI.text, status.get(i.titleUI.text));
			if (status.get(i.titleUI.text) == null || status.get(i.titleUI.text) == "") {
				
				i.blink(true);
				return false;
			}
		}
		return true;
	}
	override public function setStyle()
	{
		super.setStyle();
		for (i in rds)
		{
			i.setStyle();
		}
	}
	override function pushToHistory( buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null)
	{
		super.pushToHistory( buttonTxt, interactionType, status);
	}
}