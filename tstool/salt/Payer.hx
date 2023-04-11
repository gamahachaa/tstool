package tstool.salt;

/**
 * ...
 * @author bb
 */
class Payer extends Role 
{

	public function new(name:String, ?id:String, ?authorised:Bool) 
	{
		super(payer, name, id, authorised);
	}
	
}