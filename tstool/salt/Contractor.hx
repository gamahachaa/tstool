package tstool.salt;

/**
 * ...
 * @author bb
 */
class Contractor
{
	public var contractorID:String;
	public var voip:String;
	public var fix:String;
	public var mobile:String;
	public var address:Adress;
	public var owner:Role;
	public var payer:Role;
	public var user:Role;
	public var ownerValidateEmail:Bool;
	public var balance:Balance;
	public var distinctRoles:Array<Role>;
	public function new(?vtiContractor:String = "", 
						?vtiVoip:String="",
						?vtiFix:String="",
						?vtiMobile:String="",
						?vtiAdress:String="",
						?vtiOwner:Role=null,
						?vtiPayer:Role=null,
						?vtiUser:Role=null,
						?vtiOwnerValidateEmail:Bool=false, ?vtiBalance:Balance=null)
	{
		contractorID=StringTools.trim(vtiContractor);
		voip=StringTools.trim(vtiVoip);
		fix= StringTools.trim(vtiFix);
		mobile = StringTools.trim(vtiMobile);
		//trace(vtiAdress);
		address = Adress.PARSE(vtiAdress);
		//trace(address);
		owner=vtiOwner;
		payer=vtiPayer;
		user=vtiUser;
		ownerValidateEmail=vtiOwnerValidateEmail;
		balance = vtiBalance;
		if(this.owner!=null)
		setRoles();
	}
	
	function setRoles() 
	{
		distinctRoles = [this.owner];
		if (this.payer != null && !this.payer.isSameAs(this.owner)) distinctRoles.push(payer);
		if (user != null)
		{
			var addUser = false;
			for (i in distinctRoles)
			{
				if (user.isSameAs(i)) continue;
				else addUser = true;
			}
			if (addUser) distinctRoles.push(user);
		}		
	}
	public function reset()
	{
		contractorID="";
		voip="";
		fix="";
		mobile="";
		address=null;
		owner=null;
		payer=null;
		user=null;
		ownerValidateEmail=false;
		balance=null;
	}

}