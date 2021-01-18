package tstool.salt;
import haxe.Json;
import haxe.ds.StringMap;
import openfl.utils.Assets;
import tstool.process.Actor;
import tstool.utils.Csv;

/**
 * ...
 * @author bbaudry
 */
class Agent extends Actor
{
	//var adminFile:Csv;

	public var sAMAccountName(get, null):String;
	public var firstName(get, null):String;
	public var sirName(get, null):String;
	public var mobile(get, null):String;
	public var company(get, null):String;
	public var workLocation(get, null):String;
	public var division(get, null):String;
	public var department(get, null):String;
	public var directReports(get, null):String;
	public var accountExpires(get, null):String; //@todo Date

	public var title(get, null):String;
	public var initials(get, null):String;
	public var memberOf(get, null):StringMap<StringMap<Array<String>>>;
	//public var isAdmin(get, null):Bool;
	@:isVar public var canDispach(get, set):Bool;
	@:isVar public var mainLanguage(get, set):String;

	public function new(?jsonUser:Dynamic=null)
	{
		//adminFile = new Csv(Assets.getText("assets/data/admins.txt"),",",false);
		canDispach = true;
		//isAdmin = false;
		if (jsonUser != null )
		{
			super(jsonUser.attributes.mail, jsonUser.authorized);
			sAMAccountName = jsonUser.attributes.samaccountname ==null?"":jsonUser.attributes.samaccountname ;
			firstName = jsonUser.attributes.givenname  == null ? "":jsonUser.attributes.givenname ;
			sirName = jsonUser.attributes.sn == null ? "" :jsonUser.attributes.sn;
			mobile = jsonUser.attributes.mobile == null ? "": jsonUser.attributes.mobile;
			company = jsonUser.attributes.company == null ? "" : jsonUser.attributes.company;
			workLocation = jsonUser.attributes.l == null ? "": jsonUser.attributes.l;
			division = jsonUser.attributes.division == null ? "": jsonUser.attributes.division;
			department = jsonUser.attributes.department = null ? "": jsonUser.attributes.department;
			directReports = jsonUser.attributes.directreports == null ? "": jsonUser.attributes.directreports;
			accountExpires = jsonUser.attributes.accountexpires == null ? "": jsonUser.attributes.accountexpires; //@todo Date
			mainLanguage = jsonUser.attributes.msexchuserculture  == null ? "": jsonUser.attributes.msexchuserculture;
			title = jsonUser.attributes.title == null ? "" : jsonUser.attributes.title;
			initials = jsonUser.attributes.initials == null ? "": jsonUser.attributes.initials;
			memberOf = jsonUser.attributes.memberof == null ? new StringMap<StringMap<Array<String>>>(): jsonUser.attributes.memberof ;
			
			//trace(Main.adminFile.grid);
			//if (adminFile.dict.exists(sAMAccountName)) isAdmin = true;
		}
		else{
			#if debug
				trace("jsonUser is null");
			#end
		}
	}

	function get_sAMAccountName():String
	{
		return sAMAccountName;
	}

	function get_firstName():String
	{
		return firstName;
	}

	function get_sirName():String
	{
		return sirName;
	}

	function get_mobile():String
	{
		return mobile;
	}

	function get_company():String
	{
		return company;
	}

	function get_workLocation():String
	{
		return workLocation;
	}

	function get_division():String
	{
		return division;
	}

	function get_department():String
	{
		return department;
	}

	function get_directReports():String
	{
		return directReports;
	}

	function get_mainLanguage():String
	{
		return mainLanguage;
	}

	function set_mainLanguage(value:String):String
	{
		return mainLanguage = value;
	}

	function get_title():String
	{
		return title;
	}

	function get_initials():String
	{
		return initials;
	}

	function get_memberOf():StringMap<StringMap<Array<String>>>
	{
		return memberOf;
	}

	function get_accountExpires():String
	{
		return accountExpires;
	}
	
	function get_canDispach():Bool 
	{
		return canDispach;
	}
	
	//function get_isAdmin():Bool 
	//{
		//return isAdmin;
	//}
	
	function set_canDispach(value:Bool):Bool 
	{
		return canDispach = value;
	}
	@:keep
	public static function cretaDummyAgent():Agent
	{
		var a = {
			authorized : true,
			attributes:{
				company : "Qook",
				department : "Service Design",
				division : "Customer Operations",
				givenname : "Bruno",
				initials : "bb",
				mail : "bruno.baudry@salt.ch",
				isAdmin : true,
				msexchuserculture : "en",
				samaccountname : "bbaudry",
				sn : "Baudry",
				title : "Factotum",
				l : "Biel"
			}
		}
		return new Agent(a);
	}
}