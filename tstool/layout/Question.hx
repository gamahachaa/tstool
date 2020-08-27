package tstool.layout;
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

	public function new(X:Float=0, Y:Float=0, FieldWidth:Float=0, ?Text:String, Size:Int=8, EmbeddedFont:Bool=true) 
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		boundingRect = new Rectangle(this.x ,this.y, this.width, this.height);
		
	}
	
	
	/* INTERFACE tstool.layout.IPositionable */
	
	public var boundingRect(get, null):Rectangle;
	
	function get_boundingRect():Rectangle 
	{
		return boundingRect;
	}
	
	public function positionMe(parent:Rectangle, ?padding:Int = 4, ?positionsToParent:Array<Direction> = null):Void 
	{
		var d:Array<Direction> = positionsToParent==null ? [bottom, left]: positionsToParent;
		var p = parent;
		//trace(parent);
		//trace(d);
		switch (d[0])
		{
			case bottom:
				//trace("bottom");
				//trace(d[1] == right? "right":"left");
				this.x  = p.x + (d[1] == right ? p.width + padding : 0);
				this.y = p.y + p.height /*+ (padding / 4)*/;
				
			case top :
				//trace("top");
				this.x  = p.x + (d[1] == right ? p.width + padding: 0);
				this.y = p.y;
				
			case left:
				//trace("left");
				this.x  =  p.x ;
				this.y =  p.y + (d[1] == top ? 0 : p.height + padding) ;
				//inputtextfield.y = this.imputLabel.y + this.imputLabel.height;
			case right:
				//trace("right");
				this.x  = p.x + p.width + padding;
				this.y =  p.y + (d[1] == top ? 0 : p.height + padding );

		}
		this.boundingRect.x = this.x;
		this.boundingRect.y = this.y;
	}
	
}