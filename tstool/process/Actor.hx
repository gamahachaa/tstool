package tstool.process;

/**
 * ...
 * @author bbaudry
 */
class Actor 
{
	@:isVar public var authorized(get, set):Bool;
	@:isVar public var iri(get, set):String;
	public function new(?id:String="", ?authorised:Bool=true) 
	{
		this.iri = StringTools.trim(id);
		this.authorized = authorised;
	}
	function set_authorized(value:Bool):Bool
	{
		return authorized = value;
	}
	function get_authorized():Bool
	{
		return authorized;
	}

	function get_iri():String
	{
		return iri;
	}
	function set_iri(value:String):String
	{
		return iri = StringTools.trim(value);
	}
}