package tstool.salt;

/**
 * ...
 * @author bb
 */
enum ChangeableAttributes{
	 queues;
	 descs;
}
class SuperOffice 
{
	public var domain(get, null):String;
	public var number(get, null):String;
	@:isVar public var queue(get, set):String;
	@:isVar public var desc(get, set):String;
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
	public function clone():SuperOffice
	{
		return new SuperOffice(this.domain, this.number, this.queue, this.desc, this.email);
	}
	public function cloneWithNewAttributes(attr:Map<ChangeableAttributes, String>):SuperOffice
	{
		var clone = this.clone();
		if (attr.exists(queues))
		{
			clone.queue = attr.get(queues);
		}
		if (attr.exists(descs))
		{
			clone.desc = attr.get(descs);
		}
		return clone;
	}
	public function toString():String
	{
		return '${domain}_${number}_${queue}_${desc}';
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
	
	function set_desc(value:String):String 
	{
		return desc = value;
	}
	
	function get_email():String 
	{
		return email;
	}
}