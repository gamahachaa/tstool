package tstool.salt;

/**
 * ...
 * @author bb
 */
class SuperOffice 
{
	public var domain(get, null):String;
	public var number(get, null):String;
	@:isVar public var queue(get, set):String;
	public var desc(get, null):String;
	public var email(get, null):String;
	///////////////////// CONSTRUCTOR //////////////////////
	public function new(domain:String,number:String,queue:String,desc:String,email:String) 
	{
		this.email = email;
		this.desc = desc;
		this.queue = queue;
		this.number = number;
		this.domain = domain;
	}
	//////////////////// GETTERS ///////////////////////////
	function get_domain():String 
	{
		return domain;
	}
	
	function get_number():String 
	{
		return number;
	}
	
	function get_queue():String 
	{
		return queue;
	}
	
	function set_queue(value:String):String 
	{
		return queue = value;
	}
	
	function get_desc():String 
	{
		return desc;
	}
	
	function get_email():String 
	{
		return email;
	}
}