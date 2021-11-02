package tstool.layout;
//import flixel.FlxObject;
import flixel.FlxG;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxSignal.FlxTypedSignal;
import lime.math.Rectangle;
import tstool.layout.IPositionable.Direction;
using StringTools;
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
	public var _title(get, null):String;
	var _titleTranslated:String;
	var widthMultiplier:Float;
	
	public function new(title:String, ids:Array<String>, ?labels:Array<String>, ?titleTranslated:String="", ?padding:Int = 20, ?widthMultiplier:Float=1.5) 
	{
		super();
		this.widthMultiplier = widthMultiplier;
		this._title = title.trim();
		this._titleTranslated =  titleTranslated=="" ? _title : titleTranslated.trim();
		
		width = Std.int( setWidth( _titleTranslated , labels == null?ids:labels));
		
		changeSignal = new FlxTypedSignal<String->String->Void>();
		pt = new FlxPoint(0, 0);
		//this.status = status;
		this.padding = padding;
		titleUI = new FlxText(0, 0, width , _titleTranslated, TITLE_SIZE);
		var titleSize = titleUI.textField.getLineMetrics(0).width;
		rd = new FlxUIRadioGroup(0, 0, ids, labels == null ? ids : labels, callback, 20, width, 25, width);
		/*var radios = rd.getRadios();
		var mx_min:Float = 0;
		var tmp = mx_min;
		for (r in radios)
		{
			tmp = r.button.label.textField.getLineMetrics(0).width;
			mx_min = (tmp > mx_min) ? tmp: mx_min;
			//trace(r.button.label.textField.getLineMetrics(0));
		}*/
		
		//rd.set_width(Math.max(titleSize, mx_min));
		updateRadioText();
		this.boundingRect = new Rectangle();
		this.add(titleUI);
		this.add(rd);
	}
	public inline function updateRadioText()
	{
		
		for (i in rd.getRadios())
		{
			i.button.label.size = RADIO_SIZE;
		}
		
	}
	public function positionMe(parentBoundingRect:Rectangle, ?padding:Int = 4, ?positionsToParent:Array<Direction> = null):FlxPoint
	{
		var d:Array<Direction> = positionsToParent==null ? [bottom, left]: positionsToParent;
		//var parentBoundingRect = parent;
		switch (d[0])
		{
			case bottom:
				titleUI.x  = parentBoundingRect.x + (d[1] == right ? parentBoundingRect.width : 0);
				titleUI.y = parentBoundingRect.y + parentBoundingRect.height /*+ (padding / 4)*/;
				
			case top :
				titleUI.x  = parentBoundingRect.x + (d[1] == right ? parentBoundingRect.width: 0);
				titleUI.y = parentBoundingRect.y;
				
			case left:
				titleUI.x  =  parentBoundingRect.x ;
				titleUI.y =  parentBoundingRect.y + (d[1] == top ? 0 : parentBoundingRect.height + padding) ;
			case right:
				titleUI.x  = parentBoundingRect.x + parentBoundingRect.width + padding;
				titleUI.y =  parentBoundingRect.y + (d[1] == top ? 0 : parentBoundingRect.height + padding );

		}
		rd.x = titleUI.x ;
		rd.y = titleUI.y + titleUI.height + (padding/4);
		
		this.boundingRect.x = titleUI.x;
		this.boundingRect.y = titleUI.y;
		this.boundingRect.width = Math.max (titleUI.width, rd.width);
		this.boundingRect.height = Math.max (titleUI.height, rd.height);
		pt.x = boundingRect.x + boundingRect.width ;
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
	inline function setWidth( s:String, a:Array<String>)
	{
		
		//var w = s.length > TITLE_SIZE ? s.length * TITLE_SIZE: 110;
		var w = s.length > TITLE_SIZE/widthMultiplier ? s.length * TITLE_SIZE/widthMultiplier: 110;
		//var w = s.length > TITLE_SIZE ? s.length * TITLE_SIZE: 110;
		for(i in a)
		{
			//if (i.length * RADIO_SIZE > w) w = i.length * RADIO_SIZE;
			#if debug
			//trace(s.length);
			#end
			if (i.length * RADIO_SIZE/widthMultiplier > w) w = i.length * RADIO_SIZE/widthMultiplier;
		}
		#if debug
		//trace(s.length);
		//trace(RADIO_SIZE/widthMultiplier);
		//trace(w);
		#end
		return w;
	}
	inline function get_boundingRect():Rectangle 
	{
		return boundingRect;
	}
	
	function callback(s:String)
	{
		blink(false);
		changeSignal.dispatch( _title , s);
	}
	
	function get_rd():FlxUIRadioGroup 
	{
		return rd;
	}
	
	function get__title():String 
	{
		return _title;
	}
	
	function set_rd(value:FlxUIRadioGroup):FlxUIRadioGroup 
	{
		return rd = value;
	}
}