package tstool.salt;

/**
 * ...
 * @author bb
 */
class Adress 
{
	@:isVar public var _co(get, set):String;
	@:isVar public var _street(get, set):String;
	@:isVar public var _number(get, set):String;
	@:isVar public var _zip(get, set):String;
	@:isVar public var _city(get, set):String;

	public function new(?street:String="", ?number:String, ?zip:String="", ?city:String="", ?co:String="") 
	{
		_co = co;
		_street = street;
		_number = number;
		_city = city;
		_zip = zip;
	}
	public static function PARSE(s:String):Adress{
		var parts = s.split(",");
		//var numEreg:EReg = new EReg("^[0-9]+", "");
		var streetReg:EReg = new EReg("^([0-9a-zA-Z]+)\\s([\\S\\s-.]+)","g");
		var zipCityReg:EReg = new EReg("\\s([0-9]{4})\\s([\\S\\s-.]+)$", "g");
		if (!streetReg.match(parts[0]) || !zipCityReg.match(parts[1]))
		{
			return null;
		}
		else
			return new Adress(streetReg.matched(2),streetReg.matched(1),zipCityReg.matched(1),zipCityReg.matched(2));
	}
	function get__street():String 
	{
		return _street;
	}
	
	function set__street(value:String):String 
	{
		return _street = value;
	}
	
	function get__number():String 
	{
		return _number;
	}
	
	function set__number(value:String):String 
	{
		return _number = value;
	}
	
	function get__zip():String 
	{
		return _zip;
	}
	
	function set__zip(value:String):String 
	{
		return _zip = value;
	}
	
	function get__city():String 
	{
		return _city;
	}
	
	function set__city(value:String):String 
	{
		return _city = value;
	}
	
	function get__co():String 
	{
		return _co;
	}
	
	function set__co(value:String):String 
	{
		return _co = value;
	}
	
}