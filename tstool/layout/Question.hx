package tstool.layout;
import flixel.math.FlxPoint;
import haxe.Exception;
import tstool.layout.IPositionable.Direction;
import tstool.layout.IPositionable;

import flixel.text.FlxText;
import lime.math.Rectangle;

/**
 * ...
 * @author bb
 */
class Question extends FlxText implements IPositionable 
{
	var pt:FlxPoint;

	public function new(X:Float=0, Y:Float=0, FieldWidth:Float=0, ?Text:String, Size:Int=8, EmbeddedFont:Bool=true) 
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		boundingRect = new Rectangle(this.x ,this.y, this.width, this.height);
		pt = new FlxPoint(0, 0);
	}
	
	
	/* INTERFACE tstool.layout.IPositionable */
	
	public var boundingRect(get, null):Rectangle;
	
	function get_boundingRect():Rectangle 
	{
		this.boundingRect.x = this.x;
		this.boundingRect.y = this.y;
		this.boundingRect.width = this.width;
		this.boundingRect.height = this.height;
		return boundingRect;
	}
	
	public function positionMe(parentRectangle:Rectangle, ?padding:Int = 4, ?positionsToParent:Array<Direction> = null):FlxPoint 
	{
		var d:Array<Direction> = positionsToParent==null ? [bottom, left]: positionsToParent;
		//var p = parent;
		//trace(p);
		//trace(d);
		switch (d[0])
		{
			case bottom:
				switch(d[1])
				{
					case left : this.x = parentRectangle.x;
					case right : this.x = parentRectangle.x + parentRectangle.width + padding;
					case bottom : throw new Exception('cant position $[d[0]} and $[d[1]}');
					case top : throw new Exception('cant position $[d[0]} and $[d[1]}');
					//this.x  = parentRectangle.x + (d[1] == right ? parentRectangle.width + padding : 0);
					
				}
				this.y = parentRectangle.y + parentRectangle.height ;
				//trace("bottom");
			case top :
				switch(d[1])
				{
					case left : this.x = parentRectangle.x;
					case right : this.x = parentRectangle.x + parentRectangle.width + padding;
					case bottom : throw new Exception('cant position $[d[0]} and $[d[1]}');
					case top : throw new Exception('cant position $[d[0]} and $[d[1]}');
					
					
				}
				this.y = parentRectangle.y;
				//trace("top");
			case left:
				switch(d[1])
				{
					case bottom: this.y = parentRectangle.height + parentRectangle.y + padding ;
					case top : this.y = parentRectangle.y;
					case left : throw new Exception('cant position $[d[0]} and $[d[1]}');
					case right : throw new Exception('cant position $[d[0]} and $[d[1]}');
				}
				this.x  =  parentRectangle.x ;
				//this.y =  parentRectangle.y + (d[1] == top ? 0 : parentRectangle.height + padding) ;
				//inputtextfield.y = this.imputLabel.y + this.imputLabel.height;
			case right:
				switch(d[1])
				{
					case bottom: this.y = parentRectangle.height + parentRectangle.y + padding ;
					case top : this.y = parentRectangle.y;
					case left : throw new Exception('cant position $[d[0]} and $[d[1]}');
					case right : throw new Exception('cant position $[d[0]} and $[d[1]}');
				}
				this.x  = parentRectangle.x + parentRectangle.width + padding;
				//this.y =  p.y + (d[1] == top ? 0 : p.height + padding );

		}
		pt.x = boundingRect.x + boundingRect.width;
		pt.y = boundingRect.y + boundingRect.height;
		return pt;
	}
	
}