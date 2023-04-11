package tstool.salt;

/**
 * ...
 * @author bb
 */
class Owner extends Role 
{

	public function new(name:String, ?id:String, ?authorised:Bool) 
	{
		super(owner, name, id, authorised);
		
	}
	
}