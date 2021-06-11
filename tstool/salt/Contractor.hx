package tstool.salt;

/**
 * @todo create mobile contract
 * ...
 * @author bb
 */
enum Service{
	Fiber;
	Gigabox;
}
class Contractor
{
	public var service(get,null):Service;
	public var contractorID:String;
	public var voip:String;
	public var fix:String;
	public var mobile:String;
	public var address:Adress;
	@:isVar public var owner(get, set):Role;
	@:isVar public var payer(get, set):Role;
	@:isVar public var user(get, set):Role;
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
						?vtiOwnerValidateEmail:Bool = false, 
						?vtiBalance:Balance = null,
						?serviceVti:Service=Fiber)
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
		service = serviceVti;
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
	public function getEmails():Array<String>
	{
		var emails = [];
		if (owner !=null && owner.iri != "") emails.push(owner.iri);
		if (payer !=null && payer.iri != "" && !emails.contains(payer.iri)) emails.push(payer.iri);
		if (user !=null && user.iri != "" && !emails.contains(user.iri)) emails.push(user.iri);
		
		return emails;
	}
	
	function get_owner():Role 
	{
		return owner;
	}
	
	function set_owner(value:Role):Role 
	{
		return owner = value;
	}
	
	function get_payer():Role 
	{
		return payer;
	}
	
	function set_payer(value:Role):Role 
	{
		return payer = value;
	}
	
	function get_user():Role 
	{
		return user;
	}
	
	function get_service():Service 
	{
		return service;
	}
	
	function set_user(value:Role):Role 
	{
		return user = value;
	}

}