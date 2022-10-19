package tstool.process;
import flixel.math.FlxPoint;
import tstool.layout.History.Interactions;
import tstool.layout.IPositionable;
import tstool.layout.RadioTitle;
import lime.math.Rectangle;

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
	var ?titleTranslation:String;
	var ?hasTranslation:Bool;
	var ?widthMultiplier:Float;
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
		var labels : Array<String> = null;
		//var most:Rectangle = new Rectangle(0, 0,0,0);
		for (i in radios)
		{
			if (i.hasTranslation != null && i.hasTranslation == true)
			{
				i.titleTranslation = MainApp.translator.translate(_name, this._name, i.title, "headers");
				labels = [];
				for (j in i.values)
				{
					//#if debug
					//trace('tstool.process.ActionRadios::create::j ${j}');
					//#end
					labels.push(MainApp.translator.translate(_name,this._name, j, "headers"));
				}
			}
			
			r = new RadioTitle(i.title, i.values, labels, i.titleTranslation, null, i.widthMultiplier);
			//trace(r.boundingRect.x + r.boundingRect.width > p.x);
			r.changeSignal.add(changeListener);
			rds.push( r );
			positions.set(r, i);
			radiosMap.set(i.title, r);
			
		}
		super.create();
		var dir:Array<Direction>;
		var buddy:IPositionable;
		var bdRect:Rectangle = null;
		for (i in 0...rds.length)
		{
			add(rds[i]);
			dir = positions.get(rds[i]).position;
			buddy = positions.get(rds[i]).buddy;
			
			if (i == 0 )
			{
				
				//rds[i].positionMe( buddy == null ? this.question.boundingRect : buddy.boundingRect, 4 , dir);
				rds[i].positionMe( this.question.boundingRect, 0 , [bottom,left]);
			}else{
				
				bdRect = buddy == null ? rds[i - 1].boundingRect:buddy.boundingRect;
				#if debug
				//trace("tstool.process.ActionRadios::create::bdRect", bdRect );
				#end
				//rds[i].positionMe(buddy == null ? rds[i-1].boundingRect:buddy.boundingRect , RADIO_PADDING ,dir == null ?[top,right]:dir);
				rds[i].positionMe(bdRect , 0 ,dir == null ?[top,right]:dir);
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
			#if debug
			//trace("tstool.process.ActionRadios::position::rd.boundingRect", rd.boundingRect );
			#end
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
			//if (status.get(i.titleUI.text) == null || status.get(i.titleUI.text) == "") {
			if (status.get(i._title) == null || status.get(i._title) == "") {
				
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