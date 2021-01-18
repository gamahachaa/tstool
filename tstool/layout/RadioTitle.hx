package tstool.layout;
//import flixel.FlxObject;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxSignal.FlxTypedSignal;
import lime.math.Rectangle;
import tstool.layout.IPositionable.Direction;

/**
 * ...
 * @author bb
 */
class RadioTitle extends FlxGroup implements IPositionable
{
	static inline var TITLE_SIZE = 14;
	static inline var RADIO_SIZE = 12;
	public var changeSignal:FlxTypedSignal<String->String->Void>;
	public var boundingRect(get, null):Rectangle;
	public var titleUI:FlxText;
	
	@:isVar public var rd(get, set):FlxUIRadioGroup;
	var padding:Int;
	//var status:Map<String, String>;
	var pt:FlxPoint;
	var width:Int;
	
	public function new(title:String, ids:Array<String>, ?labels:Array<String>, ?padding:Int = 20) 
	{
		super();
		width = setWidth(title, labels==null?ids:labels);
		changeSignal = new FlxTypedSignal<String->String->Void>();
		pt = new FlxPoint(0, 0);
		//this.status = status;
		this.padding = padding;
		titleUI = new FlxText(0, 0, width , title, TITLE_SIZE);
		rd = new FlxUIRadioGroup(0, 0, ids, labels==null?ids:labels, callback, 20, width, 25, width);
		rd.set_width(width);
		updateRadioText();
		this.boundingRect = new Rectangle();
		this.add(titleUI);
		this.add(rd);
	}
	public function updateRadioText()
	{
		
		for (i in rd.getRadios())
		{
			//var pt = FlxPoint.get(0, -RADIO_SIZE/2);
			i.button.label.size = RADIO_SIZE;
			//i.button.label.y = i.button.label.y -(RADIO_SIZE*3);
			//i.button.labelOffsets = [pt,pt,pt];
			//pt.put();
		}
		
	}
	public function positionMe(parent:Rectangle, ?padding:Int = 4, ?positionsToParent:Array<Direction> = null):FlxPoint
	{
		var d:Array<Direction> = positionsToParent==null ? [bottom, left]: positionsToParent;
		var p = parent;
		switch (d[0])
		{
			case bottom:
				titleUI.x  = p.x + (d[1] == right ? p.width + padding : 0);
				titleUI.y = p.y + p.height /*+ (padding / 4)*/;
				
			case top :
				titleUI.x  = p.x + (d[1] == right ? p.width + padding: 0);
				titleUI.y = p.y;
				
			case left:
				titleUI.x  =  p.x ;
				titleUI.y =  p.y + (d[1] == top ? 0 : p.height + padding) ;
			case right:
				titleUI.x  = p.x + p.width + padding;
				titleUI.y =  p.y + (d[1] == top ? 0 : p.height + padding );

		}
		rd.x = titleUI.x;
		rd.y = titleUI.y + titleUI.height + (padding/4);
		
		this.boundingRect.x = titleUI.x;
		this.boundingRect.y = titleUI.y;
		this.boundingRect.width = Math.max (titleUI.width, rd.width);
		this.boundingRect.height = Math.max (titleUI.height, rd.height);
		pt.x = boundingRect.x + boundingRect.width;
		pt.y = boundingRect.y + boundingRect.height;
		return pt;
	}
	
	public function blink( start:Bool )
	{
		if (start)
		{
			FlxFlicker.flicker( titleUI, 0, .3);
		}
		else
		{
			FlxFlicker.stopFlickering(titleUI);
		}

	}
	public function setStyle()
	{
		this.titleUI.color = UI.THEME.meta;
		for (i in rd.getRadios())
		{
			i.button.label.color = UI.THEME.interaction;
			i.button.down_color = UI.THEME.interaction;
			i.button.up_color = UI.THEME.interaction;
			i.button.over_color = UI.THEME.meta;
		}
	}
	function setWidth( s:String, a:Array<String>)
	{
		//trace(s.length);
		var w = s.length > TITLE_SIZE ? s.length * TITLE_SIZE: 110;
		for(i in a)
		{
			if (i.length * RADIO_SIZE > w) w = i.length * RADIO_SIZE;
		}
		//trace(w);
		return w;
	}
	function get_boundingRect():Rectangle 
	{
		return boundingRect;
	}
	
	function callback(s:String)
	{
		blink(false);
		changeSignal.dispatch(this.titleUI.text, s);
	}
	
	function get_rd():FlxUIRadioGroup 
	{
		return rd;
	}
	
	function set_rd(value:FlxUIRadioGroup):FlxUIRadioGroup 
	{
		return rd = value;
	}
}