package tstool.salt;
import roles.Actor;

//import tstool.process.Actor;

/**
 * ...
 * @author bb
 */
enum Roles{
	owner;
	payer;
	user;
}
class Role extends Actor 
{
	//public var name(get, null):String;
	var role:Roles;

	public function new(role:Roles, name:String, id:String, ?authorised:Bool=true) 
	{
		super(id, authorised);
		this.role = role;
		this.name = name;
		
	}
	
	public function isSameAs(actor:Role)
	{
		return this.name == actor.name && this.iri == actor.iri;
	}
}