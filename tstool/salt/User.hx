package tstool.salt;

/**
 * ...
 * @author bb
 */
class User extends Role 
{

	public function new(name:String, ?id:String, ?authorised:Bool) 
	{
		super(name, id, authorised);
		
	}
	
}