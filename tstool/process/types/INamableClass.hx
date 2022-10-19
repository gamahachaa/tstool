package tstool.process.types;
import flixel.FlxState;

/**
 * @author bb
 */
interface INamableClass 
{
	public var _name(get, null):String;
	public var _class(get, null):Class<FlxState>;
	function get__class():Class<FlxState>;
	function get__name():String;
}